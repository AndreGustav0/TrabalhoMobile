import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:api_market_cap_coin/ui/view_models/asset_view_model.dart';
import 'package:api_market_cap_coin/domain/entities/digital_asset_model.dart';

class AssetDashboardPage extends StatefulWidget {
  const AssetDashboardPage({super.key});

  @override
  State<AssetDashboardPage> createState() => _AssetDashboardPageState();
}

class _AssetDashboardPageState extends State<AssetDashboardPage> {
  final TextEditingController _inputController = TextEditingController();
  final NumberFormat _dollarFormatter = NumberFormat.currency(locale: 'en_US', symbol: 'USD ');
  final NumberFormat _realFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'BRL ');

  @override
  void initState() {
    super.initState();
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetViewModel>(context, listen: false).loadDigitalAssets();
    });
  }

  void _displayAssetDetails(BuildContext context, DigitalAssetModel asset) {
    final dollarPrice = asset.priceQuotes['USD']?.currentPrice ?? 0.0;
    final realPrice = asset.priceQuotes['BRL']?.currentPrice ?? 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange[100],
                child: Text(
                  asset.ticker.substring(0, asset.ticker.length > 2 ? 2 : asset.ticker.length),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.assetName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      asset.ticker,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _createDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Date Added',
                  value: DateFormat.yMd().add_jms().format(asset.creationDate.toLocal()),
                ),
                const SizedBox(height: 16),
                _createDetailRow(
                  icon: Icons.attach_money,
                  label: 'Price (USD)',
                  value: _dollarFormatter.format(dollarPrice),
                  valueColor: Colors.green[600],
                ),
                const SizedBox(height: 16),
                _createDetailRow(
                  icon: Icons.monetization_on,
                  label: 'Price (BRL)',
                  value: _realFormatter.format(realPrice),
                  valueColor: Colors.blue[600],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

 @override
  Widget build(BuildContext context) {
    final assetViewModel = Provider.of<AssetViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Digital Asset Market',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Search Symbols (e.g., BTC, ETH)',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.orange[600]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.orange[600]),
                    onPressed: () {
                      assetViewModel.loadDigitalAssets(tickerSymbols: _inputController.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onSubmitted: (value) {
                  assetViewModel.loadDigitalAssets(tickerSymbols: value);
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => assetViewModel.loadDigitalAssets(tickerSymbols: _inputController.text.isEmpty ? null : _inputController.text),
              color: Colors.orange[600],
              child: _renderAssetList(assetViewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderAssetList(AssetViewModel assetViewModel) {
    if (assetViewModel.currentState == ScreenState.loading && assetViewModel.digitalAssets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading digital assets...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    if (assetViewModel.currentState == ScreenState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load data: ${assetViewModel.errorText}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (assetViewModel.digitalAssets.isEmpty && assetViewModel.currentState == ScreenState.success) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No digital assets found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for different symbols',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    if (assetViewModel.digitalAssets.isEmpty && assetViewModel.currentState == ScreenState.loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: assetViewModel.digitalAssets.length,
      itemBuilder: (context, index) {
        final digitalAsset = assetViewModel.digitalAssets[index];
        final dollarPrice = digitalAsset.priceQuotes['USD']?.currentPrice ?? 0.0;
        final realPrice = digitalAsset.priceQuotes['BRL']?.currentPrice ?? 0.0;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Text(
                digitalAsset.ticker.substring(0, digitalAsset.ticker.length > 2 ? 2 : digitalAsset.ticker.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                  fontSize: 14,
                ),
              ),
            ),
            title: Text(
              '${digitalAsset.assetName} (${digitalAsset.ticker})',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'USD: ${_dollarFormatter.format(dollarPrice)}',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'BRL: ${_realFormatter.format(realPrice)}',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
            onTap: () => _displayAssetDetails(context, digitalAsset),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}