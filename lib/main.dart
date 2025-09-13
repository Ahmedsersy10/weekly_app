import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/view_model/settings_cubit.dart';
import 'package:weekly_dash_board/fetuers/splash/presentation/views/splash_view.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false, // Set to false to disable Device Preview
      builder: (context) => const ResponsiveDashboardApp(), // Wrap your app
    ),
  );
}

class ResponsiveDashboardApp extends StatelessWidget {
  const ResponsiveDashboardApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WeeklyCubit()),
        BlocProvider(create: (_) => SettingsCubit()..loadSettings()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final s = state.settings;
          final locale = _mapLocale(s?.language);
          final primaryColor = s?.primaryColor ?? AppColors.primary;

          final lightTheme = ThemeData(
            fontFamily: 'ReadexPro',
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: true,
          );

          return MaterialApp(
            home: const SplashView(),
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            locale: locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('ar', '')],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              final code = (locale != null
                  ? locale.languageCode
                  : (deviceLocale != null ? deviceLocale.languageCode : 'en'));
              return supportedLocales.firstWhere(
                (l) => l.languageCode == code,
                orElse: () => const Locale('en', ''),
              );
            },
          );
        },
      ),
    );
  }

  Locale _mapLocale(dynamic language) {
    if (language == null) return const Locale('en', '');
    final str = language.toString();
    if (str.contains('arabic')) return const Locale('ar', '');
    return const Locale('en', '');
  }
}
