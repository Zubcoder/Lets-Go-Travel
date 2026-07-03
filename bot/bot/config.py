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
    HOTELLOOK_BASE: str = "https://www.hotellook.ru"
    TRIPSTER_BASE: str = "https://experience.tripster.ru"
    DISCOVERCARS_BASE: str = "https://www.discovercars.com"
    CHEREHAPA_BASE: str = "https://cherehapa.ru"
    YESIM_BASE: str = "https://www.yesim.app"
    KIWITAXI_BASE: str = "https://kiwitaxi.com"


config = Config()
