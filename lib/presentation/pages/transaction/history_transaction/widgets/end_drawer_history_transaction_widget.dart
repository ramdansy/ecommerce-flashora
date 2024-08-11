import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../core/app_constant.dart';
import '../../../../../core/common/common_color.dart';
import '../../../../../core/common/common_text.dart';
import '../../../../../core/common/widgets/common_button.dart';
import '../../../../../core/common/widgets/common_text_input.dart';
import '../../../../cubit/transaction/history/history_transaction_cubit.dart';

class EndDrawerHistoryTransactionWidget extends StatefulWidget {
  const EndDrawerHistoryTransactionWidget({
    super.key,
  });

  @override
  State<EndDrawerHistoryTransactionWidget> createState() =>
      _EndDrawerHistoryTransactionWidgetState();
}

class _EndDrawerHistoryTransactionWidgetState
    extends State<EndDrawerHistoryTransactionWidget> {
  String selectedCategory = 'All';
  List<String> listCategories = [
    'All',
    'Shirt',
    'Shoes',
    'Accessories',
    'Pants',
    'Dress',
    'Jacket',
    'Hoodie'
  ];

  PickerDateRange? selectedDateRange;

  String selectedStatus = 'All';
  List<String> listStatus = [
    'All',
    'Success',
    'Pending',
    'Failed',
  ];

  final _startPriceController = TextEditingController(text: 0.toString());
  final _endriceController = TextEditingController(text: 0.toString());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        backgroundColor: CommonColor.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(AppConstant.paddingMedium),
                child: Text('Filter', style: CommonText.fHeading4),
              ),
              const SizedBox(height: AppConstant.paddingLarge),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstant.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //category
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category',
                              style: CommonText.fBodySmall
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: AppConstant.paddingSmall),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CommonButtonOutlined(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: CommonColor.white,
                                  builder: (context) {
                                    return Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  AppConstant.paddingSmall),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: const Divider(
                                              color: CommonColor
                                                  .borderColorDisable,
                                              thickness: 4),
                                        ),
                                        ListTile(
                                          title: Text('Select Category',
                                              style: CommonText.fHeading5),
                                        ),
                                        ...listCategories.map(
                                          (e) => ListTile(
                                            title: Text(
                                              e,
                                              style: CommonText.fBodyLarge,
                                            ),
                                            onTap: () {
                                              setState(
                                                  () => selectedCategory = e);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              text: selectedCategory,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.normal,
                              iconRight: const Icon(Icons.arrow_drop_down),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),

                      //date
                      Text('Date Range',
                          style: CommonText.fBodySmall
                              .copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppConstant.paddingSmall),
                      CommonButtonOutlined(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          backgroundColor: CommonColor.white,
                          builder: (context) {
                            return bottomsheetDateRangePicker(context);
                          },
                        ),
                        text: selectedDateRange != null
                            ? '${DateFormat('d MMM yyyy').format(selectedDateRange!.startDate!)} - ${DateFormat('d MMM yyyy').format(selectedDateRange!.endDate!)}'
                            : '',
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.normal,
                        iconRight: const Icon(Icons.calendar_month_outlined),
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),

                      //price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CommonTextInput(
                              textEditingController: _startPriceController,
                              focusNode: FocusNode(),
                              label: 'Min Price (Rp)',
                              hintText: 'Min Price',
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              onFieldSubmit: (_) {},
                              textInputType: TextInputType.number,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CurrencyInputFormatter(
                                    thousandSeparator: ThousandSeparator.Period,
                                    mantissaLength: 0)
                              ],
                            ),
                          ),
                          const SizedBox(width: AppConstant.paddingSmall),
                          Expanded(
                            child: CommonTextInput(
                              textEditingController: _endriceController,
                              focusNode: FocusNode(),
                              label: 'Max Price (Rp)',
                              hintText: 'Max Price',
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              onFieldSubmit: (_) {},
                              textInputType: TextInputType.number,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CurrencyInputFormatter(
                                    thousandSeparator: ThousandSeparator.Period,
                                    mantissaLength: 0)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),

                      //status
                      Text('Status',
                          style: CommonText.fBodySmall
                              .copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppConstant.paddingSmall),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CommonButtonOutlined(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: CommonColor.white,
                              builder: (context) {
                                return bottomsheetSelectCategory(context);
                              },
                            );
                          },
                          text: selectedStatus,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.normal,
                          iconRight: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppConstant.paddingMedium),
                color: CommonColor.whiteBG,
                child: Row(children: [
                  Expanded(
                      child: CommonButtonOutlined(
                          onPressed: () {
                            _startPriceController.clear();
                            _endriceController.clear();
                            selectedDateRange = null;
                            selectedCategory = 'All';
                            selectedStatus = 'All';
                            setState(() {});
                          },
                          text: 'Reset')),
                  const SizedBox(width: AppConstant.paddingMedium),
                  Expanded(
                    child: CommonButtonFilled(
                      onPressed: () {
                        context.read<HistoryTransactionCubit>().filterHistory(
                              context,
                              category: selectedCategory,
                              status: selectedStatus,
                              startDate: selectedDateRange?.startDate,
                              endDate: selectedDateRange?.endDate,
                              minPrice:
                                  int.parse(_startPriceController.text) > 0
                                      ? double.parse(_startPriceController.text
                                          .replaceAll('.', ''))
                                      : null,
                              maxPrice: int.parse(_endriceController.text) > 0
                                  ? double.parse(_endriceController.text
                                      .replaceAll('.', ''))
                                  : null,
                            );
                      },
                      text: 'Apply',
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Wrap bottomsheetDateRangePicker(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(vertical: AppConstant.paddingSmall),
          width: MediaQuery.of(context).size.width / 3,
          child: const Divider(
              color: CommonColor.borderColorDisable, thickness: 4),
        ),
        ListTile(
          title: Text('Select Date', style: CommonText.fHeading5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: AppConstant.paddingMedium),
        ),
        SfDateRangePicker(
          controller: DateRangePickerController(),
          backgroundColor: CommonColor.white,
          selectionColor: CommonColor.primary,
          rangeSelectionColor: CommonColor.primary.withOpacity(.1),
          startRangeSelectionColor: CommonColor.primary,
          endRangeSelectionColor: CommonColor.primary,
          todayHighlightColor: CommonColor.primary,
          view: DateRangePickerView.month,
          headerStyle: DateRangePickerHeaderStyle(
              backgroundColor: CommonColor.white,
              textStyle:
                  CommonText.fBodyLarge.copyWith(fontWeight: FontWeight.bold)),
          selectionMode: DateRangePickerSelectionMode.extendableRange,
          showActionButtons: true,
          cancelText: 'Cancel',
          onCancel: () => Navigator.pop(context),
          confirmText: 'Confirm',
          onSubmit: (value) {
            setState(() => selectedDateRange = value as PickerDateRange);
            Navigator.pop(context);
          },
          rangeTextStyle: CommonText.fBodyLarge,
          selectionTextStyle:
              CommonText.fBodyLarge.copyWith(color: CommonColor.white),
          monthCellStyle: DateRangePickerMonthCellStyle(
            todayTextStyle: CommonText.fBodyLarge,
            textStyle:
                CommonText.fBodyLarge.copyWith(color: CommonColor.primary),
          ),
        ),
      ],
    );
  }

  Wrap bottomsheetSelectCategory(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(vertical: AppConstant.paddingSmall),
          width: MediaQuery.of(context).size.width / 3,
          child: const Divider(
              color: CommonColor.borderColorDisable, thickness: 4),
        ),
        ListTile(
          title: Text('Select Status', style: CommonText.fHeading5),
        ),
        ...listStatus.map(
          (e) => ListTile(
            title: Text(
              e,
              style: CommonText.fBodyLarge,
            ),
            onTap: () {
              setState(() => selectedStatus = e);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
