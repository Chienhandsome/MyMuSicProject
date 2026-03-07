import 'package:flutter/material.dart';
import 'package:my_music_project/splash/splash_background.dart';
import 'package:my_music_project/splash/splash_content.dart';
import 'package:my_music_project/splash/splash_logo.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../home_page.dart';
import '../generated/l10n/app_localizations.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
  with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showPermissionRequest = false;
  bool _isCheckingPermission = true;

  // Pre-built HomePage để chuyển đổi mượt mà
  Widget? _preloadedHomePage;
  bool _isHomePageReady = false;

  @override
  void initState() {
    super.initState();
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

    final viewModel = context.read<MusicPlayerViewModel>();
    await viewModel.requestPermission();

    if (!mounted) return;

    if (viewModel.hasPermission) {
      // Bắt đầu khởi tạo HomePage và load data đồng thời
      setState(() {
        _isCheckingPermission = false;
      });
      await _prepareHomePage();
    } else {
      setState(() {
        _isCheckingPermission = false;
        _showPermissionRequest = true;
      });
    }
  }

  Future<void> _prepareHomePage() async {
    if (!mounted) return;

    final viewModel = context.read<MusicPlayerViewModel>();

    // Tạo HomePage widget trước
    _preloadedHomePage = const HomePage();

    // Khởi tạo ViewModel (load songs, etc.)
    await viewModel.init();

    if (!mounted) return;

    setState(() {
      _isHomePageReady = true;
    });

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
    final viewModel = context.read<MusicPlayerViewModel>();
    await viewModel.requestPermission();

    if (!mounted) return;

    if (viewModel.hasPermission) {
      // Khởi tạo HomePage sau khi có quyền
      await _prepareHomePage();
    } else {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permissionDenied),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
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
            return Stack(
              children: [
                Center(
                  child: SplashContent(
                    fadeAnimation: _fadeAnimation,
                    logo: SplashLogo(scaleAnimation: _scaleAnimation),
                  ),
                ),
                // Hiển thị trạng thái loading khi đang chuẩn bị
                if (!_isCheckingPermission && !_showPermissionRequest && !_isHomePageReady)
                  //_buildLoadingIndicator(),
                if (_showPermissionRequest)
                  _buildPermissionRequest(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.loadingMusic,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRequest() {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            const Icon(Icons.lock, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              l10n.permissionRequired,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.permissionMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _requestPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                l10n.grantPermission,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}