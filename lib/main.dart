import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_market_cap_coin/core/service/network_client.dart';
import 'package:api_market_cap_coin/data/datasources/asset_api_source.dart';
import 'package:api_market_cap_coin/data/repositories/asset_repository.dart';
import 'package:api_market_cap_coin/domain/repositories/i_asset_repository.dart';
import 'package:api_market_cap_coin/ui/view_models/asset_view_model.dart';
import 'package:api_market_cap_coin/ui/pages/asset_dashboard_page.dart';


void main() async {
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    final NetworkClient networkClient = NetworkClient();
    final IAssetApiSource apiDataSource = AssetApiSource(networkClient);
    final IAssetRepository assetRepository = AssetRepository(apiDataSource);

    return ChangeNotifierProvider(
      create: (context) => AssetViewModel(assetRepository),
      child: MaterialApp(
        title: 'Digital Asset Market Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange[400],
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)
            )
          )
        ),
        home: const AssetDashboardPage(),
      ),
    );
  }
}
