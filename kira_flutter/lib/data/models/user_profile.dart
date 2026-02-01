class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  
  // Company details
  final String companyName;
  final String? industry;
  final String? companySize;
  final String? country;
  final String? regNumber;
  final String? companyAddress;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  
  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.companyName,
    this.industry,
    this.companySize,
    this.country,
    this.regNumber,
    this.companyAddress,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // From Firestore
  factory UserProfile.fromFirestore(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      companyName: json['companyName'] as String,
      industry: json['industry'] as String?,
      companySize: json['companySize'] as String?,
      country: json['country'] as String? ?? 'Malaysia',
      regNumber: json['regNumber'] as String?,
      companyAddress: json['companyAddress'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  
  // To Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'companyName': companyName,
      'industry': industry,
      'companySize': companySize,
      'country': country,
      'regNumber': regNumber,
      'companyAddress': companyAddress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
  // Copy with
  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? companyName,
    String? industry,
    String? companySize,
    String? country,
    String? regNumber,
    String? companyAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      companySize: companySize ?? this.companySize,
      country: country ?? this.country,
      regNumber: regNumber ?? this.regNumber,
      companyAddress: companyAddress ?? this.companyAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
