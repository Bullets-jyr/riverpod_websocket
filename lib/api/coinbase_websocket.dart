import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final coinbaseWebsocketProvider = Provider.autoDispose<CoinbaseWebsocket>((ref) {
  ref.onDispose(() {
    debugPrint('CoinbaseWebsocket disposed');
  });
  ref.onCancel(() {
    debugPrint('CoinbaseWebsocket cancelled');
  });
  ref.onResume(() {
    debugPrint('CoinbaseWebsocket resumed');
  });
  ref.onAddListener(() {
    debugPrint('CoinbaseWebsocket added');
  });
  ref.onRemoveListener(() {
    debugPrint('CoinbaseWebsocket removed');
  });
  return CoinbaseWebsocket();
});

class CoinbaseWebsocket {
  final url = 'wss://ws-feed-public.sandbox.exchange.coinbase.com';

  CoinbaseWebsocket() {
    debugPrint('CoinbaseWebsocket initialized');
  }

  WebSocketChannel connect() {
    return WebSocketChannel.connect(Uri.parse(url));
  }
}