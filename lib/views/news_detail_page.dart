import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailWebView extends StatefulWidget {
  final String url;

  NewsDetailWebView({required this.url});

  @override
  _NewsDetailWebViewState createState() => _NewsDetailWebViewState();
}

class _NewsDetailWebViewState extends State<NewsDetailWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // WebViewController'ı yapılandırıyoruz
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript'i etkinleştir
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Sayfa Yükleniyor: $url');
          },
          onPageFinished: (String url) {
            print('Sayfa Yüklendi: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Hata: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Başlangıçta yüklenen URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haber Detayı'),
      ),
      body: WebViewWidget(controller: _controller), // WebViewWidget kullanıyoruz
    );
  }
}
