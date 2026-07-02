from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    gemini_api_key: str = ""
    travelpayouts_token: str = ""
    cors_origins: list[str] = ["*"]
    debug: bool = False

    model_config = {"env_file": ".env", "extra": "ignore"}


settings = Settings()
