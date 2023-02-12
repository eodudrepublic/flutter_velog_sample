import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_velog_sample/_core/app_bar.dart';
import 'package:flutter_velog_sample/_core/app_theme.dart';

class LibraryDaumPostcodeWebview extends StatelessWidget {
  const LibraryDaumPostcodeWebview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.backgroundColor,
      appBar: appBar(title: "Daum 주소 검색"),
      body: DaumPostcodeSearch(
        webPageTitle: "주소 검색",
        initialOption: InAppWebViewGroupOptions(),
        onConsoleMessage: ((controller, consoleMessage) {}),
        onLoadError: ((controller, url, code, message) {}),
        onLoadHttpError: (controller, url, statusCode, description) {},
        onProgressChanged: (controller, progress) {},
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
      ),
    );
  }
}
