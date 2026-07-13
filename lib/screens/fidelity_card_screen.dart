import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/model/fidelity_card.dart';
import 'package:e_commerce/provider/fidelity_card_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Vendeur/CRUDE/card_widget.dart';

class FidelityCardScreen extends StatelessWidget {
  final pw.Document pdf = pw.Document();
  final GlobalKey _globalKey = GlobalKey();

  Future<Uint8List> generatePdf(FidelityCard card) async {
    // Perform the asynchronous operation before building the page
    Uint8List imageBytes = await _captureFidelityCard();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(card.clientName, style: pw.TextStyle(fontSize: 40)),
              pw.Image(pw.MemoryImage(imageBytes)), // Use the captured image bytes
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _captureFidelityCard() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FidelityCard'),
      ),
      body: FutureBuilder<FidelityCard>(
        future: Provider.of<FidelityCardProvider>(context, listen: false)
            .getFidelityCardForUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            FidelityCard? card = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FidelityCardWidget(card: card!, globalKey: _globalKey),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Uint8List pdfBytes = await generatePdf(card);
                      await sharePdf(pdfBytes);
                    },
                    child: Text('Save as PDF'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple, // foreground
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> sharePdf(Uint8List pdfBytes) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: 'fidelity_card.pdf');
  }
}
