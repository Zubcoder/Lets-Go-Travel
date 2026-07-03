---
name: testing-lets-go-travel
description: Test the ЛетиУмно website, legal docs, and Flutter app. Use when verifying UI changes, legal compliance, or responsive layout.
---

# Testing ЛетиУмно

## What to Test

### Website Landing Page (`site/index.html`)
- Open `file:///path/to/repo/site/index.html` in Chrome
- Verify hero section: "ЛетиУмно" title, "AI-помощник" tagline, animated airplane logo
- Verify stats bar: 500+, 2M+, AI, RU/EN
- Verify 4 feature cards: Авиабилеты, Отели, AI Планировщик, Экономия
- Verify how-it-works: 4 numbered steps
- Verify partners: Travelpayouts, Aviasales, Hotellook, Flutter, FastAPI, AI/ML
- Verify footer: RuStore download button, Zubcoder Apps badge, email, privacy/terms links
- Test mobile responsive at ~400px width via DevTools device toolbar (Ctrl+Shift+M with DevTools open)

### Legal Documents (`docs/`)
- `docs/privacy-policy.html` — must have exactly 10 sections (h2 headers 1-10)
  - Section 1: mentions 152-ФЗ
  - Section 6: references ст. 14 №152-ФЗ
  - Section 10: contact email zubcoder.app@yandex.ru
  - Must NOT mention "Gemini", "Google", or "ChatGPT" anywhere
- `docs/terms-of-service.html` — must have exactly 10 sections
  - Section 2: uses "облачные технологии" (not specific AI provider names)
  - Section 3: travel disclaimer (NOT a travel agency)
  - Section 9: Russian Federation law
  - Must NOT mention "Gemini", "Google", or "ChatGPT"

### Flutter App
- Run `flutter analyze` — should report 0 issues
- No Android emulator is available on the VM, so UI testing requires a physical device or CI
- Verify localization files: `lib/l10n/app_ru.arb` and `lib/l10n/app_en.arb` should have 135+ keys each

### Backend
- Run `python3 -c "import ast; ast.parse(open('backend/app/main.py').read())"` to verify syntax
- Backend requires `GEMINI_API_KEY` and `TRAVELPAYOUTS_TOKEN` environment variables to run
- Health endpoint: `GET /health` returns `{"status": "ok"}`

## Navigation Between Pages
- Footer links use relative paths: `../docs/privacy-policy.html` and `../docs/terms-of-service.html`
- These work when opening `site/index.html` directly but may break if served from a different root

## Devin Secrets Needed
- `LETS_GO_TRAVEL_GEMINI_API_KEY` — for AI trip planner backend endpoint
- `TRAVELPAYOUTS_TOKEN` — for flight/hotel search backend endpoints

## Key Commands
- `flutter analyze` — lint the Flutter app
- `flutter test` — run Flutter unit tests
- `cd backend && uvicorn app.main:app --reload` — start backend dev server
- `dart format lib/` — format Dart code

## Tips
- The website is a single static HTML file with inline CSS/JS — no build step needed
- Legal docs are also static HTML — just open in browser
- Color scheme: primary #FF8C42 (orange), accent #00CEC9 (teal), background #0A0E21 (deep blue)
- The Flutter app uses Provider for state management and SharedPreferences for persistence
