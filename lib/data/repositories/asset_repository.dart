import 'package:api_market_cap_coin/data/datasources/asset_api_source.dart';
import 'package:api_market_cap_coin/domain/entities/digital_asset_model.dart';
import 'package:api_market_cap_coin/domain/repositories/i_asset_repository.dart';

class AssetRepository implements IAssetRepository {
  final IAssetApiSource _apiDataSource;

  AssetRepository(this._apiDataSource);

  @override
  Future<List<DigitalAssetModel>> fetchDigitalAssets(String tickerSymbols) async {
    print('AssetRepository: getting digital assets for symbols: $tickerSymbols');
    try {
      final repositoryResult = await _apiDataSource.fetchDigitalAssets(tickerSymbols);
      print('AssetRepository: received ${repositoryResult.length} assets from data source.');
      return repositoryResult;
    } catch (e) {
      print('AssetRepository: Error fetching digital assets: $e');
     
      rethrow;
    }
  }
}