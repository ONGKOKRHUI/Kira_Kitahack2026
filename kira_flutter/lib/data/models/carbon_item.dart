import 'package:kira_app/data/models/line_item.dart';

class CarbonItem extends LineItem{
  final int scope;
  final double activityData;
  final double emissionFactor;
  final double gwp;
  final double gef;
  final double co2eEmission;

  CarbonItem({
    required super.id,
    required super.name,
    required super.supplier,
    required super.quantity,
    required super.unit,
    required super.price,
    required super.currency,
    required super.isGitaEligible,
    required super.date,
    required this.scope,
    required this.activityData,
    required this.emissionFactor,
    required this.gwp,
    required this.gef,
    required this.co2eEmission,
  });

  factory CarbonItem.fromJson(Map<String, dynamic> json) {
    final base = LineItem.fromJson(json);

    return CarbonItem(
      id: base.id,
      name: base.name,
      supplier: base.supplier,
      quantity: base.quantity,
      unit: base.unit,
      price: base.price,
      currency: base.currency,
      isGitaEligible: base.isGitaEligible,
      date: base.date,
      scope: json['scope'] as int,
      activityData: json['activityData'] as double,
      emissionFactor: json['emissionFactor'] as double,
      gwp: json['gwp'] as double,
      gef: json['gef'] as double,
      co2eEmission: json['co2eEmission'] as double,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'scope': scope,
      'activityData': activityData,
      'emissionFactor': emissionFactor,
      'gwp': gwp,
      'gef': gef,
      'co2eEmission': co2eEmission,
    };
  }
}