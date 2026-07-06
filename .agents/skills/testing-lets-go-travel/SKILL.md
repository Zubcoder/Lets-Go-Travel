---
name: testing-lets-go-travel
description: Test the Let's Go Travel website, legal docs, and Flutter app. Use when verifying UI changes, legal compliance, or responsive layout.
---

# Testing ЛетиУмно (летиумно.рф)

## Production Site

The site is deployed on GitHub Pages via the `gh-pages` branch at https://xn--e1aghgfgyj.xn--p1ai/ (летиумно.рф).
After merging to main, changes must be deployed to `gh-pages` separately.

## What to Test

### Website Landing Page (index.html)
- Navigate to https://xn--e1aghgfgyj.xn--p1ai/
- Verify hero section: "ЛетиУмно" title, logo (tropical sunset), animated airplane, acrylic background
- Verify stats bar: 500+, 2M+, AI, 0₽
- Verify AI chat widget section with prompt suggestions
- Verify 10 service cards: Aviasales, Островок, Level.Travel, Tripster, Cherehapa, Kiwitaxi, Tutu.ru, Сравни.ру, OnlineTours, VisaToHome
  - All Travelpayouts links must contain `marker=${TRAVELPAYOUTS_MARKER}`
  - VisaToHome link goes to visatohome.ru (no marker)
  - Сравни.ру link goes to sravni.ru (no marker)
- Verify 6 destination cards: Сочи, Стамбул, Анталья, Грузия, Калининград, Дубай
  - Each "Найти билет" link should contain `origin_iata=MOW` and `marker=${TRAVELPAYOUTS_MARKER}`
- Verify blog section: currently 7 articles (3 original + 4 SEO)
- Verify partners bar: lists all 10 services + Gemini AI
- Verify footer: email, privacy policy, terms links, "ИП Зубков С.В."
- Test mobile responsive at ~400px width via DevTools device toolbar

### Blog Articles (blog/*.html)
- Each article should have:
  - Back link "← ЛетиУмно" pointing to `../index.html`
  - Tag badge (e.g. "Турция", "Подборка", "Гайд")
  - Title, date, reading time
  - Affiliate links with `marker=${TRAVELPAYOUTS_MARKER}`
  - CTA button linking to `../index.html#ai-chat`
  - Footer with copyright
- SEO meta-tags: `<meta name="description">`, `<meta name="keywords">`, `<link rel="canonical">`
- Current articles:
  - turkey-2026.html, cheap-flights-tips.html, georgia-guide.html (original 3)
  - august-2026.html, sochi-vs-turkey.html, travel-insurance-guide.html, visa-free-2026.html (new 4)

### SEO Files
- `sitemap.xml` — should list homepage + all blog articles with lastmod/changefreq/priority
- `robots.txt` — should have User-agent, Allow, Sitemap, Host directives

### Hotellook Migration Check
- Search all blog articles for "hotellook" or "Hotellook" — should find NONE
- Hotel links should point to `ostrovok.ru/?marker=${TRAVELPAYOUTS_MARKER}` with text mentioning "Островок"

### Legal Documents (docs/)
- `docs/privacy-policy.html` — 10 sections (h2 headers), mentions 152-ФЗ, contact zubcoder.app@yandex.ru
- `docs/terms-of-service.html` — 10 sections, Russian Federation law, travel disclaimer
- Must NOT mention "Gemini", "Google", or "ChatGPT" by name

### Telegram Bot
- Bot token is required to test (@LetiUmno_bot)
- Bot should act as "gateway" to website with Russian-only services
- /partners command should list: Aviasales, Ostrovok, Level.Travel, Tripster, Cherehapa, Kiwitaxi, Tutu.ru, Sravni.ru
- Bot config: see `bot/bot/config.py` for service URLs

## Navigation
- Footer links from index.html use `../docs/` relative paths
- Blog back links use `../index.html`
- These paths work on gh-pages where files are at root level

## Devin Secrets Needed
- `LETS_GO_TRAVEL_GEMINI_API_KEY` — for AI trip planner backend
- `TRAVELPAYOUTS_TOKEN` — for flight/hotel search backend
- `TELEGRAM_BOT_TOKEN` — for testing the Telegram bot

## Key Commands
- `cd backend && uvicorn app.main:app --reload` — start backend dev server
- Backend health: `GET /health` returns `{"status": "ok"}`

## Tips
- The website is static HTML on gh-pages — no build step needed
- To verify SEO meta-tags programmatically, use browser console: `document.querySelector('meta[name="description"]').content`
- Color scheme: --orange #FF8C42, --teal #00CEC9, --bg #0a0a1a (dark)
- All articles follow the same HTML template structure
- When testing mobile, use DevTools device toolbar at 400px width — cards should stack single-column
- GitHub Pages deployment may have transient failures — if deploy fails, try re-triggering or check the gh-pages branch directly
- The Flutter app was removed from the project; focus testing on website, blog, SEO, and bot
- sitemap.xml and robots.txt are served from root on gh-pages
