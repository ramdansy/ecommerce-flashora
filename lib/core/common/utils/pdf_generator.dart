import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../domain/entities/payment_model.dart';
import '../../app_constant.dart';
import 'currency_helper.dart';

Future<void> generatePdf(PaymentModel item) async {
  final Directory? directory;
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      margin: const pw.EdgeInsets.all(AppConstant.paddingLarge),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text(item.transactionId.toString(),
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.green)),
            pw.SizedBox(height: AppConstant.paddingNormal),
            pw.Text('DITERBITKAN UNTUK',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: AppConstant.paddingExtraSmall),
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(2),
                1: const pw.FixedColumnWidth(.1),
                2: const pw.FixedColumnWidth(4),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Pembeli', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(':', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(item.user.name,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                const pw.TableRow(children: []),
                pw.TableRow(
                  children: [
                    pw.Text('Tanggal Pembelian',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(':', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(DateFormat('d MMMM yyyy').format(item.createdAt!),
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Alamat Pengiriman',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(':', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(item.user.address,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Metode Pembayaran',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(':', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(item.paymentMethod.toString(),
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: AppConstant.paddingNormal),
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(6),
                1: const pw.FixedColumnWidth(2),
                2: const pw.FixedColumnWidth(2),
                3: const pw.FixedColumnWidth(2),
              },
              defaultColumnWidth: const pw.IntrinsicColumnWidth(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border.symmetric(
                      horizontal: pw.BorderSide(color: PdfColors.grey),
                    ),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Text('Product',
                          style: const pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Text('Quantity',
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Text('Price',
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Text('Total',
                          style: const pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                for (var i = 0; i < item.listProducts.length; i++)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8),
                        child: pw.Text(item.listProducts[i].product.title,
                            style: const pw.TextStyle(fontSize: 10)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8),
                        child: pw.Text(item.listProducts[i].quantity.toString(),
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8),
                        child: pw.Text(
                            CurrencyHelper.formatCurrencyDouble(
                                item.listProducts[i].product.price),
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.end),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8),
                        child: pw.Text(
                            CurrencyHelper.formatCurrencyDouble(
                                item.listProducts[i].quantity *
                                    item.listProducts[i].product.price),
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.end),
                      ),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: AppConstant.paddingNormal),
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(6),
                1: const pw.FixedColumnWidth(4),
                2: const pw.FixedColumnWidth(2),
              },
              defaultColumnWidth: const pw.IntrinsicColumnWidth(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Text(
                          'TOTAL HARGA \n(${item.listProducts.length} Products)',
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8),
                      child: pw.Text(
                          CurrencyHelper.formatCurrencyDouble(item.totalPrice),
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.end),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    directory = await getDownloadsDirectory();
  }

  if (directory == null) {
    debugPrint('Document directory not available');
    return;
  }

  Uint8List bytes = await doc.save();
  String dir = directory.path;
  final file = File('$dir/INVOICE-${item.transactionId}.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
