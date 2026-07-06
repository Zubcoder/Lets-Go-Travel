import os

from dotenv import load_dotenv

load_dotenv()


class Config:
    TELEGRAM_BOT_TOKEN: str = os.getenv("TELEGRAM_BOT_TOKEN", "")
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    TRAVELPAYOUTS_TOKEN: str = os.getenv("TRAVELPAYOUTS_TOKEN", "")
    TRAVELPAYOUTS_MARKER: str = os.getenv("TRAVELPAYOUTS_MARKER", "")
    RUSTORE_URL: str = os.getenv(
        "RUSTORE_URL",
        "https://apps.rustore.ru/app/com.zubcoder.letiumno",
    )
    WEBSITE_URL: str = os.getenv(
        "WEBSITE_URL",
        "https://xn--e1afkclhg3b5e.xn--p1ai/",
    )
    AVIASALES_BASE: str = "https://www.aviasales.ru"
    OSTROVOK_BASE: str = "https://ostrovok.ru"
    TRIPSTER_BASE: str = "https://experience.tripster.ru"
    CHEREHAPA_BASE: str = "https://cherehapa.ru"
    KIWITAXI_BASE: str = "https://kiwitaxi.com"
    LEVEL_TRAVEL_BASE: str = "https://level.travel"
    TUTU_BASE: str = "https://www.tutu.ru"
    SRAVNI_BASE: str = "https://www.sravni.ru/strahovka-dlya-vyezda-za-granicu"


config = Config()
