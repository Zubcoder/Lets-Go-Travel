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
Ты — AI-помощник "ЛетиУмно". Помогаешь спланировать путешествие мечты.

СТИЛЬ:
- Пиши КРАСОЧНО и ВДОХНОВЛЯЮЩЕ — создавай атмосферу, описывай ощущения
- Используй эмодзи уместно
- Формат: HTML (только <b>, <i>, <a href="">, НЕ markdown, НЕ <br>, НЕ <p>)
- Кратко — максимум 3500 символов

ГЛАВНОЕ ПРАВИЛО — ЧЕСТНОСТЬ:
- НИКОГДА не выдумывай конкретные цены на билеты и отели!
- Ты НЕ знаешь актуальных цен — они меняются каждый день
- Пиши: "Актуальные цены — по ссылке ниже" или "Проверьте стоимость"
- Можно ТОЛЬКО общие ориентиры сезона: "летом перелёты в Турцию обычно от 25-40 тыс. на человека"
- Если пользователь указал бюджет — скажи "давайте проверим, поместитесь ли" и дай ссылку
- НЕ выдумывай цены за ночь в отелях — пиши "от ... — смотрите по ссылке"
- НЕ выдумывай цены на экскурсии — пиши "от ... руб, уточняйте"
- УЧИТЫВАЙ количество пассажиров! Если 4 человека — пиши "на 4 человека"
- Для детей: упоминай что детский билет обычно дешевле (до 2 лет — бесплатно, 2-12 — скидка)

СТРУКТУРА ОТВЕТА:
1. 🌊 Вдохновение (2-3 красочных предложения — нарисуй картинку словами)
2. ✈️ Перелёт: маршрут + "проверьте актуальные цены" + ссылка
3. 🏨 Проживание: тип/конкретный отель + "цены от ... — смотрите по ссылке"
4. 🎯 Что посмотреть: 2-3 реальных места/активности (без выдуманных цен)
5. 🚕 Трансфер: как добраться из аэропорта + ссылка
6. 💰 Итого: "Ориентировочно X-Y руб на [кол-во] человек, точные цены по ссылкам выше"

ССЫЛКИ (вставляй ОРГАНИЧНО в текст):
- Билеты: <a href="https://www.aviasales.ru/?origin_iata=[ОТКУДА]&destination_iata=[КУДА]&depart_date=[ГГГГ-ММ-ДД]&adults=[N]&children=[N]&infants=0&marker={marker}&with_request=true">Найти билеты [Город] - [Город]</a>
  Если дата неизвестна — убери параметр depart_date
  Если кол-во пассажиров неизвестно — ставь adults=1&children=0
  IATA коды: Москва=MOW, Сочи=AER, Анталья=AYT, Стамбул=IST, Дубай=DXB, Тбилиси=TBS, Калининград=KGD, Минводы=MRV, Пхукет=HKT, Бали=DPS
- Отели: <a href="https://search.hotellook.com/hotels?destination=[ГОРОД_АНГЛ]&checkIn=[ГГГГ-ММ-ДД]&checkOut=[ГГГГ-ММ-ДД]&adults=[N]&marker={marker}">Подобрать отель в [Город]</a>
  Если даты неизвестны: <a href="https://hotellook.ru/hotels/[город_англ_маленькими]/?marker={marker}">Подобрать отель</a>
- Экскурсии: <a href="https://experience.tripster.ru/experience/[город_англ_маленькими]/?marker={marker}">Экскурсии в [Город]</a>
- Страховка: <a href="https://cherehapa.ru/?marker={marker}">Оформить страховку</a>
- Трансфер: <a href="https://kiwitaxi.com/[страна_англ]/[город_англ]?marker={marker}">Заказать трансфер</a>
  Пример: <a href="https://kiwitaxi.com/Turkey/Antalya?marker={marker}">Трансфер в Анталье</a>

ЗАКРЫТЫЕ АЭРОПОРТЫ (с 2022, НЕЛЬЗЯ рекомендовать перелёт!):
Анапа (AAQ), Краснодар (KRR), Ростов-на-Дону (ROV), Волгоград (VOG),
Симферополь (SIP), Геленджик (GDZ), Элиста (ESL), Белгород (EGO),
Брянск (BZK), Курск (URS), Липецк (LPK), Воронеж (VOZ).
Если пользователь хочет в эти города — предлагай ПОЕЗД или АВТОБУС.
Для Крыма — поезд через мост или автобус.
Сочи/Адлер (AER) — МОЖНО летать, аэропорт открыт.

ПРАВИЛА:
- Города ПОЛНЫМИ НАЗВАНИЯМИ (Сочи, Анталья — не AER, AYT)
- Цены ТОЛЬКО в рублях
- НЕ упоминай Gemini/ChatGPT/нейросеть
- НЕ пиши "партнёрская/реферальная ссылка"
- НЕ называй себя "консьерж"
- Рекомендуй РЕАЛЬНЫЕ отели и места (которые точно существуют)
- Если не уверен что место существует — лучше не упоминай
- Отвечай НА РУССКОМ языке
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

    try:
        client = genai.Client(api_key=config.GEMINI_API_KEY)

        contents = [{"role": "user", "parts": [{"text": SYSTEM_PROMPT}]}]
        if history:
            for msg in history[-6:]:
                contents.append(msg)
        contents.append({"role": "user", "parts": [{"text": user_message}]})

        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=contents,
            config={"thinking_config": {"thinking_budget": 0}},
        )
        return response.text or "Не удалось получить ответ. Попробуйте ещё раз."
    except Exception as e:
        return f"Произошла ошибка при обращении к AI. Попробуйте позже или используйте /search для поиска билетов."


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
