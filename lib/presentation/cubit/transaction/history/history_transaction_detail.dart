import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/common/widgets/common_line.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../widget/single_label_value_widget.dart';

class HistoryTransactionDetail extends StatefulWidget {
  final PaymentModel payment;
  const HistoryTransactionDetail({super.key, required this.payment});

  @override
  State<HistoryTransactionDetail> createState() =>
      _HistoryTransactionDetailState();
}

class _HistoryTransactionDetailState extends State<HistoryTransactionDetail>
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstant.paddingNormal),
        children: [
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
          SingleLabelValueWidget(
            title: 'Status',
            valueWidget: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstant.paddingExtraSmall,
                  horizontal: AppConstant.paddingNormal),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstant.radiusExtraLarge),
                  color: CommonColor.successColor.withOpacity(.1)),
              child: Text('Success',
                  style: CommonText.fBodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CommonColor.successColor)),
            ),
          ),
          SingleLabelValueWidget(
              title: 'Payment Method',
              value: widget.payment.paymentMethod ?? ''),
          SingleLabelValueWidget(
              title: 'Transaction ID',
              value: widget.payment.transactionId ?? ''),
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
                      color: CommonColor.whiteBG,
                    ),
                    clipBehavior: Clip.hardEdge,
                    constraints:
                        const BoxConstraints(maxHeight: 100, maxWidth: 80),
                    child: AspectRatio(
                      aspectRatio: 1 / 1.25,
                      child: Image.network(item.product.image.first,
                          fit: BoxFit.contain),
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppConstant.paddingNormal),
        child: Row(
          children: [
            Expanded(
                child: CommonButtonOutlined(
              onPressed: () {},
              text: 'Share',
              iconLeft:
                  const Icon(Icons.share_outlined, color: CommonColor.primary),
            )),
            const SizedBox(width: AppConstant.paddingNormal),
            Expanded(
                child: CommonButtonFilled(
              onPressed: () {},
              text: 'Print',
              iconLeft:
                  const Icon(Icons.print_outlined, color: CommonColor.white),
            )),
          ],
        ),
      ),
    );
  }
}
