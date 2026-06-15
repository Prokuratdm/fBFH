# Active Context: fBFH

## Текущий фокус
Итерация 12 завершена: страница упражнений. Полный CRUD: создание с картинкой (multipart вторым запросом), пагинированный список с фильтром по типу (ICE/LAND), split-view детали (слева список, справа детали), редактирование + обновление картинки.

## Последние изменения (10 событий)

  1. **2026-06-09**: Реализован ExercisesPage: полный CRUD упражнений, split-view (список + детали), создание/редактирование с дропдаунами типов/клубов/инвентаря, картинки через multipart, фильтр по типу
  2. **2026-06-09**: ExerciseService с ExerciseException, ExerciseResponse+ExerciseRequest модели, AppConfig.exercisesPath/exerciseTypesPath/exercisePicturePath
  3. **2026-06-09**: HomePage интегрирует ExercisesPage через GlobalKey<ExercisesPageState>, refresh() при onDestinationSelected
  4. **2026-06-09**: 24 новых ключа локализации (ru+en): exercisesTitle, exercisesCreateButton, exercisesEmpty, exerciseNameLabel, exerciseDescriptionLabel, exerciseTypeLabel, exerciseTypeAll, exerciseTypeIce, exerciseTypeLand, exerciseUrlLabel, exerciseContentLabel, exerciseInventoryLabel, exerciseCreateDialogTitle, exerciseEditDialogTitle, exerciseCreate, exerciseSave, exerciseCreated, exerciseUpdated, exerciseEditButton, exerciseUploadPicture, exerciseReplacePicture, exercisePictureEmpty, exercisePictureUploaded, exerciseDetailSelect
  5. **2026-06-09**: 11 новых unit-тестов (всего 69): exercise_response (8), exercise_service (3). StubLocalizations обновлён.
  6. **2026-06-09**: Реализован InventoryPage: создание инвентаря (POST /api/v1/inventory), пагинированный список (GET, size=100), дропбокс клубов в диалоге создания
  7. **2026-06-09**: InventoryService с InventoryException, InventoryResponse+InventoryRequest модели, AppConfig.inventoryPath
  8. **2026-06-09**: HomePage интегрирует InventoryPage через GlobalKey<InventoryPageState>, refresh() при onDestinationSelected
  9. **2026-06-09**: Реализован LocationsPage: создание локации (POST /api/v1/clubs/{clubId}/locations), список имён (GET, без пагинации), заглушка если clubId=null
 10. **2026-06-09**: LocationService с LocationException, LocationResponse+LocationRequest модели, AppConfig.clubLocationsPath(clubId)

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
- Логотипы и картинки упражнений передаются в Image.network с headers (Authorization)
- MultipartFile.fromBytes с явным contentType (MediaType) — иначе бэкенд отвергает как octet-stream
- usePathUrlStrategy() — без DevTools-ошибок dartDevEmbedder при F5
- clubId для локаций/упражнений берётся из UserInfo.clubId (ответ /api/v1/auth/me)
- Справочники (типы упражнений, клубы, инвентарь) подгружаются каждый раз заново при открытии диалога
- ExercisesPage: split-view — слева пагинированный список с фильтром, справа детали + кнопка редактирования
- Картинка упражнения загружается вторым запросом (multipart) после создания упражнения