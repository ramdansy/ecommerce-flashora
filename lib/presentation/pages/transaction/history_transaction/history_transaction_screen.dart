import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_shimmer.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/utils/currency_helper.dart';
import '../../../../domain/entities/payment_model.dart';
import '../../../cubit/transaction/history/history_transaction_cubit.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/item_status_transaction_widget.dart';
import '../../../widgets/empty_widget.dart';

class HistoryTransactionScreen extends StatefulWidget {
  const HistoryTransactionScreen({super.key});

  @override
  State<HistoryTransactionScreen> createState() =>
      _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryTransactionCubit>().getHistoryTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: CommonColor.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: CommonColor.white,
          title: Text('History Transaction', style: CommonText.fHeading2),
          scrolledUnderElevation: 0.0,
          bottom: TabBar(
            indicatorColor: CommonColor.primary,
            labelStyle: CommonText.fBodyLarge.copyWith(
                fontWeight: FontWeight.bold, color: CommonColor.primary),
            unselectedLabelStyle:
                CommonText.fBodyLarge.copyWith(color: CommonColor.textGrey),
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (index) =>
                context.read<HistoryTransactionCubit>().filterList(index),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Success'),
              Tab(text: 'Pending'),
              Tab(text: 'Failed'),
            ],
          ),
        ),
        body: BlocBuilder<HistoryTransactionCubit, HistoryTransactionState>(
          builder: (context, state) {
            if (state is HistoryLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(AppConstant.paddingNormal),
                itemCount: state.historyTransaction.isNotEmpty
                    ? state.historyTransaction.length
                    : 1,
                itemBuilder: (context, index) {
                  if (state.historyTransaction.isEmpty) {
                    return const EmptyWidget(
                      message: 'No Transaction Found',
                      margin: EdgeInsets.zero,
                    );
                  }

                  final item = state.historyTransaction[index];
                  return SingleHistoryTransactionWidget(item: item);
                },
              );
            }

            return ListView.separated(
              itemCount: 10,
              padding: const EdgeInsets.all(AppConstant.paddingNormal),
              itemBuilder: (context, index) {
                return CommonShimmer(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppConstant.paddingSmall),
            );
          },
        ),
      ),
    );
  }
}

class SingleHistoryTransactionWidget extends StatelessWidget {
  const SingleHistoryTransactionWidget({
    super.key,
    required this.item,
  });

  final PaymentModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.pushNamed(RoutesName.historyTransactionDetail, extra: item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstant.radiusExtraLarge),
          color: CommonColor.white,
          border: Border.all(color: CommonColor.borderColorDisable),
        ),
        margin: const EdgeInsets.only(bottom: AppConstant.paddingNormal),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstant.paddingMedium),
              child: Row(
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
                      child: Image.network(
                          item.listProducts.first.product.image.first,
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: AppConstant.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.listProducts.first.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CommonText.fBodyLarge
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(item.listProducts.first.product.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CommonText.fBodySmall
                                .copyWith(color: CommonColor.textGrey)),
                        const SizedBox(height: AppConstant.paddingSmall),
                        Text(
                          CurrencyHelper.formatCurrencyDouble(
                              item.listProducts.first.product.price),
                          style: CommonText.fHeading5
                              .copyWith(color: CommonColor.primary),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (item.listProducts.length > 1)
              Padding(
                padding: const EdgeInsets.all(AppConstant.paddingSmall),
                child: Text(
                  '+${item.listProducts.length - 1} Products',
                  style: CommonText.fBodyLarge
                      .copyWith(color: CommonColor.textGrey),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(AppConstant.paddingMedium),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: CommonColor.borderColorDisable)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${item.transactionId} - ${DateFormat.yMMMd().format(item.createdAt!)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CommonText.fBodySmall
                          .copyWith(color: CommonColor.textGrey)),
                  ItemStatusTransactionWidget(status: item.status!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
