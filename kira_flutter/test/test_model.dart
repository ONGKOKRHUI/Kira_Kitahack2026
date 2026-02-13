import 'package:kira_app/data/models/carbon_item.dart';
import 'package:kira_app/data/models/gita_item.dart';
import 'package:kira_app/data/models/receipt.dart';

void main() {

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

  print('🌱 GITA JSON:');
  print(gitaItem.toJson());

  final receiptWithGita = Receipt(
    id: 'r001', 
    supplier: 'Solar Tech Sdn Bhd', 
    date: DateTime.now(), 
    total: 15000.0, 
    imageUrl: 'fake',  
    lineItems: [gitaItem]
  );

  print('🧾 Receipt with GITA item to JSON:');
  print(receiptWithGita.toJson());

  final carbonItem = CarbonItem(
    id: 'c001', 
    name: 'Diesal', 
    supplier: 'Petronas', 
    quantity: 100, 
    unit: 'litres', 
    price: 500, 
    currency: 'MYR', 
    isGitaEligible: false, 
    date: DateTime.now(), 
    scope: 1, 
    activityData: 10, 
    emissionFactor: 2.5, 
    gwp: 1, 
    gef: 0, 
    co2eEmission: 25
  );

  print('🌍 Carbon JSON:');
  print(carbonItem.toJson());

  final receiptWithCarbon = Receipt(
    id: 'r002', 
    supplier: 'Petronas', 
    date: DateTime.now(), 
    total: 500.0, 
    imageUrl: 'fake', 
    lineItems: [gitaItem]
  );

  print('🧾 Receipt with Carbon item to JSON:');
  print(receiptWithCarbon.toJson());
}

// dart run test/test_model.dart

