// Local web preview only. The normal Android entry point remains main.dart.
import 'dart:async';

import 'package:budget/database/generatePreviewData.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/main.dart' as cashew;
import 'package:budget/struct/currencyFunctions.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/defaultPreferences.dart';
import 'package:budget/struct/iconObjects.dart';
import 'package:budget/struct/languageMap.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/navigationFramework.dart';
import 'package:budget/widgets/restartApp.dart';
import 'package:drift/web.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The preview never opens the normal preferences or database. Reload resets it.
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  database = FinanceDatabase(
    WebDatabase.withStorage(DriftWebStorage.volatile()),
  );
  clientID = 'local-web-preview';
  packageInfoGlobal = PackageInfo(
    appName: 'Cashew',
    packageName: 'cashew.local.preview',
    version: '5.4.3',
    buildNumber: '416',
  );
  await loadCurrencyJSON();
  await loadLanguageNamesJSON();
  appStateSettings = await getDefaultPreferences();
  appStateSettings.addAll({
    'theme': 'dark',
    'locale': 'ru',
    'accentColor': '0xFFFB7185',
    'accentSystemColor': false,
    'materialYou': true,
    'hasOnboarded': true,
    'previewDemo': true,
    'hasSignedIn': false,
    'backupSync': false,
    'syncEveryChange': false,
    'forceAutoLogin': false,
    'sharedBudgets': false,
    'emailScanning': false,
    'emailScanningPullToRefresh': false,
    'notificationScanning': false,
    'notifications': false,
    'notificationsUpcomingTransactions': false,
    'enableGoogleLoginFlyIn': false,
    'webForceLoginPopupOnLaunch': false,
    'canShowBackupReminderPopup': false,
    'canShowTransactionActionButtonTip': false,
    'canShowRateAppPopup': false,
    'allSpendingPageTip': false,
    'lastLoginVersion': '5.4.3',
    'showWalletList': true,
    'showAllSpendingSummary': true,
    'showPieChart': true,
    'showSpendingGraph': false,
    // Fixed, fictional exchange rates; no network request is needed.
    'cachedCurrencyExchange': {'usd': 1.0, 'eur': 0.9, 'btc': 0.00002},
  });
  // Skip only the normal startup sync; all original pages and editors are used.
  entireAppLoaded = true;
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tbilisi'));
  iconObjects.sort((a, b) => (a.mostLikelyCategoryName ?? a.icon)
      .compareTo(b.mostLikelyCategoryName ?? b.icon));
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  runApp(EasyLocalization(
    supportedLocales: supportedLocales.values.toList(),
    startLocale: const Locale('ru'),
    fallbackLocale: const Locale('en'),
    path: 'assets/translations/generated',
    assetLoader: const RootBundleAssetLoaderCustomLocaleLoader(),
    useFallbackTranslations: true,
    child: const _PreviewBootstrap(),
  ));
}

class _PreviewBootstrap extends StatefulWidget {
  const _PreviewBootstrap();

  @override
  State<_PreviewBootstrap> createState() => _PreviewBootstrapState();
}

class _PreviewBootstrapState extends State<_PreviewBootstrap> {
  Future<void>? _ready;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Localization is ready here, so the original sample category names translate.
    _ready ??= generatePreviewData().then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home:
                Scaffold(body: Center(child: Text(snapshot.error.toString()))),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              backgroundColor: Color(0xFF080808),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFB7185)),
              ),
            ),
          );
        }
        return RestartApp(child: cashew.InitializeApp(key: cashew.appStateKey));
      },
    );
  }
}
