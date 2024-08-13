import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/enum/common_status_transaction.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/utils/pdf_generator.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/common/widgets/common_line.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/item_status_transaction_widget.dart';
import '../../../widget/single_label_value_widget.dart';

class HistoryTransactionDetailScreen extends StatefulWidget {
  final PaymentModel payment;
  const HistoryTransactionDetailScreen({super.key, required this.payment});

  @override
  State<HistoryTransactionDetailScreen> createState() =>
      _HistoryTransactionDetailState();
}

class _HistoryTransactionDetailState
    extends State<HistoryTransactionDetailScreen>
    with TickerProviderStateMixin {
  late double subtotal;
  late double totalPayment;
  double serviceCharge = 5 / 100;
  double tax = 5 / 100;
  double discount = 5 / 100;

  @override
  void initState() {
    super.initState();
    subtotal = widget.payment.listProducts
        .map((e) => e.product.price * e.quantity)
        .reduce((value, element) => value + element);
    serviceCharge = serviceCharge * subtotal;
    tax = tax * subtotal;
    discount = discount * subtotal;
    totalPayment = (subtotal + serviceCharge + tax) - discount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CommonColor.white,
        title: Text('Transaction Detail', style: CommonText.fHeading4),
        scrolledUnderElevation: 0.0,
        leading: IconButton(
            onPressed: () => router.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstant.paddingNormal),
        children: [
          if (widget.payment.status == CommonStatusTransaction.success) ...[
            Lottie.asset(
              'assets/images/anim_success.json',
              repeat: false,
              width: 150,
              height: 150,
              onLoaded: (composition) {},
            ),
            const SizedBox(height: AppConstant.paddingLarge),
            const Line(),
            const SizedBox(height: AppConstant.paddingNormal),
          ],
          SingleLabelValueWidget(
            title: 'Status',
            valueWidget: ItemStatusTransactionWidget(
                status:
                    widget.payment.status ?? CommonStatusTransaction.failed),
          ),
          SingleLabelValueWidget(
              title: 'Payment Method',
              value: widget.payment.paymentMethod ?? ''),
          SingleLabelValueWidget(
              title: 'Transaction ID',
              value: widget.payment.transactionId ?? ''),
          SingleLabelValueWidget(
              title: 'Transaction Date',
              value:
                  DateFormat('d MMM yyyy').format(widget.payment.createdAt!)),
          const SizedBox(height: AppConstant.paddingNormal),
          const Line(),
          const SizedBox(height: AppConstant.paddingNormal),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.payment.listProducts.length,
            itemBuilder: (context, index) {
              final item = widget.payment.listProducts[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstant.radiusLarge),
                        color: CommonColor.whiteBG),
                    clipBehavior: Clip.hardEdge,
                    constraints:
                        const BoxConstraints(maxHeight: 100, maxWidth: 80),
                    child: AspectRatio(
                      aspectRatio: 1 / 1.25,
                      child: Image.network(item.product.image.first,
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CommonText.fBodyLarge
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConstant.paddingSmall),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "${item.quantity} x ${CurrencyHelper.formatCurrencyDouble(item.product.price)}",
                              style: CommonText.fBodyLarge,
                            )),
                            const SizedBox(width: AppConstant.paddingSmall),
                            Text(
                              CurrencyHelper.formatCurrencyDouble(
                                  item.product.price * item.quantity),
                              style: CommonText.fBodyLarge
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: AppConstant.paddingNormal,
            ),
          ),
          const SizedBox(height: AppConstant.paddingNormal),
          const Line(),
          const SizedBox(height: AppConstant.paddingNormal),
          SingleLabelValueWidget(
              title: 'Subtotal',
              value: CurrencyHelper.formatCurrencyDouble(subtotal)),
          SingleLabelValueWidget(
              title: 'Service Charge (5%)',
              value: CurrencyHelper.formatCurrencyDouble(serviceCharge)),
          SingleLabelValueWidget(
              title: 'Tax (5%)',
              value: CurrencyHelper.formatCurrencyDouble(tax)),
          SingleLabelValueWidget(
              title: 'Discount (5%)',
              value: CurrencyHelper.formatCurrencyDouble(discount)),
          SingleLabelValueWidget(
              title: 'Total Payment',
              value: CurrencyHelper.formatCurrencyDouble(totalPayment)),
          const SizedBox(height: AppConstant.paddingNormal),
          const Line(),
          const SizedBox(height: AppConstant.paddingNormal),
          if (widget.payment.status == CommonStatusTransaction.success) ...[
            CommonButtonOutlined(
              onPressed: () => generatePdf(widget.payment),
              text: 'Download Invoice',
              iconLeft:
                  const Icon(Icons.print_outlined, color: CommonColor.primary),
            ),
            const SizedBox(height: AppConstant.paddingNormal),
          ],
        ],
      ),
    );
  }
}
