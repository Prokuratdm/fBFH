# Active Context: fBFH

## Текущий фокус
Итерация 4 завершена: страница инвентаря. Создание (с дропбоксом клубов) + пагинированный список (size=100). Архитектура: HomePage как shell с IndexedStack, всегда видимым меню.

## Последние изменения (10 событий)

  1. **2026-06-09**: Реализован InventoryPage: создание инвентаря (POST /api/v1/inventory), пагинированный список (GET, size=100), дропбокс клубов в диалоге создания
  2. **2026-06-09**: InventoryService с InventoryException, InventoryResponse+InventoryRequest модели, AppConfig.inventoryPath
  3. **2026-06-09**: HomePage интегрирует InventoryPage через GlobalKey<InventoryPageState>, refresh() при onDestinationSelected
  4. **2026-06-09**: 9 новых ключей локализации (ru+en): inventoryTitle, inventoryCreateButton, inventoryNameLabel, inventoryClubLabel, inventoryCreateDialogTitle, inventoryCreate, inventoryCreated, inventoryEmpty, inventoryNoClub
  5. **2026-06-09**: 8 новых unit-тестов (всего 54): inventory_response, inventory_service, StubLocalizations обновлён
  6. **2026-06-09**: Реализован LocationsPage: создание локации (POST /api/v1/clubs/{clubId}/locations), список имён (GET, без пагинации), заглушка если clubId=null
  7. **2026-06-09**: LocationService с LocationException, LocationResponse+LocationRequest модели, AppConfig.clubLocationsPath(clubId)
  8. **2026-06-09**: HomePage интегрирует LocationsPage через GlobalKey<LocationsPageState>, refresh() при onDestinationSelected
  9. **2026-06-09**: 8 новых ключей локализации (ru+en): locationsTitle, locationsCreateButton, locationNameLabel, locationCreateDialogTitle, locationCreate, locationCreated, locationsEmpty, locationsNoClub
 10. **2026-06-09**: 7 новых unit-тестов (location_response, location_service)

## Следующие шаги
- Итерация 5: Команды (CRUD + привязка к клубу)
- Итерация 6: Дети
- Итерация 7: Тренировки
- Настройка go_router для навигации (когда появится больше страниц)
- Внедрение Riverpod для стейт-менеджмента

## Активные решения
- HomePage как shell с IndexedStack — меню всегда видно, навигация без Navigator.push
- Без go_router — Navigator справляется, есть только 4 маршрута (/splash, /login, /home, default)
- Без Riverpod — setState достаточно для текущего размера
- JWT хранится в куках (document.cookie), не в localStorage — для автоматической отправки с запросами
- DI через опциональный параметр `authService` в виджетах — позволяет тестам подменять
- Логотипы передаются в Image.network с headers (Authorization) — требуется для авторизованных GET
- MultipartFile.fromBytes с явным contentType (MediaType) — иначе бэкенд отвергает как octet-stream
- usePathUrlStrategy() — без DevTools-ошибок dartDevEmbedder при F5
- clubId для локаций берётся из UserInfo.clubId (ответ /api/v1/auth/me) — не нужен отдельный запрос
- Локации — простой List без пагинации (бэкенд не возвращает Spring Page)
- Инвентарь — пагинированный список (size=100, как договорились). В диалоге создания дропбокс клубов (подгружаем через ClubService), preselect = user.clubId
