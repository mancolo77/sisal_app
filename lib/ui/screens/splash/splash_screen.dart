import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../../app/routes/app_router.dart';
import '../../../data/flag_service.dart';
import '../../../data/location_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;

  final FlagService _flagService = FlagService();
  final LocationService _locationService = LocationService();
  bool _isLoadingFlags = false;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Background gradient animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
        );
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.forward();

    // Start logo animation after a short delay
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation when logo is halfway done
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Load flags and decide what to show
    await _loadFlagsAndDecide();
  }

  Future<void> _loadFlagsAndDecide() async {
    setState(() {
      _isLoadingFlags = true;
    });

    try {
      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      bool hasInternet = connectivityResult != ConnectivityResult.none;

      if (!hasInternet) {
        _navigateToApp();
        return;
      }

      // Load flags from Flagsmith
      await _flagService.init();

      if (_flagService.showWebView) {
        String? countryCode = await _locationService.getCountryCode();

        if (countryCode != null &&
            _flagService.webViewConfig.containsKey(countryCode)) {
          _navigateToWebView(_flagService.webViewConfig[countryCode]!);
        } else {
          _navigateToApp();
        }
      } else {
        _navigateToApp();
      }
    } catch (e) {
      print('Error loading flags: $e');
      _navigateToApp();
    }
  }

  void _navigateToApp() {
    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  void _navigateToWebView(String url) {
    if (mounted) {
      context.go('${AppRouter.webview}?url=${Uri.encodeComponent(url)}');
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _flagService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _logoController,
          _textController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.background,
                    AppColors.primary,
                    _backgroundAnimation.value * 0.1,
                  )!,
                  Color.lerp(
                    AppColors.background,
                    AppColors.primary,
                    _backgroundAnimation.value * 0.3,
                  )!,
                  Color.lerp(
                    AppColors.background,
                    AppColors.accent,
                    _backgroundAnimation.value * 0.2,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo Section
                  _buildLogoSection(),

                  const SizedBox(height: 60),

                  // App Name Section
                  _buildAppNameSection(),

                  const Spacer(flex: 2),

                  // Start Button
                  _buildStartButton(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Transform.scale(
      scale: _logoScaleAnimation.value,
      child: Opacity(
        opacity: _logoOpacityAnimation.value,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.accent],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(Icons.quiz, size: 50, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildAppNameSection() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: Column(
          children: [
            // Main app name
            Text(
              'SISAL IT',
              style: AppTypography.h1.copyWith(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 2.0,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Sports Quiz Arena',
                style: AppTypography.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tagline
            Text(
              'Test Your Sports Knowledge',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    if (_isLoadingFlags) {
      return FadeTransition(
        opacity: _textOpacityAnimation,
        child: SlideTransition(
          position: _textSlideAnimation,
          child: Container(
            width: 200,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.background,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading...',
                    style: AppTypography.button.copyWith(
                      color: AppColors.background,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _textOpacityAnimation,
      child: SlideTransition(
        position: _textSlideAnimation,
        child: Container(
          width: 200,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () {
                context.go(AppRouter.home);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.background,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'START',
                      style: AppTypography.button.copyWith(
                        color: AppColors.background,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
