import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_websocket/api/coinbase_websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// final coinbaseStatusRepositoryProvider = AutoDisposeStreamProvider<Map<String, dynamic>>((ref) {
//   final coinbaseWebsocket = ref.watch(coinbaseWebsocketProvider);
//   final coinbaseStatusRepository = CoinbaseStatusRepository(coinbaseWebsocket);
//
//   ref.onDispose(() {
//     coinbaseStatusRepository._unSubscribeToStatus();
//     coinbaseStatusRepository.dispose();
//     ref.invalidate(coinbaseWebsocketProvider);
//
//     debugPrint('CoinbaseStatusRepository disposed');
//   });
//   ref.onCancel(() {
//     debugPrint('CoinbaseStatusRepository cancelled');
//   });
//   ref.onResume(() {
//     debugPrint('CoinbaseStatusRepository resumed');
//   });
//   ref.onAddListener(() {
//     debugPrint('CoinbaseStatusRepository added');
//   });
//   ref.onRemoveListener(() {
//     debugPrint('CoinbaseStatusRepository removed');
//   });
//
//
//   return coinbaseStatusRepository.stream;
// });

class CoinbaseStatusRepository {
  final CoinbaseWebsocket _coinbaseWebsocket;

  CoinbaseStatusRepository(this._coinbaseWebsocket) {
    _init();
  }

  WebSocketChannel? _channel;
  bool _isDisposed = false;
  bool _isSubscribed = false;
  // final StreamController<Map<String, dynamic>> _streamController =
  // StreamController<Map<String, dynamic>>();
  // Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void _init() {
    // 따라서 일단 연결하면 해당 상태의 이 특정 채널을 구독하게 됩니다.
    _channel = _coinbaseWebsocket.connect();
    _subscribeToStatus();
    // _listen();
  }

  void _subscribeToStatus() {
    // check if we are not already disposed
    if (_isDisposed || _isSubscribed) return;

    // 왜냐하면 이것을 인코딩하여 WebSocket을 보내야 하기 때문입니다.
    final message = jsonEncode({
      "type": "subscribe",
      "channels": [
        {"name": "status"}
      ],
    });

    // Subscribe to status
    _isSubscribed = true;
    // Send subscription message to websocket
    _channel?.sink.add(message);
  }

  // void _unSubscribeToStatus() {
  //   // check if we are not already disposed
  //   if (_isDisposed || !_isSubscribed) return;
  //
  //   final message = jsonEncode({
  //     "type": "unsubscribe",
  //     "channels": [
  //       {"name": "status"}
  //     ],
  //   });
  //
  //   // Subscribe to status
  //   _isSubscribed = false;
  //   // Send subscription message to websocket
  //   _channel?.sink.add(message);
  // }

  // void _listen() {
  //   if (_isDisposed) return;
  //
  //   _channel?.stream.listen(
  //         (data) {
  //       final jsonData = jsonDecode(data) as Map<String, dynamic>;
  //       debugPrint('CoinbaseStatusRepository: $jsonData');
  //       _streamController.add(jsonData);
  //     },
  //     onError: (e) {
  //       _reconnect();
  //     },
  //   );
  // }

  // void _reconnect() {
  //   if (_isDisposed) return;
  //
  //   Future.delayed(const Duration(seconds: 3), () {
  //     _init();
  //   });
  // }

  // void dispose() {
  //   _isDisposed = true;
  //   _channel?.sink.close();
  //   _streamController.close();
  // }
}