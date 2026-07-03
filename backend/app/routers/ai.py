import httpx
import google.generativeai as genai
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

    genai.configure(api_key=settings.gemini_api_key)
    model = genai.GenerativeModel(
        "gemini-2.5-flash",
        generation_config={"thinking_config": {"thinking_budget": 0}},
    )

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

    prompt = f"""Ты — AI-помощник "ЛетиУмно". Помогаешь спланировать идеальное путешествие.

СТИЛЬ ОТВЕТА:
- Пиши КРАСОЧНО и ВДОХНОВЛЯЮЩЕ — как лучший travel-блогер
- Создавай атмосферу: описывай ощущения, виды, запахи, эмоции
- Используй яркие эмодзи, но уместно (не перебарщивай)
- Формат: Markdown с заголовками ## и списками
- Язык: {lang}

СТРУКТУРА ОТВЕТА:
1. Красочное вступление (2-3 предложения, создай предвкушение поездки)
2. Перелёт — конкретная рекомендация с ценой и ссылкой
3. Проживание — конкретный вариант с описанием и ссылкой
4. Что делать — 2-3 экскурсии/активности со ссылками
5. Трансфер + Страховка — кратко, по 1 предложению
6. Итого — подсчёт бюджета и сколько сэкономили

ПАРТНЁРСКИЕ ССЫЛКИ (вставляй ОРГАНИЧНО, ОБЯЗАТЕЛЬНО указывай маршрут в URL):
- Авиабилеты: [текст](https://www.aviasales.ru/search/[ОТКУДА][КУДА]1?marker={marker})
  Пример: [Москва - Сочи](https://www.aviasales.ru/search/MOWAER1?marker={marker})
- Отели: [текст](https://www.hotellook.ru/hotels/[ГОРОД]?marker={marker})
- Экскурсии: [текст](https://experience.tripster.ru/?marker={marker}) или [текст](https://www.sputnik8.com/?marker={marker})
- Аренда авто: [текст](https://www.discovercars.com/?marker={marker})
- Страховка: [текст](https://cherehapa.ru/?marker={marker})
- eSIM: [текст](https://www.yesim.app)
- Трансфер: [текст](https://kiwitaxi.com/?marker={marker})

ЗАКРЫТЫЕ АЭРОПОРТЫ (с 2022, НЕЛЬЗЯ рекомендовать перелёт туда!):
Анапа (AAQ), Краснодар (KRR), Ростов-на-Дону (ROV), Волгоград (VOG),
Симферополь (SIP), Геленджик (GDZ), Элиста (ESL), Белгород (EGO),
Брянск (BZK), Курск (URS), Липецк (LPK), Воронеж (VOZ).
Если пользователь хочет в эти города — предлагай ПОЕЗД или АВТОБУС, не самолёт.
Для Крыма — предлагай поезд через мост или автобус.
Для Сочи/Адлера (AER) — МОЖНО летать, аэропорт работает.

РЕАЛЬНЫЕ ДАННЫЕ О ПЕРЕЛЁТАХ (используй в ответе):
{flights_context if flights_context else "Данные временно недоступны — используй примерные цены"}

ПРАВИЛА:
- Каждая рекомендация — с конкретной ценой в рублях
- Ссылки встраивай как "[Забронировать перелёт](url)" или "[Посмотреть отели](url)"
- НЕ упоминай Gemini, ChatGPT или другие AI
- НЕ пиши "партнёрская ссылка" — просто рекомендуй
- НЕ называй себя "консьерж" — ты просто помощник
- Города — ПОЛНЫМИ НАЗВАНИЯМИ (Сочи, не AER)
- Будь конкретным: названия отелей, маршруты экскурсий, время в пути
- Если бюджет указан — уложись в него и покажи экономию
- В ссылках на Aviasales ВСЕГДА указывай маршрут: /search/[ОТКУДА][КУДА]1

Запрос пользователя: {request.query}"""

    try:
        response = await model.generate_content_async(prompt)
        return {"result": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
