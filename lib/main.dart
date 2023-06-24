import 'package:af_note/providers/theme_provider.dart';
import 'package:af_note/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kInitialLightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(1, 51, 58, 255),
);

final theme = ThemeData().copyWith(
  colorScheme: kInitialLightColorScheme,
);

final kInitialDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 43, 1, 56),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: kInitialDarkColorScheme,
);

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(themeProvider.notifier).getMode();
    final appThemeMode = ref.watch(themeProvider);
    return MaterialApp(
      theme: appThemeMode == Brightness.dark.index ? darkTheme : theme,
      home: const ProviderScope(
        child: TabsScreen(),
      ),
    );
  }
}
