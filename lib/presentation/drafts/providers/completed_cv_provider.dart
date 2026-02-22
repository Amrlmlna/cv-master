import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../../domain/entities/completed_cv.dart';

const _storageKey = 'completed_cvs';

class CompletedCVNotifier extends AsyncNotifier<List<CompletedCV>> {
  @override
  Future<List<CompletedCV>> build() async {
    return _loadFromStorage();
  }

  Future<List<CompletedCV>> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    final cvs = CompletedCV.listFromJsonString(jsonString);
    
    // Filter out CVs whose PDF files no longer exist
    final validCVs = <CompletedCV>[];
    for (final cv in cvs) {
      if (await File(cv.pdfPath).exists()) {
        validCVs.add(cv);
      }
    }
    
    if (validCVs.length != cvs.length) {
      await _saveToStorage(validCVs);
    }
    
    return validCVs;
  }

  Future<void> _saveToStorage(List<CompletedCV> cvs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, CompletedCV.listToJsonString(cvs));
  }

  Future<void> addCompletedCV(CompletedCV cv) async {
    final current = state.value ?? [];
    final updated = [cv, ...current];
    await _saveToStorage(updated);
    state = AsyncData(updated);
  }

  Future<void> deleteCompletedCV(String id) async {
    final current = state.value ?? [];
    final cv = current.firstWhere((c) => c.id == id);
    
    final pdfFile = File(cv.pdfPath);
    if (await pdfFile.exists()) await pdfFile.delete();
    if (cv.thumbnailPath != null) {
      final thumbFile = File(cv.thumbnailPath!);
      if (await thumbFile.exists()) await thumbFile.delete();
    }
    
    final updated = current.where((c) => c.id != id).toList();
    await _saveToStorage(updated);
    state = AsyncData(updated);
  }

  static Future<Directory> getStorageDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cvDir = Directory('${appDir.path}/completed_cvs');
    if (!await cvDir.exists()) {
      await cvDir.create(recursive: true);
    }
    return cvDir;
  }

  static Future<Directory> getThumbnailDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final thumbDir = Directory('${appDir.path}/cv_thumbnails');
    if (!await thumbDir.exists()) {
      await thumbDir.create(recursive: true);
    }
    return thumbDir;
  }
}

final completedCVProvider = AsyncNotifierProvider<CompletedCVNotifier, List<CompletedCV>>(
  CompletedCVNotifier.new,
);
