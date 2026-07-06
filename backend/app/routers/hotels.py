from urllib.parse import quote

from fastapi import APIRouter, Query

from ..config import settings

router = APIRouter()

# City name to English name for Hotellook URLs
CITY_EN: dict[str, str] = {
    "москва": "Moscow", "сочи": "Sochi", "санкт-петербург": "Saint-Petersburg",
    "казань": "Kazan", "калининград": "Kaliningrad", "анталья": "Antalya",
    "анталия": "Antalya", "стамбул": "Istanbul", "дубай": "Dubai",
    "тбилиси": "Tbilisi", "париж": "Paris", "рим": "Rome",
    "барселона": "Barcelona", "прага": "Prague", "бали": "Bali",
    "пхукет": "Phuket", "хургада": "Hurghada", "мальдивы": "Maldives",
    "ереван": "Yerevan", "баку": "Baku", "бангкок": "Bangkok",
    "минеральные воды": "Mineralnye-Vody", "минводы": "Mineralnye-Vody",
    "екатеринбург": "Yekaterinburg", "новосибирск": "Novosibirsk",
    "красноярск": "Krasnoyarsk", "владивосток": "Vladivostok",
}


def _city_en(city: str) -> str:
    """Get English city name for URL."""
    return CITY_EN.get(city.strip().lower(), city.strip())


@router.get("/search")
async def search_hotels(
    location: str = Query(..., description="City name or location"),
    check_in: str = Query(..., description="Check-in date YYYY-MM-DD"),
    check_out: str = Query(..., description="Check-out date YYYY-MM-DD"),
    guests: int = Query(1, ge=1, le=10),
):
    marker = settings.travelpayouts_marker
    city_en = _city_en(location)
    city_slug = city_en.lower().replace(" ", "-")

    # Build the search URL that will redirect user to Hotellook
    search_url = (
        f"https://search.hotellook.com/hotels"
        f"?destination={quote(city_en)}"
        f"&checkIn={check_in}&checkOut={check_out}"
        f"&adults={guests}&marker={marker}"
    )

    # Return a single result that points to the search URL
    # The app will open this in the browser for real-time prices
    return {
        "results": [],
        "count": 0,
        "search_url": search_url,
        "message": f"Перейдите по ссылке для поиска отелей в городе {location}",
    }
