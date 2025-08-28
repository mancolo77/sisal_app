import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sisal_app/data/flag_service.dart';
import 'package:sisal_app/data/location_service.dart';
import 'package:sisal_app/data/webview_page.dart';
import 'package:sisal_app/app/routes/app_router.dart';
import 'package:go_router/go_router.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final FlagService _flagService = FlagService();
  final LocationService _locationService = LocationService();

  bool _isLoading = true;
  bool _shouldShowWebView = false;
  String _webViewUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = connectivityResult != ConnectivityResult.none;

    if (!hasInternet) {
      _navigateToApp();
      return;
    }

    try {
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
      print('Error locations: $e');

      _navigateToApp();
    }
  }

  void _navigateToApp() {
    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  void _navigateToWebView(String url) {
    setState(() {
      _shouldShowWebView = true;
      _webViewUrl = url;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_shouldShowWebView && _webViewUrl.isNotEmpty) {
      return WebviewPage(url: _webViewUrl);
    }

    // This should not be reached as we navigate directly
    return const Scaffold(body: Center(child: Text('Redirecting...')));
  }

  @override
  void dispose() {
    _flagService.close();
    super.dispose();
  }
}
