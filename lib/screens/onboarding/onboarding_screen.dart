import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/locale_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.localeController,
    required this.onComplete,
  });

  final LocaleController localeController;
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    widget.onComplete();
  }

  Future<void> _allowLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
      }
    } catch (_) {
      // The user can still grant this later from within Prayer Times/Qibla.
    }
    if (mounted) _finish();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _step == 0
                ? _LanguageStep(
                    key: const ValueKey('language'),
                    localeController: widget.localeController,
                    onNext: () => setState(() => _step = 1),
                  )
                : _PermissionStep(
                    key: const ValueKey('permission'),
                    l10n: l10n,
                    scheme: scheme,
                    onAllow: _allowLocation,
                    onSkip: _finish,
                  ),
          ),
        ),
      ),
    );
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({super.key, required this.localeController, required this.onNext});

  final LocaleController localeController;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          l10n.onboardingChooseLanguageTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingChooseLanguageSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ListenableBuilder(
          listenable: localeController,
          builder: (context, _) => Column(
            children: [
              _LanguageOption(
                label: l10n.settingsLanguageArabic,
                selected: localeController.locale.languageCode == 'ar',
                onTap: () => localeController.setLocale(const Locale('ar')),
              ),
              const SizedBox(height: 12),
              _LanguageOption(
                label: l10n.settingsLanguageEnglish,
                selected: localeController.locale.languageCode == 'en',
                onTap: () => localeController.setLocale(const Locale('en')),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onNext, child: Text(l10n.onboardingNext)),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? scheme.primary : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            if (selected) Icon(Icons.check_circle, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}

class _PermissionStep extends StatelessWidget {
  const _PermissionStep({
    super.key,
    required this.l10n,
    required this.scheme,
    required this.onAllow,
    required this.onSkip,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final VoidCallback onAllow;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Icon(Icons.location_on, size: 72, color: scheme.primary),
        const SizedBox(height: 20),
        Text(
          l10n.onboardingPermissionTitle,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.onboardingPermissionBody,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onAllow, child: Text(l10n.onboardingAllowLocation)),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onSkip, child: Text(l10n.onboardingSkip)),
      ],
    );
  }
}
