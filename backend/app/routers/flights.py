import httpx
from fastapi import APIRouter, Query

from ..config import settings

router = APIRouter()

TRAVELPAYOUTS_BASE = "https://api.travelpayouts.com/aviasales/v3"

# City name to IATA code mapping (Russian and English)
CITY_TO_IATA: dict[str, str] = {
    "москва": "MOW", "moscow": "MOW",
    "санкт-петербург": "LED", "петербург": "LED", "питер": "LED", "spb": "LED",
    "сочи": "AER", "адлер": "AER", "sochi": "AER",
    "казань": "KZN", "kazan": "KZN",
    "новосибирск": "OVB", "novosibirsk": "OVB",
    "екатеринбург": "SVX", "ekaterinburg": "SVX",
    "калининград": "KGD", "kaliningrad": "KGD",
    "минеральные воды": "MRV", "минводы": "MRV",
    "самара": "KUF", "samara": "KUF",
    "уфа": "UFA", "ufa": "UFA",
    "красноярск": "KJA", "krasnoyarsk": "KJA",
    "владивосток": "VVO", "vladivostok": "VVO",
    "иркутск": "IKT", "irkutsk": "IKT",
    "тюмень": "TJM", "tyumen": "TJM",
    "пермь": "PEE", "perm": "PEE",
    "махачкала": "MCX", "makhachkala": "MCX",
    "нижний новгород": "GOJ",
    "челябинск": "CEK",
    "омск": "OMS",
    "ростов-на-дону": "ROV", "ростов": "ROV",
    "волгоград": "VOG",
    "краснодар": "KRR",
    "анталья": "AYT", "анталия": "AYT", "antalya": "AYT",
    "стамбул": "IST", "istanbul": "IST",
    "дубай": "DXB", "dubai": "DXB",
    "тбилиси": "TBS", "tbilisi": "TBS",
    "ереван": "EVN", "yerevan": "EVN",
    "баку": "GYD", "baku": "GYD",
    "бангкок": "BKK", "bangkok": "BKK",
    "пхукет": "HKT", "phuket": "HKT",
    "бали": "DPS", "bali": "DPS",
    "париж": "PAR", "paris": "PAR",
    "рим": "ROM", "rome": "ROM",
    "барселона": "BCN", "barcelona": "BCN",
    "лондон": "LON", "london": "LON",
    "берлин": "BER", "berlin": "BER",
    "прага": "PRG", "prague": "PRG",
    "хургада": "HRG", "hurghada": "HRG",
    "шарм-эль-шейх": "SSH",
    "мальдивы": "MLE", "maldives": "MLE",
    "ташкент": "TAS", "tashkent": "TAS",
}


def _resolve_iata(city_or_iata: str) -> str:
    """Convert city name to IATA code if possible, otherwise return as-is."""
    clean = city_or_iata.strip().lower()
    if clean in CITY_TO_IATA:
        return CITY_TO_IATA[clean]
    # Already an IATA code (3 uppercase letters)
    if len(city_or_iata.strip()) == 3 and city_or_iata.strip().isalpha():
        return city_or_iata.strip().upper()
    return city_or_iata.strip()


@router.get("/search")
async def search_flights(
    origin: str = Query(..., description="Origin city name or IATA code"),
    destination: str = Query(..., description="Destination city name or IATA code"),
    depart_date: str = Query(..., description="Departure date YYYY-MM-DD"),
    return_date: str | None = Query(None, description="Return date YYYY-MM-DD"),
    passengers: int = Query(1, ge=1, le=9),
):
    origin_iata = _resolve_iata(origin)
    dest_iata = _resolve_iata(destination)

    params = {
        "origin": origin_iata,
        "destination": dest_iata,
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
                "origin": t.get("origin", origin_iata),
                "destination": t.get("destination", dest_iata),
                "origin_city": origin,
                "destination_city": destination,
                "airline": t.get("airline", ""),
                "price": t.get("price", 0),
                "currency": "RUB",
                "departure_at": t.get("departure_at", ""),
                "return_at": t.get("return_at"),
                "transfers": t.get("transfers", 0),
                "flight_number": t.get("flight_number", ""),
                "link": f"https://www.aviasales.ru/search/{origin_iata}{depart_date.replace('-', '')}{dest_iata}1",
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
