import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_websocket/api/coinbase_websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// 이제 실제로 UI에서 이를 활용할 수 있습니다.
// 실제로 이제 이 특정 스크림을 듣기 시작할 수 있습니다.
final coinbaseStatusRepositoryProvider = AutoDisposeStreamProvider<Map<String, dynamic>>((ref) {
  final coinbaseWebsocket = ref.watch(coinbaseWebsocketProvider);
  final coinbaseStatusRepository = CoinbaseStatusRepository(coinbaseWebsocket);

  // ref.onDispose(() {
  //   coinbaseStatusRepository._unSubscribeToStatus();
  //   coinbaseStatusRepository.dispose();
  //   ref.invalidate(coinbaseWebsocketProvider);
  //
  //   debugPrint('CoinbaseStatusRepository disposed');
  // });
  // ref.onCancel(() {
  //   debugPrint('CoinbaseStatusRepository cancelled');
  // });
  // ref.onResume(() {
  //   debugPrint('CoinbaseStatusRepository resumed');
  // });
  // ref.onAddListener(() {
  //   debugPrint('CoinbaseStatusRepository added');
  // });
  // ref.onRemoveListener(() {
  //   debugPrint('CoinbaseStatusRepository removed');
  // });

  // 따라서 실제로 여기에서 반환 유형을 반환해야 합니다. 스트림이어야 합니다.
  // 그럼 여기서 우리가 할 일은 여기서 스크림을 반환하는 것입니다.
  return coinbaseStatusRepository.stream;
});

class CoinbaseStatusRepository {
  final CoinbaseWebsocket _coinbaseWebsocket;

  CoinbaseStatusRepository(this._coinbaseWebsocket) {
    _init();
  }

  WebSocketChannel? _channel;
  bool _isDisposed = false;
  bool _isSubscribed = false;

  final StreamController<Map<String, dynamic>> _streamController = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void _init() {
    // 따라서 일단 연결하면 해당 상태의 이 특정 채널을 구독하게 됩니다.
    _channel = _coinbaseWebsocket.connect();
    _subscribeToStatus();
    _listen();
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

  void _listen() {
    if (_isDisposed) return;

    // null이 아닌 경우 여기에서 얻는 스트림과 내가 수신해야 하는 스트림에서
    // 우리가 받는 데이터. 그래서 이것은 우리가 서버로부터 받는 데이터가 될 것입니다.
    _channel?.stream.listen((data) {
      final jsonData = jsonDecode(data) as Map<String, dynamic>;
      debugPrint('CoinbaseStatusRepository: $jsonData');
      _streamController.add(jsonData);
    }, onError: (e) {
      // _reconnect();
    });
  }

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
