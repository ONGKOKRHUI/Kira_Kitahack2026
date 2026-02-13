import 'package:firebase_core/firebase_core.dart';
import 'package:kira_app/data/models/gita_item.dart';
import 'package:kira_app/data/models/receipt.dart';
import 'package:kira_app/data/repositories/receipt_repository.dart';

Future <void> main() async {
  print('🚀 Starting Repository Test'); 
  await Firebase.initializeApp();

  final receiptRepo = ReceiptRepository();
  final gitaItem = GitaItem(
    id: 'g001', 
    name: 'R32 Inverted Wall Mounted', 
    supplier: 'Daikin Malaysia Sales and Service Sdn Bhd', 
    quantity: 1.00, 
    unit: 'single', 
    price: 2400, 
    currency: 'MYR', 
    isGitaEligible: true, 
    date: DateTime.now(), 
    tier: 2, 
    sector: 'Energy Efficiency', 
    technology: 'Energy Efficient Appliances', 
    asset: 'Variable Refrigerant Volume (VRV)', 
    gitaAllowance: 1440
  );

  final receiptWithGita = Receipt(
    id: 'r001', 
    supplier: 'Solar Tech Sdn Bhd', 
    date: DateTime.now(), 
    total: 15000.0, 
    imageUrl: 'fake',  
    lineItems: [gitaItem]
  );

  const USER_ID = 'TEST_USER_ID';

  try {
    await receiptRepo.addReceipt(receiptWithGita, USER_ID);
    print('✅ Receipt stored successfully'); 

    final receipts = await receiptRepo.getReceipts(USER_ID);
    print('📦 Fetched Receipts:'); 
    print(receipts.map((r) => r.toJson()).toList());

  } catch (e) {
    print('❌ Repository test failed: $e');
  }
}


// dart run test/test_repository.dart
// flutter run test/test_repository.dart