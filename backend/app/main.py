from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .routers import ai, flights, health, hotels

app = FastAPI(
    title="Let's Go Travel API",
    description="Backend proxy for Let's Go Travel app",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(flights.router, prefix="/api/v1/flights", tags=["flights"])
app.include_router(hotels.router, prefix="/api/v1/hotels", tags=["hotels"])
app.include_router(ai.router, prefix="/api/v1/ai", tags=["ai"])
