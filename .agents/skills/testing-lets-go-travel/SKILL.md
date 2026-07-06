---
name: testing-lets-go-travel
description: Test the Let's Go Travel website, legal docs, and Flutter app. Use when verifying UI changes, legal compliance, or responsive layout.
---

# Testing ЛетиУмно

## Architecture (as of July 2026)

The project is **website-primary**:
- **Website**: Static HTML/CSS/JS landing page + blog at `site/index.html`, served via GitHub Pages on летиумно.рф
- **Backend API**: FastAPI on Fly.io (`letiumno-api.fly.dev`) — AI trip planner via Gemini 2.5 Flash
- **Telegram Bot**: Lightweight gateway to website (minimal functionality)
- **Mobile App**: Deprecated (removed from active development)

## Test Environment Setup

1. Start local server: `cd /home/ubuntu/repos/Lets-Go-Travel/site && python3 -m http.server 8080 &`
2. Verify backend health: `curl -s https://letiumno-api.fly.dev/health` (expect `{"status":"ok"}`)
3. Open `http://localhost:8080` in Chrome (NOT `file://` — relative paths for blog/docs break with file protocol)

## What to Test

### 1. Landing Page Layout (`http://localhost:8080`)
- Nav bar: logo image + "ЛетиУмно" text, links: "Сервисы", "Направления", "Блог", "Telegram", orange "Спланировать" CTA
- Hero section title: "Путешествуйте умнее" (NOT old "ЛетиУмно AI" or "Скачать приложение")
- Stats bar: "500+", "2M+", "AI", "0₽"
- NO references to "RuStore" or "Скачать приложение" anywhere: `curl -s http://localhost:8080/ | grep -ic "rustore\|скачать приложение"` should return 0
- Footer: "© 2026 ЛетиУмно — ИП Зубков С.В." (NOT С.С.)

### 2. AI Chat Widget
- Chat container with header: logo + "ЛетиУмно" + "Ваш умный помощник"
- Welcome message: "Куда хотите поехать?"
- 5 suggestion chips visible
- Click a chip → user message appears as orange bubble → loading animation (3 dots) → AI response in ~5-30 seconds
- AI response must contain:
  - Travel content (city names, activities, links)
  - Partner links with `marker=${TRAVELPAYOUTS_MARKER}`
  - Honest pricing ("от X руб", "проверьте актуальные цены"), NOT invented specific prices
- The AI endpoint is `POST https://letiumno-api.fly.dev/api/v1/ai/plan` with body `{"query": "..."}`

### 3. Services Grid ("Всё для путешествий")
- 6 service cards with correct partner names and URLs:
  - Авиабилеты (Aviasales) → `aviasales.ru/?marker=${TRAVELPAYOUTS_MARKER}`
  - Отели (Hotellook) → `search.hotellook.com/?marker=${TRAVELPAYOUTS_MARKER}`
  - Пакетные туры (Level.Travel) → `level.travel/?marker=${TRAVELPAYOUTS_MARKER}`
  - Экскурсии (Tripster) → `experience.tripster.ru/?marker=${TRAVELPAYOUTS_MARKER}`
  - Страховка (Cherehapa) → `cherehapa.ru/?marker=${TRAVELPAYOUTS_MARKER}`
  - Трансферы (Kiwitaxi) → `kiwitaxi.com/?marker=${TRAVELPAYOUTS_MARKER}`
- Verify links in DOM: `curl -s http://localhost:8080/ | grep -o 'href="https://[^"]*marker=${TRAVELPAYOUTS_MARKER}[^"]*"'`

### 4. Destinations Section ("Популярные направления")
- 6 destinations: Сочи, Стамбул, Анталья, Грузия, Калининград, Дубай
- Each shows "Проверить цены →" (NOT hard-coded prices)
- Links contain correct IATA codes: AER (Сочи), IST (Стамбул), AYT (Анталья), TBS (Грузия), KGD (Калининград), DXB (Дубай)
- All links have `origin_iata=MOW&destination_iata=XXX&marker=${TRAVELPAYOUTS_MARKER}`

### 5. Blog Section & Article Navigation
- 3 blog cards: "Турция 2026", "7 способов купить авиабилеты дешевле", "Грузия: вино, горы и гостеприимство"
- Click article → loads at `/blog/[filename].html`
- Article contains partner links with `marker=${TRAVELPAYOUTS_MARKER}`
- "← ЛетиУмно" back link navigates to main page
- Footer shows "ИП Зубков С.В."

### 6. Mobile Responsive (380-400px)
- Open DevTools (F12) → responsive mode auto-activates
- Or use Ctrl+Shift+M to toggle device toolbar
- Set width to ~380-400px
- Nav collapses to logo + "Спланировать" CTA only
- Hero title readable, no overflow
- Service cards and blog cards stack to single column
- CTA buttons stack vertically

### Legal Documents (`docs/`)
- `docs/privacy-policy.html` — 10 sections, mentions 152-ФЗ, contact email
- `docs/terms-of-service.html` — 10 sections, Russian Federation law
- Must NOT mention "Gemini", "Google", or "ChatGPT"
- Legal entity: ИП Зубков С.В. (NOT С.С.)

## Key Verification Commands

```bash
# Check no RuStore/app references
curl -s http://localhost:8080/ | grep -ic "rustore\|скачать приложение"

# Verify all partner links have marker
curl -s http://localhost:8080/ | grep -o 'href="https://[^"]*marker=${TRAVELPAYOUTS_MARKER}[^"]*"'

# Verify destination IATA codes
curl -s http://localhost:8080/ | grep -o 'destination_iata=[A-Z]*'

# Test backend AI endpoint
curl -s -X POST https://letiumno-api.fly.dev/api/v1/ai/plan \
  -H "Content-Type: application/json" \
  -d '{"query":"Куда дешевле всего из Москвы?"}' | head -c 200

# Backend health
curl -s https://letiumno-api.fly.dev/health
```

## Devin Secrets Needed
- `LETS_GO_TRAVEL_GEMINI_API_KEY` — for AI trip planner backend endpoint (configured in Fly.io)
- `TRAVELPAYOUTS_TOKEN` — for flight/hotel search backend endpoints (configured in Fly.io)

## Tips
- **Always use http.server**, not `file://` — blog article relative paths and docs links break with file protocol
- AI responses take 5-30 seconds — be patient, don't assume timeout
- The website is static HTML with inline CSS/JS — no build step needed
- Color scheme: primary #FF8C42 (orange), accent #00CEC9 (teal), background #0A0E21 (deep blue)
- Travelpayouts marker is `${TRAVELPAYOUTS_MARKER}` — verify this in ALL partner links
- DevTools responsive mode may auto-activate when F12 is pressed — check the dimensions bar
- The `marker` parameter in partner URLs is what tracks affiliate commissions — critical to verify
- Blog articles are at `site/blog/*.html` (turkey-2026.html, cheap-flights-tips.html, georgia-guide.html)
