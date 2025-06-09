import 'package:api_market_cap_coin/domain/entities/digital_asset_model.dart';

abstract class IAssetRepository {
  Future<List<DigitalAssetModel>> fetchDigitalAssets(String tickerSymbols);
}