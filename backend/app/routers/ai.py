import httpx
from google import genai
from google.genai import types
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from ..config import settings

router = APIRouter()

TRAVELPAYOUTS_BASE = "https://api.travelpayouts.com/aviasales/v3"

# IATA code to city name mapping for popular Russian cities
IATA_CITIES = {
    "MOW": "Москва", "LED": "Санкт-Петербург", "AER": "Сочи",
    "SVX": "Екатеринбург", "KZN": "Казань", "OVB": "Новосибирск",
    "KRR": "Краснодар", "ROV": "Ростов-на-Дону", "UFA": "Уфа",
    "VOG": "Волгоград", "KGD": "Калининград", "MRV": "Минеральные Воды",
    "AYT": "Анталья", "IST": "Стамбул", "DXB": "Дубай",
    "HRG": "Хургада", "SSH": "Шарм-эль-Шейх", "GYD": "Баку",
    "TBS": "Тбилиси", "EVN": "Ереван", "BKK": "Бангкок",
    "HKT": "Пхукет", "MLE": "Мальдивы", "GOI": "Гоа",
    "CEB": "Себу", "DPS": "Бали", "NHA": "Нячанг",
    "PEK": "Пекин", "ICN": "Сеул", "TYO": "Токио",
    "DME": "Москва", "SVO": "Москва", "VKO": "Москва",
    "KUF": "Самара", "MMK": "Мурманск", "ARH": "Архангельск",
    "ULY": "Ульяновск", "CSY": "Чебоксары", "TBW": "Тамбов",
    "KVX": "Киров", "MSQ": "Минск",
}


def city_name(iata: str) -> str:
    return IATA_CITIES.get(iata.upper(), iata)


async def _fetch_cheap_flights(origin: str = "MOW", limit: int = 5) -> list[dict]:
    """Fetch real cheap flights for context."""
    params = {
        "origin": origin,
        "unique": "true",
        "sorting": "price",
        "currency": "rub",
        "limit": limit,
        "token": settings.travelpayouts_token,
    }
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(f"{TRAVELPAYOUTS_BASE}/prices_for_dates", params=params)
            if resp.status_code == 200:
                return resp.json().get("data", [])
    except Exception:
        pass
    return []


class PlanRequest(BaseModel):
    query: str
    locale: str = "ru"


@router.post("/plan")
async def plan_trip(request: PlanRequest):
    if not settings.gemini_api_key:
        raise HTTPException(status_code=503, detail="AI service not configured")

    client = genai.Client(api_key=settings.gemini_api_key)

    marker = settings.travelpayouts_marker

    # Fetch real flight data for context
    flights_data = await _fetch_cheap_flights()
    flights_context = ""
    if flights_data:
        lines = []
        for f in flights_data[:5]:
            dest = f.get("destination", "")
            price = f.get("price", 0)
            date = f.get("departure_at", "")[:10]
            lines.append(f"- {city_name(dest)} ({dest}): {price} rub, дата {date}")
        flights_context = "\n".join(lines)

    lang = "русском" if request.locale == "ru" else "английском"

    prompt = f"""Ты — AI-помощник "ЛетиУмно". Помогаешь спланировать путешествие мечты.

СТИЛЬ ОТВЕТА:
- Пиши КРАСОЧНО и ВДОХНОВЛЯЮЩЕ — создавай атмосферу, описывай ощущения
- Используй эмодзи уместно
- Формат: Markdown (заголовки ##, списки, ссылки [текст](url))
- Язык: {lang}

ГЛАВНОЕ ПРАВИЛО — ЧЕСТНОСТЬ:
- НИКОГДА не выдумывай конкретные цены на билеты и отели!
- Ты НЕ знаешь актуальных цен — они меняются каждый день
- Пиши: "Актуальные цены — по ссылке" или "Проверьте стоимость"
- Можно ТОЛЬКО общие ориентиры: "летом в Турцию обычно от 25-40 тыс. на человека"
- НЕ выдумывай цены за ночь в отелях — пиши "от ... — смотрите по ссылке"
- НЕ выдумывай цены на экскурсии — пиши "от ... руб, уточняйте"
- УЧИТЫВАЙ количество пассажиров! Если 4 человека — умножай и пиши "на 4 человека"
- Для детей: упоминай что детский билет дешевле (до 2 лет бесплатно, 2-12 скидка)

СТРУКТУРА ОТВЕТА:
1. 🌊 Вдохновение (2-3 красочных предложения)
2. ✈️ Перелёт: маршрут + "проверьте актуальные цены" + ссылка
3. 🏨 Проживание: тип/отель + "цены от ... — смотрите по ссылке"
4. 🎯 Что посмотреть: 2-3 реальных места (без выдуманных цен)
5. 🚕 Трансфер: как добраться из аэропорта + ссылка
6. 🛡 Страховка: кратко + ссылка
7. 💰 Итого: "Ориентировочно X-Y руб, точные цены по ссылкам выше"

ССЫЛКИ (вставляй ОРГАНИЧНО):
- Билеты: [Найти билеты Москва - Сочи](https://www.aviasales.ru/?origin_iata=[ОТКУДА]&destination_iata=[КУДА]&depart_date=[ГГГГ-ММ-ДД]&adults=[N]&children=[N]&infants=0&marker={marker}&with_request=true)
  Если дата неизвестна — убери depart_date. Если пассажиры неизвестны — adults=1&children=0
  IATA: Москва=MOW, Сочи=AER, Анталья=AYT, Стамбул=IST, Дубай=DXB, Тбилиси=TBS, Калининград=KGD, Минводы=MRV, Пхукет=HKT, Бали=DPS
- Отели: [Подобрать отель](https://search.hotellook.com/hotels?destination=[ГОРОД_АНГЛ]&checkIn=[ГГГГ-ММ-ДД]&checkOut=[ГГГГ-ММ-ДД]&adults=[N]&marker={marker})
  Без дат: [Отели](https://hotellook.ru/hotels/[город_англ]/?marker={marker})
- Экскурсии: [Экскурсии](https://experience.tripster.ru/experience/[город_англ]/?marker={marker})
- Страховка: [Оформить страховку](https://cherehapa.ru/?marker={marker})
- Трансфер: [Заказать трансфер](https://kiwitaxi.com/[Country]/[City]?marker={marker})

ЗАКРЫТЫЕ АЭРОПОРТЫ (с 2022, НЕЛЬЗЯ рекомендовать перелёт!):
Анапа (AAQ), Краснодар (KRR), Ростов-на-Дону (ROV), Волгоград (VOG),
Симферополь (SIP), Геленджик (GDZ), Элиста (ESL), Белгород (EGO),
Брянск (BZK), Курск (URS), Липецк (LPK), Воронеж (VOZ).
Если пользователь хочет в эти города — предлагай ПОЕЗД или АВТОБУС.
Для Крыма — поезд через мост или автобус.
Сочи/Адлер (AER) — МОЖНО летать, аэропорт открыт.

РЕАЛЬНЫЕ ДАННЫЕ О ДЕШЁВЫХ ПЕРЕЛЁТАХ (для справки, НЕ выдавай как точные цены):
{flights_context if flights_context else "Данные временно недоступны"}

ПРАВИЛА:
- НЕ упоминай Gemini, ChatGPT или другие AI
- НЕ пиши "партнёрская/реферальная ссылка"
- НЕ называй себя "консьерж"
- Города — ПОЛНЫМИ НАЗВАНИЯМИ (Сочи, не AER)
- Рекомендуй РЕАЛЬНЫЕ отели и места (которые точно существуют)
- Если не уверен — лучше не упоминай
- Отвечай на {lang} языке

Запрос пользователя: {request.query}"""

    try:
        response = await client.aio.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt,
            config=types.GenerateContentConfig(
                thinking_config=types.ThinkingConfig(thinking_budget=0),
            ),
        )
        return {"result": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
