class DigitalAssetModel {
  final int assetId;
  final String assetName;
  final String ticker;
  final String identifier;
  final DateTime creationDate;
  final Map<String, PriceQuoteModel> priceQuotes;

  DigitalAssetModel({
    required this.assetId,
    required this.assetName,
    required this.ticker,
    required this.identifier,
    required this.creationDate,
    required this.priceQuotes,
  });

  factory DigitalAssetModel.fromJson(Map<String, dynamic> jsonData) {
    return DigitalAssetModel(
      assetId: jsonData['id'] ?? 0,
      assetName: jsonData['name'] ?? '',
      ticker: jsonData['symbol'] ?? '',
      identifier: jsonData['slug'] ?? '',
      creationDate: jsonData['date_added'] != null
          ? DateTime.parse(jsonData['date_added'])
          : DateTime.now(),
      priceQuotes: (jsonData['quote'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, PriceQuoteModel.fromJson(value)),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id': assetId,
    'name': assetName,
    'symbol': ticker,
    'slug': identifier,
    'date_added': creationDate.toIso8601String(),
    'quote': priceQuotes.map((key, value) => MapEntry(key, value.toJson())),
  };
}

class PriceQuoteModel {
  final double currentPrice;
  final double dailyVolume;
  final double hourlyChange;
  final double dailyChange;
  final double weeklyChange;
  final double totalMarketValue;
  final DateTime lastUpdateTime;

  PriceQuoteModel({
    required this.currentPrice,
    required this.dailyVolume,
    required this.hourlyChange,
    required this.dailyChange,
    required this.weeklyChange,
    required this.totalMarketValue,
    required this.lastUpdateTime,
  });

  factory PriceQuoteModel.fromJson(Map<String, dynamic> jsonData) {
    return PriceQuoteModel(
      currentPrice: (jsonData['price'] ?? 0.0).toDouble(),
      dailyVolume: (jsonData['volume_24h'] ?? 0.0).toDouble(),
      hourlyChange: (jsonData['percent_change_1h'] ?? 0.0).toDouble(),
      dailyChange: (jsonData['percent_change_24h'] ?? 0.0).toDouble(),
      weeklyChange: (jsonData['percent_change_7d'] ?? 0.0).toDouble(),
      totalMarketValue: (jsonData['market_cap'] ?? 0.0).toDouble(),
      lastUpdateTime: jsonData['last_updated'] != null
          ? DateTime.parse(jsonData['last_updated'])
          : DateTime.now(),
    );
  }
   Map<String, dynamic> toJson() => {
    'price': currentPrice,
    'volume_24h': dailyVolume,
    'percent_change_1h': hourlyChange,
    'percent_change_24h': dailyChange,
    'percent_change_7d': weeklyChange,
    'market_cap': totalMarketValue,
    'last_updated': lastUpdateTime.toIso8601String(),
  };
}