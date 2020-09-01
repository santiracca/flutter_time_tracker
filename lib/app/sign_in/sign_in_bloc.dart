import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeTracker/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  Future<AppUser> _signIn(Future<AppUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<AppUser> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<AppUser> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
}
