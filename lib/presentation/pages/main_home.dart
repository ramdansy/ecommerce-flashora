import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_constant.dart';
import '../../core/common/common_color.dart';
import '../../core/common/common_icon.dart';
import '../cubit/bottom_nav/bottom_nav_cubit.dart';
import 'cart/cart_screen.dart';
import 'product/product_screen.dart';
import 'profile/profile_screen.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          switch (state.index) {
            case 0:
              return const ProductScreen();
            case 1:
              return const CartScreen();
            case 2:
              return const ProfileScreen();
            default:
              return const ProductScreen();
          }
        },
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.symmetric(vertical: AppConstant.paddingExtraSmall),
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: CommonColor.textGrey, width: .2)),
          color: CommonColor.white,
        ),
        child: BottomNavigationBar(
          currentIndex: context.watch<BottomNavCubit>().state.index,
          onTap: (value) {
            context.read<BottomNavCubit>().navigateTo(index: value);
          },
          backgroundColor: CommonColor.white,
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedItemColor: CommonColor.textGrey,
          selectedItemColor: CommonColor.primary,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          elevation: 0.0,
          items: [
            BottomNavigationBarItem(
              icon: CommonIcon.productDefault,
              activeIcon: CommonIcon.productActive,
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: CommonIcon.cartDefault,
              activeIcon: CommonIcon.cartActive,
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: CommonIcon.profileDefault,
              activeIcon: CommonIcon.profileActive,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
