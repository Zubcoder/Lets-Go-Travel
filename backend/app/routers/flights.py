import httpx
from fastapi import APIRouter, Query

from ..config import settings

router = APIRouter()

TRAVELPAYOUTS_BASE = "https://api.travelpayouts.com/aviasales/v3"


@router.get("/search")
async def search_flights(
    origin: str = Query(..., description="Origin IATA code, e.g. MOW"),
    destination: str = Query(..., description="Destination IATA code, e.g. AER"),
    depart_date: str = Query(..., description="Departure date YYYY-MM-DD"),
    return_date: str | None = Query(None, description="Return date YYYY-MM-DD"),
    passengers: int = Query(1, ge=1, le=9),
):
    params = {
        "origin": origin,
        "destination": destination,
        "departure_at": depart_date,
        "token": settings.travelpayouts_token,
        "sorting": "price",
        "limit": 20,
        "currency": "rub",
    }
    if return_date:
        params["return_at"] = return_date

    async with httpx.AsyncClient(timeout=30) as client:
        resp = await client.get(f"{TRAVELPAYOUTS_BASE}/prices_for_dates", params=params)
        resp.raise_for_status()
        data = resp.json()

    tickets = data.get("data", [])
    results = []
    for t in tickets:
        results.append(
            {
                "origin": t.get("origin", origin),
                "destination": t.get("destination", destination),
                "origin_city": origin,
                "destination_city": destination,
                "airline": t.get("airline", ""),
                "price": t.get("price", 0),
                "currency": "RUB",
                "departure_at": t.get("departure_at", ""),
                "return_at": t.get("return_at"),
                "transfers": t.get("transfers", 0),
                "flight_number": t.get("flight_number", ""),
                "link": f"https://www.aviasales.ru/search/{origin}{depart_date.replace('-', '')}{destination}1",
            }
        )

    return {"results": results, "count": len(results)}


@router.get("/popular")
async def popular_flights():
    params = {
        "origin": "MOW",
        "token": settings.travelpayouts_token,
        "currency": "rub",
        "limit": 10,
        "sorting": "price",
    }

    async with httpx.AsyncClient(timeout=15) as client:
        resp = await client.get(
            f"{TRAVELPAYOUTS_BASE}/prices_for_dates", params=params
        )
        resp.raise_for_status()
        data = resp.json()

    tickets = data.get("data", [])
    results = []
    for t in tickets:
        results.append(
            {
                "origin": t.get("origin", "MOW"),
                "destination": t.get("destination", ""),
                "origin_city": "Москва",
                "destination_city": t.get("destination", ""),
                "airline": t.get("airline", ""),
                "price": t.get("price", 0),
                "currency": "RUB",
                "departure_at": t.get("departure_at", ""),
                "return_at": t.get("return_at"),
                "transfers": t.get("transfers", 0),
                "flight_number": t.get("flight_number", ""),
                "link": f"https://www.aviasales.ru/search/MOW1",
            }
        )

    return {"results": results, "count": len(results)}
