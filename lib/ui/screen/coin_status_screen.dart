import 'package:flutter/material.dart';
import 'package:riverpod_websocket/ui/widget/coin_status_list.dart';
import 'package:riverpod_websocket/ui/widget/refresh_button_widget.dart';

class CoinStatusScreen extends StatefulWidget {
  const CoinStatusScreen({ super.key });

  @override
  State<CoinStatusScreen> createState() => _CoinStatusScreenState();
}

class _CoinStatusScreenState extends State<CoinStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Status'),
        actions: const [
          RefreshButton(),
        ],
      ),
      // body: Container(),
      body: const CoinStatusList(),
    );
  }
}