class FidelityCard {
  String id;
  String clientName;
  String clientAddress;
  String qrCode;
  String barCode;
  int loyaltyPoints;

  FidelityCard({
    required this.id,
    required this.clientName,
    required this.clientAddress,
    required this.qrCode,
    required this.barCode,
    this.loyaltyPoints = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'clientAddress': clientAddress,
      'qrCode': qrCode,
      'barCode': barCode,
      'loyaltyPoints': loyaltyPoints,
    };
  }

  factory FidelityCard.fromMap(Map<String, dynamic> map) {
    return FidelityCard(
      id: map['id'],
      clientName: map['clientName'],
      clientAddress: map['clientAddress'],
      qrCode: map['qrCode'],
      barCode: map['barCode'],
      loyaltyPoints: map['loyaltyPoints'] ?? 0,
    );
  }
}


