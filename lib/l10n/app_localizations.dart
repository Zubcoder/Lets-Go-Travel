import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'ЛетиУмно'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In ru, this message translates to:
  /// **'AI-помощник для путешествий'**
  String get appTagline;

  /// No description provided for @search.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// No description provided for @flights.
  ///
  /// In ru, this message translates to:
  /// **'Авиабилеты'**
  String get flights;

  /// No description provided for @hotels.
  ///
  /// In ru, this message translates to:
  /// **'Отели'**
  String get hotels;

  /// No description provided for @aiPlanner.
  ///
  /// In ru, this message translates to:
  /// **'ЛетиУмно'**
  String get aiPlanner;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @searchFlights.
  ///
  /// In ru, this message translates to:
  /// **'Поиск авиабилетов'**
  String get searchFlights;

  /// No description provided for @searchHotels.
  ///
  /// In ru, this message translates to:
  /// **'Поиск отелей'**
  String get searchHotels;

  /// No description provided for @from.
  ///
  /// In ru, this message translates to:
  /// **'Откуда'**
  String get from;

  /// No description provided for @to.
  ///
  /// In ru, this message translates to:
  /// **'Куда'**
  String get to;

  /// No description provided for @departureDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата вылета'**
  String get departureDate;

  /// No description provided for @returnDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата возврата'**
  String get returnDate;

  /// No description provided for @passengers.
  ///
  /// In ru, this message translates to:
  /// **'Пассажиры'**
  String get passengers;

  /// No description provided for @oneWay.
  ///
  /// In ru, this message translates to:
  /// **'В одну сторону'**
  String get oneWay;

  /// No description provided for @roundTrip.
  ///
  /// In ru, this message translates to:
  /// **'Туда и обратно'**
  String get roundTrip;

  /// No description provided for @searchButton.
  ///
  /// In ru, this message translates to:
  /// **'Найти'**
  String get searchButton;

  /// No description provided for @cheapestFlights.
  ///
  /// In ru, this message translates to:
  /// **'Самые дешёвые билеты'**
  String get cheapestFlights;

  /// No description provided for @popularDirections.
  ///
  /// In ru, this message translates to:
  /// **'Популярные направления'**
  String get popularDirections;

  /// No description provided for @checkIn.
  ///
  /// In ru, this message translates to:
  /// **'Заезд'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In ru, this message translates to:
  /// **'Выезд'**
  String get checkOut;

  /// No description provided for @guests.
  ///
  /// In ru, this message translates to:
  /// **'Гости'**
  String get guests;

  /// No description provided for @rooms.
  ///
  /// In ru, this message translates to:
  /// **'Номера'**
  String get rooms;

  /// No description provided for @searchHotelsButton.
  ///
  /// In ru, this message translates to:
  /// **'Найти отели'**
  String get searchHotelsButton;

  /// No description provided for @bestDeals.
  ///
  /// In ru, this message translates to:
  /// **'Лучшие предложения'**
  String get bestDeals;

  /// No description provided for @aiPlannerTitle.
  ///
  /// In ru, this message translates to:
  /// **'ЛетиУмно'**
  String get aiPlannerTitle;

  /// No description provided for @aiPlannerHint.
  ///
  /// In ru, this message translates to:
  /// **'Опишите ваше идеальное путешествие...'**
  String get aiPlannerHint;

  /// No description provided for @aiPlannerExample.
  ///
  /// In ru, this message translates to:
  /// **'Например: Хочу на море в августе, бюджет 50 000₽ на двоих, из Москвы'**
  String get aiPlannerExample;

  /// No description provided for @planTrip.
  ///
  /// In ru, this message translates to:
  /// **'Спланировать'**
  String get planTrip;

  /// No description provided for @generating.
  ///
  /// In ru, this message translates to:
  /// **'Генерация маршрута...'**
  String get generating;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In ru, this message translates to:
  /// **'Тема оформления'**
  String get theme;

  /// No description provided for @darkTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get lightTheme;

  /// No description provided for @systemTheme.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get systemTheme;

  /// No description provided for @support.
  ///
  /// In ru, this message translates to:
  /// **'Поддержка'**
  String get support;

  /// No description provided for @aboutApp.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get aboutApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In ru, this message translates to:
  /// **'Пользовательское соглашение'**
  String get termsOfService;

  /// No description provided for @version.
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get version;

  /// No description provided for @howToUse.
  ///
  /// In ru, this message translates to:
  /// **'Как пользоваться'**
  String get howToUse;

  /// No description provided for @rateApp.
  ///
  /// In ru, this message translates to:
  /// **'Оценить в RuStore'**
  String get rateApp;

  /// No description provided for @ourApps.
  ///
  /// In ru, this message translates to:
  /// **'Наши приложения'**
  String get ourApps;

  /// No description provided for @onboardingTitle1.
  ///
  /// In ru, this message translates to:
  /// **'Дешёвые авиабилеты'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In ru, this message translates to:
  /// **'Находим лучшие цены на авиабилеты по всем авиакомпаниям в один клик'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In ru, this message translates to:
  /// **'Лучшие отели'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In ru, this message translates to:
  /// **'Сравниваем цены на отели, хостелы и апартаменты по всему миру'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In ru, this message translates to:
  /// **'ЛетиУмно'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In ru, this message translates to:
  /// **'Искусственный интеллект построит идеальный маршрут под ваш бюджет и предпочтения'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In ru, this message translates to:
  /// **'Экономьте на путешествиях!'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления о снижении цен, лайфхаки и подборки от AI-помощника'**
  String get onboardingDesc4;

  /// No description provided for @next.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get getStarted;

  /// No description provided for @noResults.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get noResults;

  /// No description provided for @error.
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No description provided for @noInternet.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения к интернету'**
  String get noInternet;

  /// No description provided for @perPerson.
  ///
  /// In ru, this message translates to:
  /// **'за чел.'**
  String get perPerson;

  /// No description provided for @perNight.
  ///
  /// In ru, this message translates to:
  /// **'за ночь'**
  String get perNight;

  /// No description provided for @direct.
  ///
  /// In ru, this message translates to:
  /// **'Прямой'**
  String get direct;

  /// No description provided for @withStops.
  ///
  /// In ru, this message translates to:
  /// **'{count} пересадка'**
  String withStops(int count);

  /// No description provided for @hours.
  ///
  /// In ru, this message translates to:
  /// **'{count} ч'**
  String hours(int count);

  /// No description provided for @minutes.
  ///
  /// In ru, this message translates to:
  /// **'{count} мин'**
  String minutes(int count);

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Дата обновления: 2 июля 2026 г.'**
  String get privacyLastUpdated;

  /// No description provided for @privacySection1Title.
  ///
  /// In ru, this message translates to:
  /// **'1. Общие положения'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In ru, this message translates to:
  /// **'Настоящая Политика конфиденциальности разработана в соответствии с Федеральным законом от 27.07.2006 №152-ФЗ «О персональных данных».\n\nОператор персональных данных: ИП Зубков С.В. (далее — Разработчик).\nПриложение: «ЛетиУмно» (далее — Приложение).'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In ru, this message translates to:
  /// **'2. Какие данные мы собираем'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Body.
  ///
  /// In ru, this message translates to:
  /// **'Приложение может собирать следующие данные:\n• Поисковые запросы — маршруты, даты, количество пассажиров. Используются только для поиска.\n• Настройки приложения (язык, тема оформления) — хранятся ТОЛЬКО на вашем устройстве.\n\nПриложение НЕ собирает: ФИО, адрес, телефон, email, геолокацию, данные банковских карт, рекламные идентификаторы.'**
  String get privacySection2Body;

  /// No description provided for @privacySection3Title.
  ///
  /// In ru, this message translates to:
  /// **'3. Цели обработки данных'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Body.
  ///
  /// In ru, this message translates to:
  /// **'• Поиск авиабилетов и отелей по запросу пользователя\n• Предоставление AI-рекомендаций по планированию путешествий\n• Улучшения качества работы приложения'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In ru, this message translates to:
  /// **'4. Хранение и защита данных'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Body.
  ///
  /// In ru, this message translates to:
  /// **'• Все данные хранятся исключительно на устройстве пользователя.\n• Поисковые запросы передаются по зашифрованному каналу (HTTPS/TLS).\n• Разработчик не имеет доступа к локальным данным пользователя.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In ru, this message translates to:
  /// **'5. Передача данных третьим лицам'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In ru, this message translates to:
  /// **'Поисковые запросы передаются партнёрским сервисам (Travelpayouts) для поиска билетов и отелей.\n• Данные не сохраняются на сторонних серверах после обработки.\n• Разработчик не передаёт, не продаёт и не предоставляет данные пользователей третьим лицам.'**
  String get privacySection5Body;

  /// No description provided for @privacySection6Title.
  ///
  /// In ru, this message translates to:
  /// **'6. Права пользователя (ст. 14 №152-ФЗ)'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body.
  ///
  /// In ru, this message translates to:
  /// **'В соответствии с Федеральным законом №152-ФЗ «О персональных данных» вы имеете право:\n• Получить информацию об обработке ваших данных\n• Потребовать удаления ваших данных\n• Отозвать согласие на обработку данных\n\nДля удаления всех данных достаточно удалить приложение.'**
  String get privacySection6Body;

  /// No description provided for @privacySection7Title.
  ///
  /// In ru, this message translates to:
  /// **'7. Файлы cookie и аналитика'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Body.
  ///
  /// In ru, this message translates to:
  /// **'Приложение не использует файлы cookie и рекламные трекеры. Приложение не требует регистрации.'**
  String get privacySection7Body;

  /// No description provided for @privacySection8Title.
  ///
  /// In ru, this message translates to:
  /// **'8. Возрастные ограничения'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Body.
  ///
  /// In ru, this message translates to:
  /// **'Приложение предназначено для лиц старше 12+ лет.'**
  String get privacySection8Body;

  /// No description provided for @privacySection9Title.
  ///
  /// In ru, this message translates to:
  /// **'9. Изменения политики'**
  String get privacySection9Title;

  /// No description provided for @privacySection9Body.
  ///
  /// In ru, this message translates to:
  /// **'Разработчик оставляет за собой право обновлять настоящую Политику. Актуальная версия всегда доступна в приложении.'**
  String get privacySection9Body;

  /// No description provided for @privacySection10Title.
  ///
  /// In ru, this message translates to:
  /// **'10. Контакты'**
  String get privacySection10Title;

  /// No description provided for @privacySection10Body.
  ///
  /// In ru, this message translates to:
  /// **'По вопросам обработки персональных данных: zubcoder.app@yandex.ru'**
  String get privacySection10Body;

  /// No description provided for @termsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пользовательское соглашение'**
  String get termsTitle;

  /// No description provided for @termsLastUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Дата обновления: 2 июля 2026 г.'**
  String get termsLastUpdated;

  /// No description provided for @termsSection1Title.
  ///
  /// In ru, this message translates to:
  /// **'1. Общие положения'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Body.
  ///
  /// In ru, this message translates to:
  /// **'Настоящее Пользовательское соглашение регулирует использование мобильного приложения «ЛетиУмно», разработанного ИП Зубков С.В.\n\nИспользуя Приложение, вы подтверждаете согласие с условиями настоящего Соглашения.'**
  String get termsSection1Body;

  /// No description provided for @termsSection2Title.
  ///
  /// In ru, this message translates to:
  /// **'2. Описание сервиса'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Body.
  ///
  /// In ru, this message translates to:
  /// **'Приложение предоставляет:\n• Поиск и сравнение цен на авиабилеты\n• Поиск и сравнение цен на отели\n• AI-рекомендации по планированию путешествий'**
  String get termsSection2Body;

  /// No description provided for @termsSection3Title.
  ///
  /// In ru, this message translates to:
  /// **'3. Туристический дисклеймер'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Body.
  ///
  /// In ru, this message translates to:
  /// **'ВАЖНО: Приложение предоставляет исключительно справочную информацию. Приложение НЕ является туристическим агентством и НЕ осуществляет продажу билетов или бронирование отелей напрямую. Бронирование осуществляется на сторонних сайтах-партнёрах.'**
  String get termsSection3Body;

  /// No description provided for @termsSection4Title.
  ///
  /// In ru, this message translates to:
  /// **'4. Ограничение ответственности'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Body.
  ///
  /// In ru, this message translates to:
  /// **'• Результаты поиска носят информационный характер.\n• Разработчик НЕ несёт ответственности за цены, наличие и условия бронирования на сайтах-партнёрах.\n• Разработчик НЕ гарантирует 100% точность цен и наличия.'**
  String get termsSection4Body;

  /// No description provided for @termsSection5Title.
  ///
  /// In ru, this message translates to:
  /// **'5. Подписки и платежи'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Body.
  ///
  /// In ru, this message translates to:
  /// **'Базовый функционал приложения — бесплатный. Дополнительные функции могут быть доступны по подписке через RuStore.'**
  String get termsSection5Body;

  /// No description provided for @termsSection6Title.
  ///
  /// In ru, this message translates to:
  /// **'6. Интеллектуальная собственность'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Body.
  ///
  /// In ru, this message translates to:
  /// **'Все права на Приложение принадлежат Разработчику. Запрещается копирование, декомпиляция и распространение Приложения.'**
  String get termsSection6Body;

  /// No description provided for @termsSection7Title.
  ///
  /// In ru, this message translates to:
  /// **'7. Права и обязанности пользователя'**
  String get termsSection7Title;

  /// No description provided for @termsSection7Body.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь обязуется использовать Приложение в соответствии с законодательством Российской Федерации.'**
  String get termsSection7Body;

  /// No description provided for @termsSection8Title.
  ///
  /// In ru, this message translates to:
  /// **'8. Возрастные ограничения'**
  String get termsSection8Title;

  /// No description provided for @termsSection8Body.
  ///
  /// In ru, this message translates to:
  /// **'Приложение предназначено для лиц старше 12+ лет.'**
  String get termsSection8Body;

  /// No description provided for @termsSection9Title.
  ///
  /// In ru, this message translates to:
  /// **'9. Применимое право и разрешение споров'**
  String get termsSection9Title;

  /// No description provided for @termsSection9Body.
  ///
  /// In ru, this message translates to:
  /// **'Настоящее Соглашение регулируется законодательством Российской Федерации. Споры разрешаются путём переговоров.'**
  String get termsSection9Body;

  /// No description provided for @termsSection10Title.
  ///
  /// In ru, this message translates to:
  /// **'10. Контакты'**
  String get termsSection10Title;

  /// No description provided for @termsSection10Body.
  ///
  /// In ru, this message translates to:
  /// **'По вопросам: zubcoder.app@yandex.ru'**
  String get termsSection10Body;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
