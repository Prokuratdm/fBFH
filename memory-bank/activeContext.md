# Active Context: fBFH

## Текущий фокус
Итерация 2 (начало): страница клубов с созданием, логотипами и пагинацией.

## Последние изменения (10 событий)

 1. **2026-06-06**: Реализован клубный функционал: ClubsPage, ClubService, модели (ClubResponse, PageResponse), i18n, маршрут /clubs
 2. **2026-06-06**: Исправлен баг бесконечного спиннера (кнопка «назад») — PopScope на HomePage + usePathUrlStrategy
 2. **2026-06-06**: Исправлен баг 404: Password Manager переписан на нативный Flutter (AutofillGroup + finishAutofillContext), удалена HTML-форма
 3. **2026-06-06**: Исправлен race condition в SplashPage при F5 — добавлен `addPostFrameCallback`
 3. **2026-06-06**: Исправлен баг с LoginResponse/UserInfo — login_page теперь вызывает me() после логина
 4. **2026-06-06**: Реализован SplashPage с проверкой токена через GET /me
 5. **2026-06-06**: Замена dart:html на package:web
 6. **2026-06-06**: Collapsible боковое меню (AnimatedContainer 200/72px)
 7. **2026-06-03**: Data-driven рефакторинг меню — каждый пункт один раз со списком ролей
 8. **2026-06-03**: Вынос переменных окружения в AppConfig (BASE_URL)
 9. **2026-06-03**: Базовая реализация: LoginPage, HomePage, AuthService, i18n
 9. **2026-06-02**: Инициализация проекта (flutter create)

## Следующие шаги
- Закончить Итерацию 2: экран пользователей
- Итерация 3: экраны команд
- Настройка go_router для навигации (когда появится больше страниц)
- Внедрение Riverpod для стейт-менеджмента

## Активные решения
- Пока без go_router — маршрутов мало, Navigator справляется
- Пока без Riverpod — набор страниц минимален, setState достаточно
- JWT хранится в куках (document.cookie), не в localStorage — для автоматической отправки с запросами