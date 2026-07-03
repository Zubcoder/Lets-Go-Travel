"""Telegram bot command and message handlers."""

from __future__ import annotations

import re

from aiogram import F, Router, types
from aiogram.filters import Command, CommandStart
from aiogram.fsm.context import FSMContext
from aiogram.fsm.state import State, StatesGroup
from aiogram.utils.keyboard import InlineKeyboardBuilder

from .config import config
from .services import (
    ai_plan_trip,
    build_aviasales_link,
    build_partner_links,
    city_name,
    search_flights,
    search_popular_destinations,
)

# Telegram HTML only supports: b, i, u, s, a, code, pre, tg-spoiler, blockquote
_ALLOWED_TAGS = {"b", "i", "u", "s", "a", "code", "pre", "tg-spoiler", "blockquote"}


def sanitize_html(text: str) -> str:
    """Remove unsupported HTML tags, keep only Telegram-allowed ones."""
    # Replace <br>, <br/>, <br /> with newlines
    text = re.sub(r"<br\s*/?>", "\n", text, flags=re.IGNORECASE)
    # Replace <p>...</p> with content + double newline
    text = re.sub(r"<p>(.*?)</p>", r"\1\n\n", text, flags=re.IGNORECASE | re.DOTALL)
    # Remove opening tags not in allowed list (but keep their content)
    def _strip_tag(m: re.Match) -> str:
        tag = m.group(1).lower().split()[0]
        if tag in _ALLOWED_TAGS:
            return m.group(0)
        return ""
    text = re.sub(r"<(/?)(\w+)([^>]*)>", lambda m: m.group(0) if m.group(2).lower().split("/")[0] in _ALLOWED_TAGS else "", text)
    return text.strip()

router = Router()

# Conversation history per user (in-memory, resets on restart)
_history: dict[int, list[dict]] = {}


class SearchStates(StatesGroup):
    waiting_origin = State()
    waiting_destination = State()
    waiting_date = State()


class PlanStates(StatesGroup):
    chatting = State()


def _main_keyboard() -> types.InlineKeyboardMarkup:
    builder = InlineKeyboardBuilder()
    builder.button(text="🤖 Travel AI", callback_data="action:plan")
    builder.button(text="✈️ Дешёвые билеты", callback_data="action:popular")
    builder.button(text="📱 Скачать приложение", url=config.RUSTORE_URL)
    builder.button(text="🌐 Сайт", url=config.WEBSITE_URL)
    builder.adjust(1, 1, 2)
    return builder.as_markup()


# ── /start ───────────────────────────────────────────────────────────────────


@router.message(CommandStart())
async def cmd_start(message: types.Message) -> None:
    text = (
        "🌟 <b>ЛетиУмно</b> — ваш умный помощник в путешествиях\n\n"
        "Представьте: через пару минут у вас будет готовый план "
        "идеального путешествия — с перелётом, отелем, экскурсиями "
        "и точным бюджетом. Всё это бесплатно.\n\n"
        "💬 <b>Просто напишите мне:</b>\n"
        "<i>«Хочу на море в августе, 60 000₽ на двоих»</i>\n\n"
        "И я подберу лучшие варианты с реальными ценами!\n\n"
        "Или выберите:"
    )
    await message.answer(text, reply_markup=_main_keyboard(), parse_mode="HTML")


# ── /app ─────────────────────────────────────────────────────────────────────


@router.message(Command("app"))
async def cmd_app(message: types.Message) -> None:
    builder = InlineKeyboardBuilder()
    builder.button(text="📱 Скачать в RuStore", url=config.RUSTORE_URL)
    builder.button(text="🌐 Открыть сайт", url=config.WEBSITE_URL)
    builder.adjust(1)
    await message.answer(
        "📱 <b>ЛетиУмно</b> — полная версия\n\n"
        "В приложении вас ждёт:\n"
        "• 🤖 AI-планировщик без ограничений\n"
        "• ✈️ Сравнение цен по всем авиакомпаниям\n"
        "• 🏨 Отели с фото и отзывами\n"
        "• 🎯 Экскурсии и активности\n"
        "• 💰 Автоматический подсчёт бюджета\n\n"
        "<i>Вы в одном шаге от идеального путешествия!</i> ✨",
        reply_markup=builder.as_markup(),
        parse_mode="HTML",
    )


# ── /partners ────────────────────────────────────────────────────────────────


@router.message(Command("partners"))
async def cmd_partners(message: types.Message) -> None:
    marker = config.TRAVELPAYOUTS_MARKER
    text = (
        "🌍 <b>Проверенные сервисы для путешествий:</b>\n\n"
        f"✈️ <a href='{config.AVIASALES_BASE}?marker={marker}'>Авиабилеты</a> — сравнение цен 728 авиакомпаний\n"
        f"🏨 <a href='{config.HOTELLOOK_BASE}?marker={marker}'>Отели</a> — лучшие цены по всему миру\n"
        f"🎭 <a href='{config.TRIPSTER_BASE}?marker={marker}'>Экскурсии</a> — авторские туры с местными гидами\n"
        f"🚗 <a href='{config.DISCOVERCARS_BASE}?marker={marker}'>Аренда авто</a> — от 900₽/день\n"
        f"🛡 <a href='{config.CHEREHAPA_BASE}?marker={marker}'>Страховка</a> — оформление за 2 минуты\n"
        f"📱 <a href='{config.YESIM_BASE}'>eSIM</a> — интернет в 150+ странах\n"
        f"🚕 <a href='{config.KIWITAXI_BASE}?marker={marker}'>Трансфер</a> — встреча в аэропорту\n\n"
        "Все сервисы проверены и рекомендованы нашим AI ❤️"
    )
    await message.answer(text, parse_mode="HTML", disable_web_page_preview=True)


# ── /search ──────────────────────────────────────────────────────────────────


@router.message(Command("search"))
@router.callback_query(F.data == "action:search")
async def cmd_search(event: types.Message | types.CallbackQuery, state: FSMContext) -> None:
    text = (
        "✈️ Введите город <b>вылета</b>:\n\n"
        "Примеры: Москва, Питер, Екатеринбург\n"
        "<i>(или код IATA: MOW, LED, SVX)</i>"
    )
    await state.set_state(SearchStates.waiting_origin)
    if isinstance(event, types.CallbackQuery):
        await event.answer()
        await event.message.answer(text, parse_mode="HTML")
    else:
        await event.answer(text, parse_mode="HTML")


# City name to IATA mapping for search
_CITY_TO_IATA = {
    "москва": "MOW", "питер": "LED", "санкт-петербург": "LED",
    "спб": "LED", "сочи": "AER", "екатеринбург": "SVX",
    "казань": "KZN", "новосибирск": "OVB", "краснодар": "KRR",
    "ростов": "ROV", "уфа": "UFA", "калининград": "KGD",
    "самара": "KUF", "анталья": "AYT", "стамбул": "IST",
    "дубай": "DXB", "хургада": "HRG", "баку": "GYD",
    "тбилиси": "TBS", "ереван": "EVN", "бангкок": "BKK",
    "пхукет": "HKT", "бали": "DPS", "минск": "MSQ",
}


def _resolve_city(text: str) -> str:
    """Convert city name to IATA code."""
    clean = text.strip().lower()
    if clean in _CITY_TO_IATA:
        return _CITY_TO_IATA[clean]
    # If 3 uppercase letters, treat as IATA
    if len(text.strip()) == 3 and text.strip().isalpha():
        return text.strip().upper()
    return text.strip().upper()[:3]


@router.message(SearchStates.waiting_origin)
async def process_origin(message: types.Message, state: FSMContext) -> None:
    origin = _resolve_city(message.text or "")
    await state.update_data(origin=origin)
    await state.set_state(SearchStates.waiting_destination)
    await message.answer(
        f"Вылет из: <b>{city_name(origin)}</b>\n\n"
        "Куда летим? Введите город <b>прилёта</b>:\n"
        "<i>Сочи, Анталья, Стамбул, Дубай...</i>",
        parse_mode="HTML",
    )


@router.message(SearchStates.waiting_destination)
async def process_destination(message: types.Message, state: FSMContext) -> None:
    destination = _resolve_city(message.text or "")
    await state.update_data(destination=destination)
    await state.set_state(SearchStates.waiting_date)
    await message.answer(
        f"Направление: <b>{city_name(destination)}</b> ✈️\n\n"
        "Когда летим? Введите <b>дату вылета</b>:\n"
        "<i>Формат: 2026-08-15</i>",
        parse_mode="HTML",
    )


@router.message(SearchStates.waiting_date)
async def process_date(message: types.Message, state: FSMContext) -> None:
    date_str = message.text.strip()
    data = await state.get_data()
    origin = data["origin"]
    destination = data["destination"]
    await state.clear()

    await message.answer("🔍 Ищу лучшие цены...")

    results = await search_flights(origin, destination, date_str)

    if not results:
        await message.answer(
            f"😔 Билеты {city_name(origin)} → {city_name(destination)} не найдены.\n\n"
            "Попробуйте другие даты или посмотрите /popular",
        )
        return

    origin_name = city_name(origin)
    dest_name = city_name(destination)

    lines = [f"✈️ <b>{origin_name} → {dest_name}</b>\n"]
    for i, flight in enumerate(results[:5], 1):
        price = flight.get("price", "?")
        airline = flight.get("airline", "??")
        transfers = flight.get("transfers", 0)
        transfer_text = "прямой ✨" if transfers == 0 else f"{transfers} пересадк."
        lines.append(f"{i}. <b>{price:,}₽</b> — {airline}, {transfer_text}")

    link = build_aviasales_link(origin, destination, date_str)
    lines.append(f"\n🔥 <a href='{link}'>Забронировать лучшую цену →</a>")

    partners = build_partner_links(destination)
    lines.append(f"\n🎁 <b>Подготовьтесь к поездке:</b>\n{partners}")

    builder = InlineKeyboardBuilder()
    builder.button(text="🔥 Забронировать билет", url=link)
    builder.button(text="📱 Больше в приложении", url=config.RUSTORE_URL)
    builder.adjust(1)

    await message.answer(
        "\n".join(lines),
        reply_markup=builder.as_markup(),
        parse_mode="HTML",
        disable_web_page_preview=True,
    )


# ── /popular ─────────────────────────────────────────────────────────────────


@router.message(Command("popular"))
@router.callback_query(F.data == "action:popular")
async def cmd_popular(event: types.Message | types.CallbackQuery) -> None:
    msg = event.message if isinstance(event, types.CallbackQuery) else event
    if isinstance(event, types.CallbackQuery):
        await event.answer()

    await msg.answer("🔍 Ищу самые выгодные направления...")

    results = await search_popular_destinations("MOW")

    if not results:
        await msg.answer("Не удалось загрузить. Попробуйте позже.")
        return

    lines = ["🌍 <b>Куда улететь дешевле всего:</b>\n"]
    for i, r in enumerate(results[:10], 1):
        dest = r.get("destination", "???")
        dest_name = city_name(dest)
        price = r.get("price", "?")
        date = r.get("departure_at", "")[:10]
        lines.append(f"{i}. <b>{dest_name}</b> — {price:,}₽ ({date})")

    lines.append(
        "\n💡 <i>Напишите мне название города — я подберу "
        "полный план с отелем и экскурсиями!</i>"
    )

    builder = InlineKeyboardBuilder()
    builder.button(text="🤖 Спланировать поездку", callback_data="action:plan")
    builder.button(text="📱 Приложение", url=config.RUSTORE_URL)
    builder.adjust(1)

    await msg.answer(
        "\n".join(lines),
        reply_markup=builder.as_markup(),
        parse_mode="HTML",
    )


# ── /plan (AI) ───────────────────────────────────────────────────────────────


@router.message(Command("plan"))
@router.callback_query(F.data == "action:plan")
async def cmd_plan(event: types.Message | types.CallbackQuery, state: FSMContext) -> None:
    text = (
        "🌟 <b>ЛетиУмно AI</b> — ваш умный помощник в путешествиях\n\n"
        "Расскажите о путешествии мечты, и я создам "
        "идеальный план с ценами и бронированием.\n\n"
        "💬 <b>Например:</b>\n"
        "<i>Хочу на море в августе, бюджет 60 000₽ на двоих, из Москвы</i>\n\n"
        "Для выхода — /cancel"
    )
    await state.set_state(PlanStates.chatting)
    if isinstance(event, types.CallbackQuery):
        await event.answer()
        await event.message.answer(text, parse_mode="HTML")
    else:
        await event.answer(text, parse_mode="HTML")


@router.message(PlanStates.chatting, Command("cancel"))
async def cancel_plan(message: types.Message, state: FSMContext) -> None:
    user_id = message.from_user.id
    _history.pop(user_id, None)
    await state.clear()
    await message.answer(
        "✈️ До новых путешествий! Возвращайтесь когда угодно.",
        reply_markup=_main_keyboard(),
    )


@router.message(PlanStates.chatting)
async def process_plan(message: types.Message) -> None:
    user_id = message.from_user.id
    user_text = message.text or ""

    user_history = _history.get(user_id, [])

    await message.answer("✨ Подбираю лучшие варианты...")

    response = await ai_plan_trip(user_text, user_history)

    # Save to history
    user_history.append({"role": "user", "parts": [{"text": user_text}]})
    user_history.append({"role": "model", "parts": [{"text": response}]})
    _history[user_id] = user_history[-10:]

    builder = InlineKeyboardBuilder()
    builder.button(text="📱 Полный план в приложении", url=config.RUSTORE_URL)
    builder.button(text="🌐 Сайт", url=config.WEBSITE_URL)
    builder.adjust(1)

    # Sanitize HTML and truncate
    response = sanitize_html(response)
    if len(response) > 3800:
        response = response[:3800] + "\n\n... <i>Полный план доступен в приложении</i> 📱"

    try:
        await message.answer(
            response,
            reply_markup=builder.as_markup(),
            parse_mode="HTML",
            disable_web_page_preview=True,
        )
    except Exception:
        # Fallback: send without HTML parsing if sanitization wasn't enough
        await message.answer(
            response,
            reply_markup=builder.as_markup(),
            disable_web_page_preview=True,
        )


# ── Catch-all free text → auto-plan ─────────────────────────────────────────


@router.message(F.text)
async def handle_text(message: types.Message, state: FSMContext) -> None:
    """Any free text message triggers AI planning directly."""
    user_id = message.from_user.id
    user_text = message.text or ""

    # If it looks like a travel query, plan it directly
    await state.set_state(PlanStates.chatting)

    user_history = _history.get(user_id, [])

    await message.answer("✨ Подбираю лучшие варианты...")

    response = await ai_plan_trip(user_text, user_history)

    user_history.append({"role": "user", "parts": [{"text": user_text}]})
    user_history.append({"role": "model", "parts": [{"text": response}]})
    _history[user_id] = user_history[-10:]

    builder = InlineKeyboardBuilder()
    builder.button(text="📱 Больше в приложении", url=config.RUSTORE_URL)
    builder.button(text="🌐 Сайт", url=config.WEBSITE_URL)
    builder.adjust(2)

    # Sanitize HTML and truncate
    response = sanitize_html(response)
    if len(response) > 3800:
        response = response[:3800] + "\n\n... <i>Полный план доступен в приложении</i> 📱"

    try:
        await message.answer(
            response,
            reply_markup=builder.as_markup(),
            parse_mode="HTML",
            disable_web_page_preview=True,
        )
    except Exception:
        # Fallback: send without HTML parsing if sanitization wasn't enough
        await message.answer(
            response,
            reply_markup=builder.as_markup(),
            disable_web_page_preview=True,
        )
