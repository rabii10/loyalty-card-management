import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:e_commerce/model/fidelity_card.dart';

class FidelityCardWidget extends StatelessWidget {
  final FidelityCard card;
  final GlobalKey globalKey;

  FidelityCardWidget({required this.card, required this.globalKey});

  @override
  Widget build(BuildContext context) {
    String locationData = '36.8065,10.1815';
    return Center(
      child: RepaintBoundary(
        key: globalKey,
        child: Container(
          width: 300,
          height: 200,
          color: Color(0xFF0033A1),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Text(card.clientName,
                    style: TextStyle(
                        color: Colors.black, fontSize: 20)),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: Text(
                    'Points: ${card.loyaltyPoints}',
                    style: TextStyle(
                        color: Colors.black, fontSize: 20)),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: QrImageView(
                  data: locationData,
                  version: QrVersions.auto,
                  size: 80.0,
                ),
              ),
              Positioned(
                bottom: 10,
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: locationData,
                  width: 280,
                  height: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
