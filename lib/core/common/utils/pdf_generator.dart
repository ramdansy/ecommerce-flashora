import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../domain/entities/payment_model.dart';

Future<void> generatePdf(PaymentModel item) async {
  final doc = pw.Document();
  final Uint8List fontData =
      File('assets/fonts/open-sans.ttf').readAsBytesSync();
  final font = pw.Font.ttf(fontData.buffer.asByteData());

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (context) {
        return pw.Column(
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('Invoice',
                  style: pw.TextStyle(font: font, fontSize: 20)),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Product', style: pw.TextStyle(font: font)),
                    pw.Text('Quantity', style: pw.TextStyle(font: font)),
                    pw.Text('Price', style: pw.TextStyle(font: font)),
                    pw.Text('Total', style: pw.TextStyle(font: font)),
                  ],
                ),
                for (var i = 0; i < item.listProducts.length; i++)
                  pw.TableRow(
                    children: [
                      pw.Text(item.listProducts[i].product.title,
                          style: pw.TextStyle(font: font)),
                      pw.Text(item.listProducts[i].quantity.toString(),
                          style: pw.TextStyle(font: font)),
                      pw.Text(item.listProducts[i].product.price.toString(),
                          style: pw.TextStyle(font: font)),
                      pw.Text(
                          (item.listProducts[i].quantity *
                                  item.listProducts[i].product.price)
                              .toString(),
                          style: pw.TextStyle(font: font)),
                    ],
                  ),
              ],
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('Thank you for shopping with us',
                  style: pw.TextStyle(font: font)),
            ),
          ],
        );
      },
    ),
  );

  final bytes = await doc.save();
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/my_document.pdf');
  await file.writeAsBytes(bytes);
}
