import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreens extends StatelessWidget {
  final String pathPDF;

  PDFScreens(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: SfPdfViewer.asset(
          initialZoomLevel: 1, enableDoubleTapZooming: true, pathPDF),
    );
  }
}
