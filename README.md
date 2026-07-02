# Let's Go Travel

AI-помощник для путешествий. Дешёвые авиабилеты, лучшие отели, AI-планировщик маршрутов.

## Возможности

- **Поиск авиабилетов** — сравнение цен по 500+ авиакомпаниям через Travelpayouts API
- **Поиск отелей** — 2M+ вариантов размещения через Hotellook API
- **AI Планировщик** — персональный маршрут с бюджетом и рекомендациями (Gemini AI)
- **Двуязычный** — полная поддержка RU/EN
- **Тёмная/светлая тема**

## Архитектура

```
├── lib/                    # Flutter мобильное приложение
│   ├── screens/            # Экраны (Flights, Hotels, AI Planner, Settings)
│   ├── providers/          # State management (Provider)
│   ├── services/           # API сервисы
│   ├── models/             # Модели данных
│   ├── widgets/            # Компоненты UI
│   ├── utils/              # Утилиты, тема, константы
│   └── l10n/               # Локализация (RU/EN)
├── backend/                # FastAPI backend proxy
│   ├── app/routers/        # API endpoints (flights, hotels, ai)
│   └── Dockerfile          # Контейнеризация
├── site/                   # Сайт-лендинг
└── docs/                   # Юридические документы
```

## Технологии

| Компонент | Технология |
|---|---|
| Мобильное приложение | Flutter 3.x, Dart, Provider |
| Backend | FastAPI, Python 3.12 |
| AI | Gemini 2.5 Flash |
| Поиск билетов/отелей | Travelpayouts API |
| Платформа | Android (RuStore) |

## Запуск

### Flutter
```bash
flutter pub get
flutter run
```

### Backend
```bash
cd backend
pip install -e .
GEMINI_API_KEY=your_key TRAVELPAYOUTS_TOKEN=your_token uvicorn app.main:app --reload
```

## Часть экосистемы [Zubcoder Apps](https://zubcoder.github.io)

Почта поддержки: zubcoder.app@yandex.ru
