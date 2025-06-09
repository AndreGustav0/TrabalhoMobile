import 'package:flutter/material.dart';
import 'package:api_market_cap_coin/domain/entities/digital_asset_model.dart';
import 'package:api_market_cap_coin/domain/repositories/i_asset_repository.dart';
import 'package:api_market_cap_coin/core/library/app_defaults.dart';

enum ScreenState { idle, loading, success, error }

class AssetViewModel extends ChangeNotifier {
  final IAssetRepository _assetRepository;

  AssetViewModel(this._assetRepository);

  List<DigitalAssetModel> _digitalAssets = [];
  List<DigitalAssetModel> get digitalAssets => _digitalAssets;

  ScreenState _currentState = ScreenState.idle;
  ScreenState get currentState => _currentState;

  String _errorText = '';
  String get errorText => _errorText;

  Future<void> loadDigitalAssets({String? tickerSymbols}) async {
    _currentState = ScreenState.loading;
    notifyListeners();

    try {
      final symbolsToLoad = tickerSymbols == null || tickerSymbols.trim().isEmpty 
          ? AppDefaults.initialSymbols 
          : tickerSymbols.trim();
      
      print('AssetViewModel: Loading with symbols: "$symbolsToLoad"');
      _digitalAssets = await _assetRepository.fetchDigitalAssets(symbolsToLoad);
      _currentState = ScreenState.success;
      print('AssetViewModel: Successfully loaded ${_digitalAssets.length} assets.');
    } catch (e) {
      _errorText = e.toString();
      _currentState = ScreenState.error;
      print('AssetViewModel: Error loading assets: $_errorText');
    }
    notifyListeners();
  }
}