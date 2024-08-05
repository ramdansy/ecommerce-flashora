import 'package:finalproject_flashora/core/app_constant.dart';
import 'package:finalproject_flashora/core/common/common_color.dart';
import 'package:finalproject_flashora/core/common/common_text.dart';
import 'package:finalproject_flashora/core/common/utils/currency_helper.dart';
import 'package:finalproject_flashora/core/common/widgets/common_line.dart';
import 'package:finalproject_flashora/domain/entities/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
          singleTransactionItemWidget(
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
          singleTransactionItemWidget(
              title: 'Payment Method',
              value: widget.payment.paymentMethod ?? ''),
          singleTransactionItemWidget(
              title: 'Transaction ID',
              value: widget.payment.transactionId ?? ''),
          const SizedBox(height: AppConstant.paddingNormal),
          const Line(),
          const SizedBox(height: AppConstant.paddingNormal),
          const Line(),
          const SizedBox(height: AppConstant.paddingNormal),
          singleTransactionItemWidget(
              title: 'Subtotal',
              value: CurrencyHelper.formatCurrencyDouble(subtotal)),
          singleTransactionItemWidget(
              title: 'Service Charge (5%)',
              value: CurrencyHelper.formatCurrencyDouble(serviceCharge)),
          singleTransactionItemWidget(
              title: 'Tax (5%)',
              value: CurrencyHelper.formatCurrencyDouble(tax)),
          singleTransactionItemWidget(
              title: 'Discount (5%)',
              value: CurrencyHelper.formatCurrencyDouble(discount)),
          const SizedBox(height: AppConstant.paddingNormal),
          const Line(),
          const SizedBox(height: AppConstant.paddingNormal),
          singleTransactionItemWidget(
              title: 'Total',
              value: CurrencyHelper.formatCurrencyDouble(totalPayment)),
        ],
      ),
    );
  }

  Widget singleTransactionItemWidget(
      {required String title, String? value, Widget? valueWidget}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstant.paddingSmall),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: CommonText.fBodyLarge),
          ),
          const SizedBox(width: AppConstant.paddingSmall),
          valueWidget ?? Text(value ?? "", style: CommonText.fHeading5),
        ],
      ),
    );
  }
}
