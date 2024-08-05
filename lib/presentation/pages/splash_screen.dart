import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../cubit/splashscreen/splash_screen_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SplashScreenCubit, SplashScreenState>(
        builder: (context, state) {
          return Center(
            child: Lottie.asset(
              'assets/images/logo.json',
              repeat: false,
              width: 250,
              height: 250,
              onLoaded: (composition) => context
                  .read<SplashScreenCubit>()
                  .compositionLoaded(
                      composition, AnimationController(vsync: this)),
            ),
          );
        },
      ),
    );
  }
}
