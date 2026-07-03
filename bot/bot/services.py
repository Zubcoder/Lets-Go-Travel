"""External service integrations: Travelpayouts flight search and Gemini AI."""

from __future__ import annotations

import aiohttp
from google import genai

from .config import config

TRAVELPAYOUTS_API = "https://api.travelpayouts.com"

SYSTEM_PROMPT = """\
Ты — AI-помощник для путешествий "Let's Go Travel".
Твоя задача — помочь пользователю спланировать поездку.
Отвечай кратко, структурировано и дружелюбно.
Используй эмодзи для наглядности.
Рекомендуй конкретные действия: искать билеты, бронировать отель, оформить страховку.
Если пользователь указал бюджет — укладывайся в него.
Давай советы по экономии.
Используй рубли (₽) для цен.
Не упоминай конкретные AI-модели (Gemini, ChatGPT). Говори "наш AI".
"""


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
    lines = [
        f"🏨 Отели: {config.HOTELLOOK_BASE}/{destination}?marker={marker}",
        f"🎭 Экскурсии: {config.TRIPSTER_BASE}?marker={marker}",
        f"🚗 Аренда авто: {config.DISCOVERCARS_BASE}?marker={marker}",
        f"🛡 Страховка: {config.CHEREHAPA_BASE}?marker={marker}",
        f"📱 eSIM: {config.YESIM_BASE}",
        f"🚕 Трансфер: {config.KIWITAXI_BASE}?marker={marker}",
    ]
    return "\n".join(lines)
