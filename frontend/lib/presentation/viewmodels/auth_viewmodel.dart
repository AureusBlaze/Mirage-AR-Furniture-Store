import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/user.dart';
import 'package:mirage_by_aurues/domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _authRepository.isAuthenticated();
    if (_isAuthenticated) {
      await fetchCurrentUser();
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    _isLoading = false;
    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _user = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    _isLoading = false;
    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _user = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.logout();

    _user = null;
    _isAuthenticated = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) {
        _isAuthenticated = false;
        _error = failure.message;
      },
      (user) {
        _user = user;
        _isAuthenticated = true;
      },
    );
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
