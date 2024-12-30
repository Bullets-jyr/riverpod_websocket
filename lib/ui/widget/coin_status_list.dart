import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_websocket/repository/coinbase_status_repository.dart';

class CoinStatusList extends ConsumerWidget {
  const CoinStatusList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('CoinStatusList build');
    final asyncValue = ref.watch(coinbaseStatusRepositoryProvider);
    // final asyncValue = ref.watch(coinStatusViewModelProvider.select((state) => state.data));

    return asyncValue.when(
      data: (data) {
        final coins = data['products'] as List<dynamic>;
        return ListView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final coin = coins[index] as Map<String, dynamic>;

            return ListTile(
              title: Text(coin['id'] as String),
              subtitle: Text(coin['status'] as String),
              // onTap: () {
              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (_) =>
              //           CoinPriceScreen(productIds: [coin['id'] as String])));
              // },
            );
          },
        );
      },
      error: (e, s) => Center(
        child: Text(
          e.toString(),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
