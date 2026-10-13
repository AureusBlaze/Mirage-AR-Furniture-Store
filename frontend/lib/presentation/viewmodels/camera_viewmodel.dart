import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';
import 'package:mirage_by_aurues/domain/repositories/ai_repository.dart';

class CameraViewModel extends ChangeNotifier {
  final AiRepository _aiRepository;
  final ImagePicker _picker = ImagePicker();

  CameraViewModel(this._aiRepository);

  File? _capturedImage;
  List<Product> _suggestions = [];
  String? _roomDescription;
  bool _isLoading = false;
  bool _isAnalyzing = false;
  String? _error;

  File? get capturedImage => _capturedImage;
  List<Product> get suggestions => _suggestions;
  String? get roomDescription => _roomDescription;
  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  String? get error => _error;

  Future<void> captureFromCamera() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (photo != null) {
        _capturedImage = File(photo.path);
        _suggestions = [];
        _roomDescription = null;
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to capture image: $e';
      notifyListeners();
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (photo != null) {
        _capturedImage = File(photo.path);
        _suggestions = [];
        _roomDescription = null;
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> analyzeRoom() async {
    if (_capturedImage == null) return;

    _isAnalyzing = true;
    _error = null;
    notifyListeners();

    final result = await _aiRepository.getSuggestions(_capturedImage!);
    result.fold(
      (failure) => _error = failure.message,
      (analysisResult) {
        _suggestions = analysisResult.products;
        _roomDescription = analysisResult.description;
      },
    );

    _isAnalyzing = false;
    notifyListeners();
  }

  void reset() {
    _capturedImage = null;
    _suggestions = [];
    _roomDescription = null;
    _error = null;
    _isAnalyzing = false;
    notifyListeners();
  }
}
