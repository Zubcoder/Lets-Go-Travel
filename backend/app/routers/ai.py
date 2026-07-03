import google.generativeai as genai
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from ..config import settings

router = APIRouter()


class PlanRequest(BaseModel):
    query: str
    locale: str = "ru"


@router.post("/plan")
async def plan_trip(request: PlanRequest):
    if not settings.gemini_api_key:
        raise HTTPException(status_code=503, detail="AI service not configured")

    genai.configure(api_key=settings.gemini_api_key)
    model = genai.GenerativeModel("gemini-2.5-flash")

    lang = "русском" if request.locale == "ru" else "английском"

    prompt = f"""Ты — опытный AI-помощник для путешествий. Составь подробный план путешествия на {lang} языке.

Запрос пользователя: {request.query}

Составь план, включающий:
1. Рекомендуемые направления (если не указано конкретное)
2. Оптимальные даты поездки
3. Примерный бюджет (авиабилеты, проживание, питание, развлечения)
4. Рекомендации по перелётам (когда лучше покупать, какие авиакомпании)
5. Варианты проживания (отели, хостелы, апартаменты)
6. Достопримечательности и активности
7. Практические советы (визы, валюта, транспорт, связь)
8. Лайфхаки для экономии

Формат: используй Markdown с заголовками, списками и эмодзи для наглядности.
Будь конкретным — указывай примерные цены в рублях, названия сервисов, конкретные рекомендации."""

    try:
        response = await model.generate_content_async(prompt)
        return {"result": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
