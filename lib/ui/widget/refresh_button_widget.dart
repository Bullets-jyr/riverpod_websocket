import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshButton extends ConsumerWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        // ref.read(coinStatusViewModelProvider.notifier).reset();
      },
      icon: const Icon(Icons.refresh),
    );
  }
}