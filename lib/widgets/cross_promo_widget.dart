import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CrossPromoWidget extends StatelessWidget {
  const CrossPromoWidget({super.key});

  static const _currentPackageId = 'com.zubcoder.letiumno';

  static const _apps = <_AppInfo>[
    _AppInfo(
      nameRu: 'АгроСкан',
      nameEn: 'AgroScan',
      descRu: 'AI-агроном в кармане',
      descEn: 'AI agronomist in your pocket',
      packageId: 'com.zubcoder.agroscan',
      color: Color(0xFF4CAF50),
      iconAsset: 'assets/cross_promo/agroscan.png',
    ),
    _AppInfo(
      nameRu: 'Умный МеханикAI',
      nameEn: 'Smart MechanicAI',
      descRu: 'AI-диагностика авто',
      descEn: 'AI car diagnostics',
      packageId: 'com.smartmechanic.smart_mechanic',
      color: Color(0xFFFF5722),
      iconAsset: 'assets/cross_promo/mechanic.png',
    ),
    _AppInfo(
      nameRu: 'Stain Fix',
      nameEn: 'Stain Fix',
      descRu: 'Удаление пятен по фото',
      descEn: 'Photo-based stain removal',
      packageId: 'com.zubcoder.ai_stain_fix',
      color: Color(0xFF9C27B0),
      iconAsset: 'assets/cross_promo/stain_fix.png',
    ),
    _AppInfo(
      nameRu: 'ЕдаСкан',
      nameEn: 'FoodScan',
      descRu: 'Состав продуктов по фото',
      descEn: 'Food composition by photo',
      packageId: 'com.zubcoder.foodscan',
      color: Color(0xFFFF9800),
      iconAsset: 'assets/cross_promo/foodscan.png',
    ),
    _AppInfo(
      nameRu: 'AI Фармацевт',
      nameEn: 'AI Pharmacist',
      descRu: 'Проверка лекарств',
      descEn: 'Medication checker',
      packageId: 'com.zubcoder.aipharmacist',
      color: Color(0xFF00BCD4),
      iconAsset: 'assets/cross_promo/pharmacist.png',
    ),
    _AppInfo(
      nameRu: 'AI Ландшафт',
      nameEn: 'AI Landscape',
      descRu: 'Дизайн участка по фото',
      descEn: 'Landscape design by photo',
      packageId: 'com.zubcoder.ai_landscape',
      color: Color(0xFF8BC34A),
      iconAsset: 'assets/cross_promo/landscape.png',
    ),
    _AppInfo(
      nameRu: 'Город во Времени',
      nameEn: 'City in Time',
      descRu: 'Путешествие в прошлое',
      descEn: 'Journey to the past',
      packageId: 'com.zubkov.city_in_time',
      color: Color(0xFF795548),
      iconAsset: 'assets/cross_promo/cityintime.png',
    ),
    _AppInfo(
      nameRu: 'AI Кулинар',
      nameEn: 'AI Kulinar',
      descRu: 'Рецепты по фото',
      descEn: 'Recipes by photo',
      packageId: 'com.zubcoder.ai_kulinar',
      color: Color(0xFFE91E63),
      iconAsset: 'assets/cross_promo/kulinar.png',
    ),
    _AppInfo(
      nameRu: 'AI Ремонт',
      nameEn: 'AI Remont',
      descRu: 'Смета ремонта по фото',
      descEn: 'Repair estimate by photo',
      packageId: 'com.zubcoder.ai_remont',
      color: Color(0xFFFF6D00),
      iconAsset: 'assets/cross_promo/remont.png',
    ),
    _AppInfo(
      nameRu: 'AI Нумизмат',
      nameEn: 'AI Numizmat',
      descRu: 'Определи монету по фото',
      descEn: 'Identify coins by photo',
      packageId: 'com.zubcoder.ai_numizmat',
      color: Color(0xFFFFD700),
      iconAsset: 'assets/cross_promo/numizmat.png',
    ),
    _AppInfo(
      nameRu: 'AI Юрист',
      nameEn: 'AI Yurist',
      descRu: 'Юридический AI-помощник',
      descEn: 'Legal AI assistant',
      packageId: 'com.zubcoder.ai_yurist',
      color: Color(0xFF1A237E),
      iconAsset: 'assets/cross_promo/yurist.png',
    ),
    _AppInfo(
      nameRu: 'AI Лингвист',
      nameEn: 'AI Linguist',
      descRu: 'Переводчик и языковой помощник',
      descEn: 'Translator and language assistant',
      packageId: 'com.zubcoder.ai_lingvist',
      color: Color(0xFF3F51B5),
      iconAsset: 'assets/cross_promo/lingvist.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isRu = Localizations.localeOf(context).languageCode == 'ru';
    final apps =
        _apps.where((a) => a.packageId != _currentPackageId).toList();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            isRu ? 'Наши приложения' : 'Our Apps',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              for (int i = 0; i < apps.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 56),
                _CrossPromoTile(app: apps[i], isRu: isRu),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AppInfo {
  final String nameRu;
  final String nameEn;
  final String descRu;
  final String descEn;
  final String packageId;
  final Color color;
  final String iconAsset;

  const _AppInfo({
    required this.nameRu,
    required this.nameEn,
    required this.descRu,
    required this.descEn,
    required this.packageId,
    required this.color,
    required this.iconAsset,
  });
}

class _CrossPromoTile extends StatelessWidget {
  final _AppInfo app;
  final bool isRu;

  const _CrossPromoTile({required this.app, required this.isRu});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          app.iconAsset,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => CircleAvatar(
            backgroundColor: app.color,
            radius: 22,
            child: Text(
              app.nameRu.characters.first,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        isRu ? app.nameRu : app.nameEn,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        isRu ? app.descRu : app.descEn,
        style: TextStyle(
          fontSize: 12,
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
      trailing: FilledButton(
        onPressed: () => _openStore(),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          isRu ? 'Скачать' : 'Install',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _openStore() async {
    final uri = Uri.parse('https://apps.rustore.ru/app/${app.packageId}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
