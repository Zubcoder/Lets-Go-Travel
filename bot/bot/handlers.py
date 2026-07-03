"""Telegram bot command and message handlers."""

from __future__ import annotations

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
    search_flights,
    search_popular_destinations,
)

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
    builder.button(text="✈️ Поиск билетов", callback_data="action:search")
    builder.button(text="🌍 Дешёвые направления", callback_data="action:popular")
    builder.button(text="🤖 Travel AI", callback_data="action:plan")
    builder.button(text="📱 Скачать приложение", url=config.RUSTORE_URL)
    builder.button(text="🌐 Сайт", url=config.WEBSITE_URL)
    builder.adjust(2, 2, 1)
    return builder.as_markup()


# ── /start ───────────────────────────────────────────────────────────────────


@router.message(CommandStart())
async def cmd_start(message: types.Message) -> None:
    text = (
        "✈️ <b>ЛетиУмно</b> — AI-помощник для путешествий!\n\n"
        "Я помогу найти дешёвые авиабилеты, спланировать маршрут "
        "и сэкономить на поездке.\n\n"
        "Что умею:\n"
        "• /search — поиск авиабилетов\n"
        "• /popular — дешёвые направления из Москвы\n"
        "• /plan — AI-планировщик маршрута\n"
        "• /partners — все партнёрские сервисы\n"
        "• /app — скачать мобильное приложение\n\n"
        "Выберите действие:"
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
        "📱 <b>ЛетиУмно</b> — мобильное приложение\n\n"
        "В приложении доступно больше возможностей:\n"
        "• Полный AI-планировщик маршрутов\n"
        "• Поиск отелей с фото и отзывами\n"
        "• Сравнение цен по всем авиакомпаниям\n"
        "• Тёмная и светлая тема\n"
        "• RU/EN язык\n",
        reply_markup=builder.as_markup(),
        parse_mode="HTML",
    )


# ── /partners ────────────────────────────────────────────────────────────────


@router.message(Command("partners"))
async def cmd_partners(message: types.Message) -> None:
    marker = config.TRAVELPAYOUTS_MARKER
    text = (
        "🤝 <b>Наши партнёры</b> — лучшие цены:\n\n"
        f"✈️ <b>Авиабилеты:</b> aviasales.ru?marker={marker}\n"
        f"🏨 <b>Отели:</b> hotellook.ru?marker={marker}\n"
        f"🎭 <b>Экскурсии:</b> tripster.ru, sputnik8.com\n"
        f"🚗 <b>Аренда авто:</b> discovercars.com (до 54% комиссия!)\n"
        f"🛡 <b>Страховка:</b> cherehapa.ru (до 30%)\n"
        f"📱 <b>eSIM:</b> yesim.app (18%)\n"
        f"🚕 <b>Трансфер:</b> kiwitaxi.com (9-11%)\n\n"
        "Все ссылки — партнёрские. Спасибо за поддержку! ❤️"
    )
    await message.answer(text, parse_mode="HTML")


# ── /search ──────────────────────────────────────────────────────────────────


@router.message(Command("search"))
@router.callback_query(F.data == "action:search")
async def cmd_search(event: types.Message | types.CallbackQuery, state: FSMContext) -> None:
    text = "✈️ Введите город <b>вылета</b> (код IATA, например: MOW, LED, SVX):"
    await state.set_state(SearchStates.waiting_origin)
    if isinstance(event, types.CallbackQuery):
        await event.answer()
        await event.message.answer(text, parse_mode="HTML")
    else:
        await event.answer(text, parse_mode="HTML")


@router.message(SearchStates.waiting_origin)
async def process_origin(message: types.Message, state: FSMContext) -> None:
    origin = message.text.strip().upper()[:3]
    await state.update_data(origin=origin)
    await state.set_state(SearchStates.waiting_destination)
    await message.answer(
        f"Вылет из: <b>{origin}</b>\n\n"
        "Введите город <b>прилёта</b> (код IATA, например: AYT, IST, DXB):",
        parse_mode="HTML",
    )


@router.message(SearchStates.waiting_destination)
async def process_destination(message: types.Message, state: FSMContext) -> None:
    destination = message.text.strip().upper()[:3]
    await state.update_data(destination=destination)
    await state.set_state(SearchStates.waiting_date)
    await message.answer(
        f"Направление: <b>{destination}</b>\n\n"
        "Введите <b>дату вылета</b> (формат: 2026-08-15):",
        parse_mode="HTML",
    )


@router.message(SearchStates.waiting_date)
async def process_date(message: types.Message, state: FSMContext) -> None:
    date_str = message.text.strip()
    data = await state.get_data()
    origin = data["origin"]
    destination = data["destination"]
    await state.clear()

    await message.answer("🔍 Ищу билеты...")

    results = await search_flights(origin, destination, date_str)

    if not results:
        await message.answer(
            "Билеты не найдены. Попробуйте другие даты или направление.\n"
            "Используйте /popular для просмотра популярных направлений.",
        )
        return

    lines = [f"✈️ <b>{origin} → {destination}</b> ({date_str})\n"]
    for i, flight in enumerate(results[:5], 1):
        price = flight.get("price", "?")
        airline = flight.get("airline", "??")
        transfers = flight.get("transfers", 0)
        transfer_text = "прямой" if transfers == 0 else f"{transfers} пересадк."
        lines.append(f"{i}. <b>{price:,}₽</b> — {airline}, {transfer_text}")

    link = build_aviasales_link(origin, destination, date_str)
    lines.append(f"\n🔗 <a href='{link}'>Купить на Aviasales →</a>")

    partners = build_partner_links(destination)
    lines.append(f"\n📦 <b>Дополнительно:</b>\n{partners}")

    builder = InlineKeyboardBuilder()
    builder.button(text="🔗 Купить билет", url=link)
    builder.button(text="📱 Полный поиск в приложении", url=config.RUSTORE_URL)
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

    await msg.answer("🔍 Ищу дешёвые направления из Москвы...")

    results = await search_popular_destinations("MOW")

    if not results:
        await msg.answer("Не удалось загрузить. Попробуйте позже.")
        return

    lines = ["🌍 <b>Дешёвые направления из Москвы:</b>\n"]
    for i, r in enumerate(results[:10], 1):
        dest = r.get("destination", "???")
        price = r.get("price", "?")
        date = r.get("departure_at", "")[:10]
        lines.append(f"{i}. <b>{dest}</b> — {price:,}₽ ({date})")

    lines.append("\n✈️ Используйте /search для поиска по конкретному направлению")

    builder = InlineKeyboardBuilder()
    builder.button(text="📱 Больше в приложении", url=config.RUSTORE_URL)

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
        "🤖 <b>ЛетиУмно AI</b> — Умный помощник в путешествии\n\n"
        "Опишите ваше идеальное путешествие, например:\n"
        "<i>Хочу на море в августе, бюджет 50 000₽ на двоих, из Москвы</i>\n\n"
        "Для выхода из режима планировщика — /cancel"
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
    await message.answer("Планировщик завершён.", reply_markup=_main_keyboard())


@router.message(PlanStates.chatting)
async def process_plan(message: types.Message) -> None:
    user_id = message.from_user.id
    user_text = message.text or ""

    user_history = _history.get(user_id, [])

    await message.answer("🤔 Планирую...")

    response = await ai_plan_trip(user_text, user_history)

    # Save to history
    user_history.append({"role": "user", "parts": [{"text": user_text}]})
    user_history.append({"role": "model", "parts": [{"text": response}]})
    _history[user_id] = user_history[-10:]

    builder = InlineKeyboardBuilder()
    builder.button(text="✈️ Искать билеты", callback_data="action:search")
    builder.button(text="📱 Полный план в приложении", url=config.RUSTORE_URL)
    builder.adjust(1)

    # Truncate if too long for Telegram (4096 chars max)
    if len(response) > 3800:
        response = response[:3800] + "\n\n... <i>Полный план доступен в приложении</i>"

    await message.answer(
        response,
        reply_markup=builder.as_markup(),
        parse_mode="HTML",
        disable_web_page_preview=True,
    )


# ── Catch-all free text ─────────────────────────────────────────────────────


@router.message(F.text)
async def handle_text(message: types.Message) -> None:
    await message.answer(
        "Выберите действие:",
        reply_markup=_main_keyboard(),
    )
