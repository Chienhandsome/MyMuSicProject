import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_music_project/core/constants/privacy_policy.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/app_scaffold.dart';

// const _privacyPolicyUrl = 'https://chienhandsome.github.io/MyMuSicProject/';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final currentLanguage = locale.languageCode == 'en' ? 'English' : 'Vietnamese';

    return AppScaffold(
      title: l10n.settings,
      scrollableAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageOption(context, l10n, currentLanguage, ref),
            _buildPrivacyPolicy(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    AppLocalizations l10n,
    String currentLanguage,
    WidgetRef ref,
  ) {
    return Container(
      decoration: _cardDecoration(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: _buildLeadingIcon(Icons.language),
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
          decoration: _accentDecoration(),
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
                value: 'Vietnamese',
                child: Text(l10n.vietnamese),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue == null) {
                return;
              }

              final newLocale =
                  newValue == 'English' ? const Locale('en') : const Locale('vi');
              ref.read(localeProvider.notifier).setLocale(newLocale);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: _cardDecoration(),
      child: ListTile(
        onTap: () => _openPrivacyPolicy(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: _buildLeadingIcon(Icons.policy_outlined),
        title: Text(
          l10n.privacyPolicy,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: _accentDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.view,
                style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.open_in_new,
                color: Colors.deepPurpleAccent,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.deepPurpleAccent,
        size: 24,
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color(0xFF1E1E2E),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }

  BoxDecoration _accentDecoration() {
    return BoxDecoration(
      color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final uri = Uri.parse(PrivacyPolicy.privacyPolicyUrl);

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        _showOpenPolicyError(context);
      }
    } on PlatformException {
      if (context.mounted) {
        _showOpenPolicyError(context);
      }
    }
  }

  void _showOpenPolicyError(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.privacyPolicyOpenError),
      ),
    );
  }
}
