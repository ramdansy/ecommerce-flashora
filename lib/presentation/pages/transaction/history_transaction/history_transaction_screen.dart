import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_constant.dart';
import '../../../../core/common/common_color.dart';
import '../../../../core/common/common_icon.dart';
import '../../../../core/common/common_shimmer.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/widgets/common_text_input.dart';
import '../../../cubit/transaction/history/history_transaction_cubit.dart';
import '../../../widgets/empty_widget.dart';
import 'widgets/single_history_transaction_widget.dart';

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
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: CommonColor.white,
        title: Text('History Transaction', style: CommonText.fHeading2),
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstant.paddingNormal,
                vertical: AppConstant.paddingSmall),
            child: Row(
              children: [
                Expanded(
                  child: CommonTextInput(
                    textEditingController: context
                        .read<HistoryTransactionCubit>()
                        .searchController,
                    focusNode: FocusNode(),
                    hintText: 'Search Transaction ...',
                    textInputAction: TextInputAction.done,
                    obsecureText: false,
                    maxLines: 1,
                    onFieldSubmit: (value) {},
                    onChanged: (value) {
                      context
                          .read<HistoryTransactionCubit>()
                          .searchProducts(value);
                    },
                    textInputType: TextInputType.text,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                ),
                const SizedBox(width: AppConstant.paddingMedium),
                InkWell(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  borderRadius: BorderRadius.circular(AppConstant.radiusNormal),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstant.paddingMedium,
                        vertical: AppConstant.paddingMedium),
                    decoration: BoxDecoration(
                      // color: CommonColor.primary.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstant.radiusNormal),
                      border: Border.all(color: CommonColor.primary),
                    ),
                    child: Row(children: [
                      CommonIcon.filter,
                      const SizedBox(width: AppConstant.paddingSmall),
                      Text('Filter', style: CommonText.fBodyLarge)
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                BlocBuilder<HistoryTransactionCubit, HistoryTransactionState>(
              builder: (context, state) {
                if (state is HistoryLoaded) {
                  return ListView.builder(
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
        ],
      ),
    );
  }
}
