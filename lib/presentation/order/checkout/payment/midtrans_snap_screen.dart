import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/domain/enum/order_status.dart';
import 'package:sewiee/presentation/order/order_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransSnapScreen extends StatefulWidget {

  final String orderId;
  final String snapToken;

  const MidtransSnapScreen({
    super.key,
    required this.orderId,
    required this.snapToken,
  });

  @override
  State<MidtransSnapScreen> createState() =>
      _MidtransSnapScreenState();
}

class _MidtransSnapScreenState
    extends State<MidtransSnapScreen> {

  late final WebViewController controller;
  late final OrderViewmodel vm;

  @override
  void initState() {
    super.initState();

    vm = context.read<OrderViewmodel>();

    controller = WebViewController()

    // =========================
    // ENABLE JS
    // =========================

      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )

    // =========================
    // CALLBACK FROM JS
    // =========================

      ..addJavaScriptChannel(
        'Midtrans',
        onMessageReceived: (message) async {

          debugPrint(
            'MIDTRANS CALLBACK : ${message.message}',
          );

          final data =
          jsonDecode(message.message);

          final status =
          data['transaction_status'];

          // =========================
          // SUCCESS
          // =========================

          if (
          status == 'settlement' ||
              status == 'capture'
          ) {

            await vm.updateOrderStatus(
              orderId: widget.orderId,
              newStatus: OrderStatus.completed,
            );

            if(mounted){
              Navigator.pop(context, true);
            }
          }

          // =========================
          // PENDING
          // =========================

          else if (
          status == 'pending'
          ) {

            if(mounted){
              Navigator.pop(context, false);
            }
          }
        },
      )

    // =========================
    // LOAD HTML
    // =========================

      ..loadHtmlString(
        _html(widget.snapToken),
      );
  }

  String _html(String snapToken) {
    return '''
    <!DOCTYPE html>
    <html>

    <head>

      <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
      >

      <script
        type="text/javascript"
        src="https://app.sandbox.midtrans.com/snap/snap.js"
        data-client-key="YOUR_CLIENT_KEY"
      ></script>

    </head>

    <body>

      <script type="text/javascript">

        window.onload = function () {

          snap.pay('$snapToken', {

            onSuccess: function(result) {

              Midtrans.postMessage(
                JSON.stringify(result)
              );
            },

            onPending: function(result) {

              Midtrans.postMessage(
                JSON.stringify(result)
              );
            },

            onError: function(result) {

              Midtrans.postMessage(
                JSON.stringify(result)
              );
            },

            onClose: function() {

              Midtrans.postMessage(
                JSON.stringify({
                  transaction_status: 'close'
                })
              );
            }
          });
        };

      </script>

    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Pembayaran Denda',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),

      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}