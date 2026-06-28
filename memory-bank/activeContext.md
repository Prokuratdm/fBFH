# Active Context: fBFH

## Текущий фокус
Итерация 12 завершена: страница упражнений с полным CRUD, новыми enum-полями (trainingPart, focuses, preparationType) и русским переводом всех enum-значений. Исправлен баг с Future.wait на web.

## Последние изменения (10 событий)

  1. **2026-06-15**: Добавлен ExerciseLabels — хелпер перевода enum-значений (15 методов label) с русскими названиями и fallback на английский
  2. **2026-06-15**: 15 новых ключей локализации: exerciseTrainingPart_BEGINNING/MIDDLE/END, exerciseFocus_*, exercisePreparationType_*
  3. **2026-06-15**: 3 новых enum-поля в ExerciseResponse/ExerciseRequest: trainingPart (String?), focuses (List<String>), preparationType (String?)
  4. **2026-06-15**: Исправлен баг Future.wait (List<dynamic> → List<Map<String, String>>) на web — заменён на последовательные await
  5. **2026-06-09**: Реализован ExercisesPage: полный CRUD упражнений, split-view, создание/редактирование с дропдаунами, картинки через multipart, фильтр по типу
  6. **2026-06-09**: ExerciseService с ExerciseException, ExerciseResponse+ExerciseRequest модели
  7. **2026-06-09**: HomePage интегрирует ExercisesPage через GlobalKey<ExercisesPageState>, refresh() при onDestinationSelected
  8. **2026-06-09**: 24 новых ключа локализации (ru+en) для базового CRUD упражнений
  9. **2026-06-09**: 11 новых unit-тестов (всего 69): exercise_response (8), exercise_service (3)
 10. **2026-06-09**: Реализован InventoryPage: создание инвентаря, пагинированный список, дропбокс клубов

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
- JWT хранится в куках (document.cookie), не в localStorage
- DI через опциональный параметр `authService` в виджетах
- Логотипы и картинки упражнений передаются в Image.network с headers (Authorization)
- MultipartFile.fromBytes с явным contentType (MediaType)
- usePathUrlStrategy() — без DevTools-ошибок при F5
- clubId для локаций/упражнений берётся из UserInfo.clubId
- Справочники подгружаются каждый раз заново при открытии диалога (последовательные await, не Future.wait)
- ExercisesPage: split-view — слева список с фильтром, справа детали + кнопка редактирования
- Картинка упражнения загружается вторым запросом (multipart) после создания
- ExerciseLabels.label() — единый хелпер перевода enum-значений (15 значений), fallback на английский
- Все enum-значения отображаются на русском: тип (Лёд/Земля), trainingPart (Начало/Середина/Конец), focuses (Сила/...), preparationType (Техническая/...)