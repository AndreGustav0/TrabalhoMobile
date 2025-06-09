import 'package:api_market_cap_coin/core/service/network_client.dart';
import 'package:api_market_cap_coin/domain/entities/digital_asset_model.dart';

abstract class IAssetApiSource {
  Future<List<DigitalAssetModel>> fetchDigitalAssets(String tickerSymbols);
}

class AssetApiSource implements IAssetApiSource {
  final NetworkClient _networkClient;

  AssetApiSource(this._networkClient);

  @override
  Future<List<DigitalAssetModel>> fetchDigitalAssets(String tickerSymbols) async {
    print('Fetching digital assets for symbols: $tickerSymbols');
    try {
      final apiResponse = await _networkClient.executeRequest(
        path: '/v2/cryptocurrency/quotes/latest?symbol=$tickerSymbols&convert=BRL',
      );

      print('Raw API Response: $apiResponse');

      if (apiResponse != null && apiResponse['data'] != null) {
        final Map<String, dynamic> responseData = apiResponse['data'];
        final List<DigitalAssetModel> assetList = [];
        responseData.forEach((key, value) {
          if (value is List) { 
            for (var item in value) {
              if (item is Map<String, dynamic>) {
                 try {
                    assetList.add(DigitalAssetModel.fromJson(item));
                 } catch (e) {
                    print('Error parsing item for key $key: $item. Error: $e');
                 }
              }
            }
          } else if (value is Map<String, dynamic>) {
             try {
                assetList.add(DigitalAssetModel.fromJson(value));
             } catch (e) {
                print('Error parsing value for key $key: $value. Error: $e');
             }
          }
        });
        print('Parsed ${assetList.length} digital assets.');
        return assetList;
      } else {
        print('No data found in response or response is null.');
        return [];
      }
    } catch (e) {
      print('Error in AssetApiSource.fetchDigitalAssets: $e');
      throw Exception('Failed to fetch digital assets: $e');
    }
  }
}