import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class ViewPdfScreen extends StatefulWidget {

  const ViewPdfScreen({super.key});

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  bool _isLoading = true;
  late PDFDocument _document;

  @override
  void initState() {
    super.initState();
    loadDocument();
    //pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openData(: ""));
  }

  loadDocument() async {
    _document = await PDFDocument.fromURL('https://firebasestorage.googleapis.com/v0/b/chatapp-a7219.appspot.com/o/documents%2F1718098221717207?alt=media&token=d335d569-4d89-4bf2-b0e4-18538bc999cb');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : PDFViewer(document: _document, scrollDirection: Axis.vertical,),
      ),
    );
  }
}
