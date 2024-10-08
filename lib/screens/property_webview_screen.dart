//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PropertyWebViewScreenContainer extends StatefulWidget {
  final String url;
  const PropertyWebViewScreenContainer(this.url, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PropertyWebViewScreenContainerState createState() =>
      _PropertyWebViewScreenContainerState();
}

class _PropertyWebViewScreenContainerState
    extends State<PropertyWebViewScreenContainer> {
  //var _url;
  //final _key = UniqueKey();
  late final WebViewController controller;
  //..setJavascriptMode(JavaScriptMode.disabled);

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      // AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset('assets/images/Appbar_logo.png',
      //           fit: BoxFit.cover, height: 56),
      //     ],
      //   ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                controller: controller,
              ),
            )
          ],
        ),
      ),
    );
  }
}
