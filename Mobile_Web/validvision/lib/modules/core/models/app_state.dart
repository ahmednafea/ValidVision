import 'package:flutter/material.dart';

@immutable
class AppState {
  final bool isLoading;

  AppState({
    this.isLoading = false,
  });
}
