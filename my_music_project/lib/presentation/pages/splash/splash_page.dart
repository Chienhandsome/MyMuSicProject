import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../splash/splash_background.dart';
import '../splash/splash_content.dart';
import '../splash/splash_logo.dart';
import '../../../../l10n/app_localizations.dart';
import '../home_page.dart';
import '../../viewmodels/music_player_viewmodel.dart';
import '../../viewmodels/permission_viewmodel.dart';


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

  // Pre-built HomePage để chuyển đổi mượt mà
  Widget? _preloadedHomePage;

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

    final permissionViewModel = context.read<PermissionViewModel>();
    
    try {
      // Load trạng thái permission denied trước
      await permissionViewModel.loadPermissionDeniedStatus();

      if (!mounted) return;

      // Nếu chưa từng từ chối quyền, request luôn
      if (!permissionViewModel.hasPermanentlyDenied) {
        await _requestPermission();
      } else {
        // Nếu đã từng từ chối, check permission trước rồi show dialog phù hợp
        await permissionViewModel.checkPermission();
        
        if (!mounted) return;

        if (permissionViewModel.hasPermission) {
          await _prepareHomePage();
        } else {
          setState(() {
            _showPermissionRequest = true;
          });
        }
      }
    } catch (e) {
      // Nếu có lỗi bất kỳ, hiển thị dialog permission request
      developer.log('Error in _initializeApp: $e');
      if (mounted) {
        setState(() {
          _showPermissionRequest = true;
        });
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

    final viewModel = context.read<MusicPlayerViewModel>();

    // Tạo HomePage widget trước
    _preloadedHomePage = const HomePage();

    // Khởi tạo ViewModel (load songs, etc.)
    await viewModel.init();

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
    final permissionViewModel = context.read<PermissionViewModel>();
    await permissionViewModel.requestPermission();

    if (!mounted) return;

    if (permissionViewModel.hasPermission) {
      // Khởi tạo HomePage sau khi có quyền
      await _prepareHomePage();
    } else {
      if (mounted) {
        setState(() {
          // Giữ nguyên trạng thái show permission request
          // UI sẽ tự động cập nhật để hiển thị dialog với 2 nút
        });
      }
    }
  }

  Future<void> _checkPermissionAfterSettings() async {
    final permissionViewModel = context.read<PermissionViewModel>();
    await permissionViewModel.checkPermission();

    if (!mounted) return;

    if (permissionViewModel.hasPermission) {
      // Reset trạng thái denied
      await permissionViewModel.resetPermissionDeniedStatus();
      // Khởi tạo HomePage sau khi có quyền
      await _prepareHomePage();
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
                // Hiển thị permission request dialog khi cần
                if (_showPermissionRequest)
                  _buildPermissionRequest(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Consumer<PermissionViewModel>(
      builder: (context, permissionViewModel, _) {
        final l10n = AppLocalizations.of(context)!;
        final hasPermanentlyDenied = permissionViewModel.hasPermanentlyDenied;

        return Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Icon(
                  hasPermanentlyDenied ? Icons.settings_suggest : Icons.lock,
                  size: 64,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                Text(
                  hasPermanentlyDenied 
                      ? l10n.permissionRequired 
                      : l10n.permissionRequired,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    hasPermanentlyDenied
                        ? l10n.permissionDeniedMessage
                        : l10n.permissionMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                if (hasPermanentlyDenied) ...[
                  // Hiển thị 2 nút khi đã từng từ chối
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _exitApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _openAppSettings();
                          // Khi user quay lại từ settings, kiểm tra lại permission
                          await _checkPermissionAfterSettings();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: Text(
                          l10n.openSettings,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Hiển thị 1 nút khi chưa từng từ chối
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
              ],
            ),
          ),
        );
      },
    );
  }
}