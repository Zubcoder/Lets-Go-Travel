// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Let\'s Go Travel';

  @override
  String get appTagline => 'AI-помощник для путешествий';

  @override
  String get search => 'Поиск';

  @override
  String get flights => 'Авиабилеты';

  @override
  String get hotels => 'Отели';

  @override
  String get aiPlanner => 'AI Планировщик';

  @override
  String get settings => 'Настройки';

  @override
  String get searchFlights => 'Поиск авиабилетов';

  @override
  String get searchHotels => 'Поиск отелей';

  @override
  String get from => 'Откуда';

  @override
  String get to => 'Куда';

  @override
  String get departureDate => 'Дата вылета';

  @override
  String get returnDate => 'Дата возврата';

  @override
  String get passengers => 'Пассажиры';

  @override
  String get oneWay => 'В одну сторону';

  @override
  String get roundTrip => 'Туда и обратно';

  @override
  String get searchButton => 'Найти';

  @override
  String get cheapestFlights => 'Самые дешёвые билеты';

  @override
  String get popularDirections => 'Популярные направления';

  @override
  String get checkIn => 'Заезд';

  @override
  String get checkOut => 'Выезд';

  @override
  String get guests => 'Гости';

  @override
  String get rooms => 'Номера';

  @override
  String get searchHotelsButton => 'Найти отели';

  @override
  String get bestDeals => 'Лучшие предложения';

  @override
  String get aiPlannerTitle => 'AI Планировщик маршрута';

  @override
  String get aiPlannerHint => 'Опишите ваше идеальное путешествие...';

  @override
  String get aiPlannerExample =>
      'Например: Хочу на море в августе, бюджет 50 000₽ на двоих, из Москвы';

  @override
  String get planTrip => 'Спланировать';

  @override
  String get generating => 'Генерация маршрута...';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема оформления';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get systemTheme => 'Системная';

  @override
  String get support => 'Поддержка';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Пользовательское соглашение';

  @override
  String get version => 'Версия';

  @override
  String get howToUse => 'Как пользоваться';

  @override
  String get rateApp => 'Оценить в RuStore';

  @override
  String get ourApps => 'Наши приложения';

  @override
  String get onboardingTitle1 => 'Дешёвые авиабилеты';

  @override
  String get onboardingDesc1 =>
      'Находим лучшие цены на авиабилеты по всем авиакомпаниям в один клик';

  @override
  String get onboardingTitle2 => 'Лучшие отели';

  @override
  String get onboardingDesc2 =>
      'Сравниваем цены на отели, хостелы и апартаменты по всему миру';

  @override
  String get onboardingTitle3 => 'AI Планировщик';

  @override
  String get onboardingDesc3 =>
      'Искусственный интеллект построит идеальный маршрут под ваш бюджет и предпочтения';

  @override
  String get onboardingTitle4 => 'Экономьте на путешествиях!';

  @override
  String get onboardingDesc4 =>
      'Уведомления о снижении цен, лайфхаки и подборки от AI-помощника';

  @override
  String get next => 'Далее';

  @override
  String get skip => 'Пропустить';

  @override
  String get getStarted => 'Начать';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get error => 'Произошла ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get noInternet => 'Нет подключения к интернету';

  @override
  String get perPerson => 'за чел.';

  @override
  String get perNight => 'за ночь';

  @override
  String get direct => 'Прямой';

  @override
  String withStops(int count) {
    return '$count пересадка';
  }

  @override
  String hours(int count) {
    return '$count ч';
  }

  @override
  String minutes(int count) {
    return '$count мин';
  }

  @override
  String get privacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get privacyLastUpdated => 'Дата обновления: 2 июля 2026 г.';

  @override
  String get privacySection1Title => '1. Общие положения';

  @override
  String get privacySection1Body =>
      'Настоящая Политика конфиденциальности разработана в соответствии с Федеральным законом от 27.07.2006 №152-ФЗ «О персональных данных».\n\nОператор персональных данных: ИП Зубков С.С. (далее — Разработчик).\nПриложение: «Let\'s Go Travel» (далее — Приложение).';

  @override
  String get privacySection2Title => '2. Какие данные мы собираем';

  @override
  String get privacySection2Body =>
      'Приложение может собирать следующие данные:\n• Поисковые запросы — маршруты, даты, количество пассажиров. Используются только для поиска.\n• Настройки приложения (язык, тема оформления) — хранятся ТОЛЬКО на вашем устройстве.\n\nПриложение НЕ собирает: ФИО, адрес, телефон, email, геолокацию, данные банковских карт, рекламные идентификаторы.';

  @override
  String get privacySection3Title => '3. Цели обработки данных';

  @override
  String get privacySection3Body =>
      '• Поиск авиабилетов и отелей по запросу пользователя\n• Предоставление AI-рекомендаций по планированию путешествий\n• Улучшения качества работы приложения';

  @override
  String get privacySection4Title => '4. Хранение и защита данных';

  @override
  String get privacySection4Body =>
      '• Все данные хранятся исключительно на устройстве пользователя.\n• Поисковые запросы передаются по зашифрованному каналу (HTTPS/TLS).\n• Разработчик не имеет доступа к локальным данным пользователя.';

  @override
  String get privacySection5Title => '5. Передача данных третьим лицам';

  @override
  String get privacySection5Body =>
      'Поисковые запросы передаются партнёрским сервисам (Travelpayouts) для поиска билетов и отелей.\n• Данные не сохраняются на сторонних серверах после обработки.\n• Разработчик не передаёт, не продаёт и не предоставляет данные пользователей третьим лицам.';

  @override
  String get privacySection6Title => '6. Права пользователя (ст. 14 №152-ФЗ)';

  @override
  String get privacySection6Body =>
      'В соответствии с Федеральным законом №152-ФЗ «О персональных данных» вы имеете право:\n• Получить информацию об обработке ваших данных\n• Потребовать удаления ваших данных\n• Отозвать согласие на обработку данных\n\nДля удаления всех данных достаточно удалить приложение.';

  @override
  String get privacySection7Title => '7. Файлы cookie и аналитика';

  @override
  String get privacySection7Body =>
      'Приложение не использует файлы cookie и рекламные трекеры. Приложение не требует регистрации.';

  @override
  String get privacySection8Title => '8. Возрастные ограничения';

  @override
  String get privacySection8Body =>
      'Приложение предназначено для лиц старше 12+ лет.';

  @override
  String get privacySection9Title => '9. Изменения политики';

  @override
  String get privacySection9Body =>
      'Разработчик оставляет за собой право обновлять настоящую Политику. Актуальная версия всегда доступна в приложении.';

  @override
  String get privacySection10Title => '10. Контакты';

  @override
  String get privacySection10Body =>
      'По вопросам обработки персональных данных: zubcoder.app@yandex.ru';

  @override
  String get termsTitle => 'Пользовательское соглашение';

  @override
  String get termsLastUpdated => 'Дата обновления: 2 июля 2026 г.';

  @override
  String get termsSection1Title => '1. Общие положения';

  @override
  String get termsSection1Body =>
      'Настоящее Пользовательское соглашение регулирует использование мобильного приложения «Let\'s Go Travel», разработанного ИП Зубков С.С.\n\nИспользуя Приложение, вы подтверждаете согласие с условиями настоящего Соглашения.';

  @override
  String get termsSection2Title => '2. Описание сервиса';

  @override
  String get termsSection2Body =>
      'Приложение предоставляет:\n• Поиск и сравнение цен на авиабилеты\n• Поиск и сравнение цен на отели\n• AI-рекомендации по планированию путешествий';

  @override
  String get termsSection3Title => '3. Туристический дисклеймер';

  @override
  String get termsSection3Body =>
      'ВАЖНО: Приложение предоставляет исключительно справочную информацию. Приложение НЕ является туристическим агентством и НЕ осуществляет продажу билетов или бронирование отелей напрямую. Бронирование осуществляется на сторонних сайтах-партнёрах.';

  @override
  String get termsSection4Title => '4. Ограничение ответственности';

  @override
  String get termsSection4Body =>
      '• Результаты поиска носят информационный характер.\n• Разработчик НЕ несёт ответственности за цены, наличие и условия бронирования на сайтах-партнёрах.\n• Разработчик НЕ гарантирует 100% точность цен и наличия.';

  @override
  String get termsSection5Title => '5. Подписки и платежи';

  @override
  String get termsSection5Body =>
      'Базовый функционал приложения — бесплатный. Дополнительные функции могут быть доступны по подписке через RuStore.';

  @override
  String get termsSection6Title => '6. Интеллектуальная собственность';

  @override
  String get termsSection6Body =>
      'Все права на Приложение принадлежат Разработчику. Запрещается копирование, декомпиляция и распространение Приложения.';

  @override
  String get termsSection7Title => '7. Права и обязанности пользователя';

  @override
  String get termsSection7Body =>
      'Пользователь обязуется использовать Приложение в соответствии с законодательством Российской Федерации.';

  @override
  String get termsSection8Title => '8. Возрастные ограничения';

  @override
  String get termsSection8Body =>
      'Приложение предназначено для лиц старше 12+ лет.';

  @override
  String get termsSection9Title => '9. Применимое право и разрешение споров';

  @override
  String get termsSection9Body =>
      'Настоящее Соглашение регулируется законодательством Российской Федерации. Споры разрешаются путём переговоров.';

  @override
  String get termsSection10Title => '10. Контакты';

  @override
  String get termsSection10Body => 'По вопросам: zubcoder.app@yandex.ru';
}
