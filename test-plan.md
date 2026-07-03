# Test Plan: ЛетиУмно — Initial Project

## Scope
Test the browser-visible deliverables: website landing page and legal documents.
Flutter app verified via `flutter analyze` (0 issues). Backend Python syntax verified via `ast.parse`.

## Test 1: Website Landing Page — Desktop Layout & Content
**File:** `site/index.html` opened in Chrome

### Assertions:
1. **Hero title** displays "ЛетиУмно" in gradient text (not plain white)
2. **Hero tagline** contains "AI-помощник" text
3. **Stats bar** shows 4 items: "500+", "2M+", "AI", "RU/EN"
4. **Feature cards** — exactly 4 cards visible: "Дешёвые авиабилеты", "Лучшие отели", "AI Планировщик маршрута", "Экономия на путешествиях"
5. **How-it-works** — 4 numbered steps visible (1-4)
6. **Partners section** contains "Travelpayouts", "Aviasales", "Hotellook"
7. **Download button** links to `https://apps.rustore.ru/app/com.zubcoder.lets_go_travel`
8. **Footer** contains links to privacy policy and terms of service

## Test 2: Website Landing Page — Mobile Responsive
**Action:** Resize browser to ~375px width (mobile viewport)

### Assertions:
1. **Hero title** font size reduces (not overflowing horizontally)
2. **Stats bar** stacks vertically (not side-by-side)
3. **Feature cards** stack to single column
4. **Page is scrollable** without horizontal overflow

## Test 3: Legal Documents — Privacy Policy
**File:** `docs/privacy-policy.html`

### Assertions:
1. **Title** reads "Политика конфиденциальности"
2. **App name** "ЛетиУмно" mentioned in section 1
3. **152-ФЗ** referenced in section 6 (user rights)
4. **Contact email** `zubcoder.app@yandex.ru` in section 10
5. **NO mention** of "Gemini", "Google", or "ChatGPT" anywhere on the page
6. **10 sections** present (h2 headers numbered 1-10)

## Test 4: Legal Documents — Terms of Service
**File:** `docs/terms-of-service.html`

### Assertions:
1. **Title** reads "Пользовательское соглашение"
2. **Travel disclaimer** (section 3) contains warning that app is NOT a travel agency
3. **"облачные технологии"** used instead of specific AI provider names
4. **Contact email** `zubcoder.app@yandex.ru` in section 10
5. **NO mention** of "Gemini", "Google", or "ChatGPT"
6. **10 sections** present (h2 headers numbered 1-10)

## Test 5: Navigation Between Pages
**Action:** From landing page footer, click "Политика конфиденциальности" link

### Assertions:
1. Link navigates to privacy policy page successfully (not 404)
2. Back navigation returns to landing page

## Non-Browser Verification (already done)
- `flutter analyze` — 0 issues
- Python backend — all 6 files pass `ast.parse` syntax check
