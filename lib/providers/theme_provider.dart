import 'package:af_note/helpers/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<int> {
  ThemeNotifier() : super(Brightness.light.index);

  Future<void> getMode() async {
    state = await Prefs().getAppThemeMode();
  }

  void toggleMode() async {
    state = await Prefs().toggleAppThemeMode();
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, int>((ref) => ThemeNotifier());
