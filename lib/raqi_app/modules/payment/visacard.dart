import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';

class VisaCardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('https://accept.paymob.com/api/acceptance/iframes/683608?payment_token=$PaymobFinalToken')),
        initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
                mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW
            )
        ),
      ),
    );
  }
}
