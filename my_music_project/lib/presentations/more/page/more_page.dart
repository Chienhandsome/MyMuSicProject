import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/app_scaffold.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final currentLanguage = localeProvider.locale.languageCode == 'en'
        ? 'English'
        : 'Tiếng Việt';

    return AppScaffold(
      title: l10n.settings,
      scrollableAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(l10n.language),
            _buildLanguageOption(l10n, currentLanguage, localeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    AppLocalizations l10n,
    String currentLanguage,
    LocaleProvider localeProvider
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.language,
            color: Colors.deepPurpleAccent,
            size: 24,
          ),
        ),
        title: Text(
          l10n.languageOption,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            value: currentLanguage,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.deepPurpleAccent,
            ),
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF2A2A3E),
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items: [
              DropdownMenuItem(
                value: 'English',
                child: Text(l10n.english),
              ),
              DropdownMenuItem(
                value: 'Tiếng Việt',
                child: Text(l10n.vietnamese),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                final newLocale = newValue == 'English'
                    ? const Locale('en')
                    : const Locale('vi');
                localeProvider.setLocale(newLocale);
              }
            },
          ),
        ),
      ),
    );
  }
}

