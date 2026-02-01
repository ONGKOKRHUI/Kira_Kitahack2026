/// Receipt Repository
/// 
/// Manages receipt storage using in-memory storage (works on all platforms).
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../models/receipt.dart';
import '../services/gemini_service.dart';

/// Repository for managing receipts (in-memory)
class ReceiptRepository {
  final GeminiService _geminiService = GeminiService();
  final List<Receipt> _receipts = [];
  bool _initialized = false;
  
  /// Initialize (no-op for in-memory)
  Future<void> init() async {
    _initialized = true;
  }
  
  /// Process image and save receipt (from file path - mobile/desktop)
  Future<Receipt> processReceipt(String imagePath) async {
    print('📥 Repository: Processing receipt from $imagePath');
    
    // Read image bytes
    final file = File(imagePath);
    final imageBytes = await file.readAsBytes();
    
    return _processReceiptInternal(imageBytes, imagePath);
  }
  
  /// Process image and save receipt (from bytes - web compatible)
  Future<Receipt> processReceiptFromBytes(List<int> imageBytes, String imagePath) async {
    print('📥 Repository: Processing receipt from bytes (${imageBytes.length} bytes)');
    return _processReceiptInternal(imageBytes, imagePath);
  }
  
  /// Internal method to process receipt from bytes
  Future<Receipt> _processReceiptInternal(List<int> imageBytes, String imagePath) async {
    print('📥 Repository: Calling Gemini service with ${imageBytes.length} bytes');
    
    // Extract data using Gemini
    final extractedData = await _geminiService.extractReceiptData(Uint8List.fromList(imageBytes));
    
    // Create receipt
    final receipt = Receipt.fromExtraction(
      id: const Uuid().v4(),
      json: extractedData,
      imagePath: imagePath,
    );
    
    print('📥 Repository: Created receipt: ${receipt.id}');
    print('   Vendor: ${receipt.vendor}');
    print('   Category: ${receipt.category}');
    print('   CO2: ${receipt.co2Kg} kg');
    
    // Save to memory
    _receipts.insert(0, receipt); // Add to beginning
    print('📥 Repository: Saved! Total receipts: ${_receipts.length}');
    
    return receipt;
  }
  
  /// Get all receipts
  Future<List<Receipt>> getAllReceipts() async {
    return List.from(_receipts);
  }
  
  /// Get receipts by scope
  Future<List<Receipt>> getReceiptsByScope(int scope) async {
    return _receipts.where((r) => r.scope == scope).toList();
  }
  
  /// Get receipts by date range
  Future<List<Receipt>> getReceiptsByDateRange(DateTime start, DateTime end) async {
    return _receipts
        .where((r) => r.date.isAfter(start) && r.date.isBefore(end))
        .toList();
  }
  
  /// Get total CO2 by scope (in tonnes)
  Future<double> getTotalCO2ByScope(int scope) async {
    final total = _receipts
        .where((r) => r.scope == scope)
        .fold<double>(0.0, (sum, r) => sum + r.co2Tonnes);
    return total;
  }
  
  /// Get total CO2 (all scopes, in tonnes)
  Future<double> getTotalCO2() async {
    final total = _receipts.fold<double>(0.0, (sum, r) => sum + r.co2Tonnes);
    return total;
  }
  
  /// Delete receipt
  Future<void> deleteReceipt(String id) async {
    _receipts.removeWhere((r) => r.id == id);
  }
  
  /// Clear all receipts
  Future<void> clearAll() async {
    _receipts.clear();
  }
}
