import httpx
from fastapi import APIRouter, Query

from ..config import settings

router = APIRouter()

HOTELLOOK_BASE = "https://engine.hotellook.com/api/v2"


@router.get("/search")
async def search_hotels(
    location: str = Query(..., description="City name or location"),
    check_in: str = Query(..., description="Check-in date YYYY-MM-DD"),
    check_out: str = Query(..., description="Check-out date YYYY-MM-DD"),
    guests: int = Query(1, ge=1, le=10),
):
    # First, look up the location ID
    async with httpx.AsyncClient(timeout=30) as client:
        lookup_resp = await client.get(
            f"{HOTELLOOK_BASE}/lookup.json",
            params={
                "query": location,
                "lang": "ru",
                "lookFor": "city",
                "limit": 1,
                "token": settings.travelpayouts_token,
            },
        )
        lookup_resp.raise_for_status()
        lookup_data = lookup_resp.json()

    cities = lookup_data.get("results", {}).get("locations", [])
    if not cities:
        return {"results": [], "count": 0}

    city_id = cities[0].get("id")
    city_name = cities[0].get("name", location)

    # Search hotels in the city
    async with httpx.AsyncClient(timeout=30) as client:
        resp = await client.get(
            f"{HOTELLOOK_BASE}/cache.json",
            params={
                "location": city_id,
                "checkIn": check_in,
                "checkOut": check_out,
                "adults": guests,
                "currency": "rub",
                "limit": 20,
                "token": settings.travelpayouts_token,
            },
        )
        resp.raise_for_status()
        data = resp.json()

    results = []
    for h in data if isinstance(data, list) else []:
        hotel_id = h.get("hotelId", "")
        results.append(
            {
                "name": h.get("hotelName", ""),
                "location": city_name,
                "price_from": h.get("priceFrom", 0),
                "currency": "RUB",
                "rating": h.get("rating", 0),
                "stars": h.get("stars", 0),
                "photo_url": f"https://photo.hotellook.com/image_v2/crop/h{hotel_id}_1/320/240.auto"
                if hotel_id
                else "",
                "link": f"https://search.hotellook.com/hotels?destination={city_id}&checkIn={check_in}&checkOut={check_out}&adults={guests}",
            }
        )

    return {"results": results, "count": len(results)}
