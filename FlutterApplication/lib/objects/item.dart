class Item {
  final String itemName;
  final double itemValue;
  final int itemID;
  final double shareValue;
  final double totalShares;
  final double availableShares;
  final String description;
  final String sharesWorth;
  final String netChange;
  final String shareCount;
  final String averageCost;

  Item({this.itemName, this.shareCount, this.averageCost, this.netChange, this.itemValue, this.itemID, this.shareValue, this.totalShares, this.availableShares, this.description, this.sharesWorth});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['itemName'],
      itemValue: double.parse(json['itemValue']),
      itemID: json['itemID'],
      shareValue: json['shareValue'],
      totalShares: json['totalShares'],
      availableShares: json['availableShares'],
      description: json['description'],
      sharesWorth: json['sharesWorth'].toString(),
      netChange: json['netChange'].toString(),
      shareCount: json['shareCount'].toString(),
      averageCost: json['averageCost'].toString()
    );
  }
}