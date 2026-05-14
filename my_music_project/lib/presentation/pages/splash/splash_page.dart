import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../splash/splash_background.dart';
import '../splash/splash_content.dart';
import '../../../../l10n/app_localizations.dart';
import '../home_page.dart';
import '../../providers/music_provider.dart';
import '../../providers/permission_provider.dart';


class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
  with TickerProviderStateMixin, WidgetsBindingObserver {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Pre-built HomePage để chuyển đổi mượt mà
  Widget? _preloadedHomePage;

  bool _waitingForSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _controller.forward();
  }

  Future<void> _initializeApp() async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final permissionNotifier = ref.read(permissionProvider.notifier);

    try {
      // Load trạng thái permission denied trước
      await permissionNotifier.loadDeniedStatus();

      if (!mounted) return;

      // Luôn kiểm tra quyền hiện tại trước
      await permissionNotifier.checkPermission();

      if (!mounted) return;

      if (ref.read(permissionProvider).hasPermission) {
        await _prepareHomePage();
        return;
      }

      // Luôn dùng system dialog để xin quyền
      await _requestPermission();
    } catch (e) {
      developer.log('Error in _initializeApp: $e');
      if (mounted) {
        await _requestPermission();
      }
    }
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _prepareHomePage() async {
    if (!mounted) return;

    // Tạo HomePage widget trước
    _preloadedHomePage = const HomePage();

    // Load songs thông qua musicProvider
    await ref.read(musicProvider.notifier).loadSongs();

    if (!mounted) return;

    // Đợi một chút để animation mượt mà
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _preloadedHomePage ?? const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future<void> _requestPermission() async {
    await ref.read(permissionProvider.notifier).requestPermission();

    if (!mounted) return;

    if (ref.read(permissionProvider).hasPermission) {
      await _prepareHomePage();
    } else {
      // Bị từ chối: hiện system AlertDialog hỏi mở Settings
      if (mounted) {
        await _showPermissionDeniedDialog();
      }
    }
  }

  Future<void> _showPermissionDeniedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.permissionRequired),
        content: Text(l10n.permissionDeniedMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _exitApp();
            },
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              _waitingForSettings = true;
              await _openAppSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _checkPermissionAfterSettings() async {
    final notifier = ref.read(permissionProvider.notifier);
    await notifier.checkPermission();

    if (!mounted) return;

    if (ref.read(permissionProvider).hasPermission) {
      // Reset trạng thái denied
      await notifier.resetDeniedStatus();
      // Khởi tạo HomePage sau khi có quyền
      await _prepareHomePage();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForSettings) {
      _waitingForSettings = false;
      _checkPermissionAfterSettings();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: SplashContent(
                fadeAnimation: _fadeAnimation,
                logo: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icon/ic_my_melody.png',
                    width: 128,
                    height: 128,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}