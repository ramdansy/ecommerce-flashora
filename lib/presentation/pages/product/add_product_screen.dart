import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/enum/common_form_validate_type.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../../core/common/widgets/common_snacbar.dart';
import '../../../core/common/widgets/common_text_input.dart';
import '../../../domain/entities/product_model.dart';
import '../../cubit/product_cubit/crud_product/crud_product_cubit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController(text: 0.toString());
  final stockController = TextEditingController(text: 0.toString());

  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final stockFocusNode = FocusNode();

  final List<String> listCategories = [
    'Shirt',
    'Shoes',
    'Accessories',
    'Pants',
    'Dress',
    'Jacket',
    'Hoodie'
  ];

  String? selectedCategory;
  File? productImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CommonColor.white,
        title: Text('Add Product', style: CommonText.fHeading4),
        scrolledUnderElevation: 0.0,
      ),
      body: BlocConsumer<CrudProductCubit, CrudProductState>(
        listener: (context, state) {
          if (state is AddProductError) {
            CommonSnacbar.showErrorSnackbar(
                context: context, message: state.message);
          }
          if (state is AddedProduct) {
            CommonSnacbar.showSuccessSnackbar(
                context: context, message: 'Success Add Product');
            context.pop();
          }
        },
        builder: (context, state) {
          return formAddProducts(state);
        },
      ),
    );
  }

  Widget formAddProducts(CrudProductState state) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppConstant.paddingNormal),
        children: [
          CommonTextInput(
            textEditingController: nameController,
            focusNode: nameFocusNode,
            label: 'Product Name',
            hintText: 'Input Product Name',
            textInputAction: TextInputAction.next,
            obsecureText: false,
            maxLines: 1,
            onFieldSubmit: (value) {},
            textInputType: TextInputType.text,
            validators: const [CommonFormValidateType.noEmpty],
          ),
          const SizedBox(height: AppConstant.paddingNormal),
          CommonTextInput(
            textEditingController: descriptionController,
            focusNode: descriptionFocusNode,
            label: 'Product Description',
            hintText: 'Input Product Description',
            textInputAction: TextInputAction.next,
            obsecureText: false,
            onFieldSubmit: (value) {},
            textInputType: TextInputType.text,
            validators: const [CommonFormValidateType.noEmpty],
          ),
          const SizedBox(height: AppConstant.paddingNormal),
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
                                  vertical: AppConstant.paddingSmall),
                              width: MediaQuery.of(context).size.width / 3,
                              child: const Divider(
                                  color: CommonColor.borderColorDisable,
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
                                  setState(() => selectedCategory = e);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: selectedCategory ?? 'Select Category',
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.normal,
                  iconRight: const Icon(Icons.arrow_drop_down),
                ),
              )
            ],
          ),
          const SizedBox(height: AppConstant.paddingNormal),
          CommonTextInput(
            textEditingController: priceController,
            focusNode: priceFocusNode,
            label: 'Price',
            hintText: '0',
            textAlign: TextAlign.end,
            maxLines: 1,
            prefix: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstant.paddingNormal),
                child: Text('Rp.', style: CommonText.fHeading5)),
            textInputAction: TextInputAction.next,
            onFieldSubmit: (_) {},
            textInputType: TextInputType.number,
            textStyle: CommonText.fHeading5,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(
                  thousandSeparator: ThousandSeparator.Period,
                  mantissaLength: 0)
            ],
          ),
          const SizedBox(height: AppConstant.paddingNormal),
          CommonTextInput(
            textEditingController: stockController,
            focusNode: stockFocusNode,
            label: 'Stock',
            hintText: '0',
            textInputAction: TextInputAction.done,
            obsecureText: false,
            maxLines: 1,
            onFieldSubmit: (value) {},
            textInputType: TextInputType.number,
            prefixIcon: IconButton(
                onPressed: () {
                  if (int.parse(stockController.text) > 0) {
                    stockController.text =
                        (int.parse(stockController.text) - 1).toString();
                  }
                },
                icon: const Icon(Icons.remove)),
            suffixIcon: IconButton(
                onPressed: () => stockController.text =
                    (int.parse(stockController.text) + 1).toString(),
                icon: const Icon(Icons.add)),
            textAlign: TextAlign.center,
            validators: const [
              CommonFormValidateType.noEmpty,
            ],
          ),
          const SizedBox(height: AppConstant.paddingNormal),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Image',
                  style: CommonText.fBodySmall
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppConstant.paddingSmall),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1.25,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConstant.radiusLarge),
                          color: CommonColor.whiteBG,
                        ),
                        clipBehavior: Clip.hardEdge,
                        constraints:
                            const BoxConstraints(maxHeight: 100, maxWidth: 80),
                        child: productImage == null
                            ? const Icon(Icons.image_rounded)
                            : Image.file(productImage!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: AppConstant.paddingNormal),
                    CommonButtonOutlined(
                        onPressed: () => pickImage(), text: 'Select Image')
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstant.paddingNormal),
          CommonButtonFilled(
            text: 'Save Product',
            isLoading: state is AddingProduct || isLoading,
            onPressed: () async {
              if (state is AddingProduct) return;

              nameFocusNode.unfocus();
              descriptionFocusNode.unfocus();
              priceFocusNode.unfocus();
              stockFocusNode.unfocus();

              if (formKey.currentState!.validate() &&
                  productImage != null &&
                  selectedCategory != null) {
                String imageUrl =
                    await uploadImage(productImage!, nameController.text);

                final product = ProductModel(
                    id: "",
                    title: nameController.text,
                    description: descriptionController.text,
                    category: selectedCategory!,
                    price:
                        double.parse(priceController.text.replaceAll('.', '')),
                    stock: int.parse(stockController.text),
                    image: [imageUrl],
                    rating: -1,
                    ratingCount: -1);

                context.read<CrudProductCubit>().addProduct(context, product);
              }
            },
          )
        ],
      ),
    );
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    final imageTemp = File(image.path);

    setState(() => productImage = imageTemp);
  }

  Future<String> uploadImage(File file, String productName) async {
    setState(() => isLoading = !isLoading);
    FirebaseStorage storage = FirebaseStorage.instance;

    String fileName = productName.replaceAll(' ', '-');
    Reference ref = storage.ref().child('products/$fileName');

    UploadTask uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() => {});
    String downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() => isLoading = !isLoading);
    return downloadUrl;
  }
}
