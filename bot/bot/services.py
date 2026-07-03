"""External service integrations: Travelpayouts flight search and Gemini AI."""

from __future__ import annotations

import aiohttp
from google import genai

from .config import config

TRAVELPAYOUTS_API = "https://api.travelpayouts.com"

# IATA code to city name mapping
IATA_CITIES = {
    "MOW": "Москва", "LED": "Санкт-Петербург", "AER": "Сочи",
    "SVX": "Екатеринбург", "KZN": "Казань", "OVB": "Новосибирск",
    "KRR": "Краснодар", "ROV": "Ростов-на-Дону", "UFA": "Уфа",
    "KGD": "Калининград", "MRV": "Минеральные Воды",
    "AYT": "Анталья", "IST": "Стамбул", "DXB": "Дубай",
    "HRG": "Хургада", "SSH": "Шарм-эль-Шейх", "GYD": "Баку",
    "TBS": "Тбилиси", "EVN": "Ереван", "BKK": "Бангкок",
    "HKT": "Пхукет", "MLE": "Мальдивы", "GOI": "Гоа",
    "DPS": "Бали", "NHA": "Нячанг",
    "KUF": "Самара", "MMK": "Мурманск", "ULY": "Ульяновск",
    "CSY": "Чебоксары", "TBW": "Тамбов", "KVX": "Киров", "MSQ": "Минск",
}


def city_name(iata: str) -> str:
    """Convert IATA code to city name."""
    return IATA_CITIES.get(iata.upper(), iata)


SYSTEM_PROMPT = """\
Ты — AI-помощник "ЛетиУмно". Помогаешь спланировать идеальное путешествие.

СТИЛЬ:
- Пиши КРАСОЧНО и ВДОХНОВЛЯЮЩЕ, как лучший travel-блогер
- Создавай атмосферу: описывай ощущения, виды, эмоции
- Используй эмодзи уместно
- Формат: HTML (используй <b>, <i>, <a href="">, НЕ markdown)
- Кратко (Telegram ограничен 4096 символов) — только самое важное

СТРУКТУРА:
1. Красочное вступление (1-2 предложения)
2. ✈️ Перелёт — цена + рекомендация
3. 🏨 Проживание — конкретный вариант
4. 🎯 Что делать — 1-2 активности
5. 💰 Итого бюджет

Ссылки (вставляй ОРГАНИЧНО, ОБЯЗАТЕЛЬНО указывай маршрут в URL):
- Билеты: <a href="https://www.aviasales.ru/search/[ОТКУДА][КУДА]1?marker={marker}">Найти билет</a>
  Пример: <a href="https://www.aviasales.ru/search/MOWAER1?marker={marker}">Москва - Сочи</a>
- Отели: <a href="https://www.hotellook.ru/hotels/[ГОРОД]?marker={marker}">Забронировать</a>
- Экскурсии: <a href="https://experience.tripster.ru/?marker={marker}">Подробнее</a>
- Страховка: <a href="https://cherehapa.ru/?marker={marker}">Оформить</a>
- Трансфер: <a href="https://kiwitaxi.com/?marker={marker}">Заказать</a>

ЗАКРЫТЫЕ АЭРОПОРТЫ (с 2022, НЕЛЬЗЯ рекомендовать перелёт туда!):
Анапа (AAQ), Краснодар (KRR), Ростов-на-Дону (ROV), Волгоград (VOG),
Симферополь (SIP), Геленджик (GDZ), Элиста (ESL), Белгород (EGO),
Брянск (BZK), Курск (URS), Липецк (LPK), Воронеж (VOZ).
Если пользователь хочет в эти города — предлагай ПОЕЗД или АВТОБУС, не самолёт.
Для Крыма — предлагай поезд через мост или автобус.
Для Сочи/Адлера (AER) — МОЖНО летать, аэропорт работает.

ПРАВИЛА:
- Города ПОЛНЫМИ НАЗВАНИЯМИ (Сочи, не AER)
- Цены в рублях
- НЕ упоминай Gemini/ChatGPT
- НЕ пиши "партнёрская ссылка"
- НЕ называй себя "консьерж" — ты просто помощник
- Будь конкретным: названия, цены, маршруты
- В ссылках на Aviasales ВСЕГДА указывай маршрут: /search/[ОТКУДА][КУДА]1
""".replace("{marker}", config.TRAVELPAYOUTS_MARKER)


async def search_flights(
    origin: str,
    destination: str,
    depart_date: str,
    return_date: str | None = None,
) -> list[dict]:
    """Search flights via Travelpayouts API."""
    url = f"{TRAVELPAYOUTS_API}/aviasales/v3/prices_for_dates"
    params = {
        "origin": origin,
        "destination": destination,
        "departure_at": depart_date,
        "unique": "false",
        "sorting": "price",
        "direct": "false",
        "currency": "rub",
        "limit": 5,
        "token": config.TRAVELPAYOUTS_TOKEN,
    }
    if return_date:
        params["return_at"] = return_date

    async with aiohttp.ClientSession() as session:
        async with session.get(url, params=params, timeout=aiohttp.ClientTimeout(total=15)) as resp:
            if resp.status != 200:
                return []
            data = await resp.json()
            return data.get("data", [])


async def search_popular_destinations(origin: str = "MOW") -> list[dict]:
    """Get popular cheap destinations from a given city."""
    url = f"{TRAVELPAYOUTS_API}/aviasales/v3/prices_for_dates"
    params = {
        "origin": origin,
        "unique": "true",
        "sorting": "price",
        "direct": "false",
        "currency": "rub",
        "limit": 10,
        "token": config.TRAVELPAYOUTS_TOKEN,
    }

    async with aiohttp.ClientSession() as session:
        async with session.get(url, params=params, timeout=aiohttp.ClientTimeout(total=15)) as resp:
            if resp.status != 200:
                return []
            data = await resp.json()
            return data.get("data", [])


async def ai_plan_trip(user_message: str, history: list[dict] | None = None) -> str:
    """Generate trip plan using Gemini."""
    if not config.GEMINI_API_KEY:
        return (
            "AI-планировщик временно недоступен. "
            "Используйте /search для поиска билетов!"
        )

    client = genai.Client(api_key=config.GEMINI_API_KEY)

    contents = [{"role": "user", "parts": [{"text": SYSTEM_PROMPT}]}]
    if history:
        for msg in history[-6:]:
            contents.append(msg)
    contents.append({"role": "user", "parts": [{"text": user_message}]})

    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=contents,
    )
    return response.text or "Не удалось получить ответ. Попробуйте ещё раз."


def build_aviasales_link(origin: str, destination: str, depart_date: str) -> str:
    """Build an affiliate link to Aviasales."""
    marker = config.TRAVELPAYOUTS_MARKER
    return (
        f"{config.AVIASALES_BASE}/search/"
        f"{origin}{depart_date.replace('-', '')}"
        f"{destination}1"
        f"?marker={marker}"
    )


def build_partner_links(destination: str) -> str:
    """Build a block of affiliate partner links for a destination."""
    marker = config.TRAVELPAYOUTS_MARKER
    dest_name = city_name(destination)
    lines = [
        f"🏨 <a href='{config.HOTELLOOK_BASE}/{destination}?marker={marker}'>Отели в {dest_name}</a>",
        f"🎭 <a href='{config.TRIPSTER_BASE}?marker={marker}'>Экскурсии</a>",
        f"🚗 <a href='{config.DISCOVERCARS_BASE}?marker={marker}'>Аренда авто (до 54%!)</a>",
        f"🛡 <a href='{config.CHEREHAPA_BASE}?marker={marker}'>Страховка (до 30%)</a>",
        f"📱 <a href='{config.YESIM_BASE}'>eSIM для связи</a>",
        f"🚕 <a href='{config.KIWITAXI_BASE}?marker={marker}'>Трансфер</a>",
    ]
    return "\n".join(lines)
