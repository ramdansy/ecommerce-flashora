import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_constant.dart';
import '../../../core/common/common_color.dart';
import '../../../core/common/common_icon.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../cubit/profile/profile_cubit.dart';
import 'widgets/personal_info_placeholder.dart';
import 'widgets/single_personal_info_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.white,
      appBar: AppBar(
        backgroundColor: CommonColor.white,
        title: Text(
          'Personal Info',
          style: CommonText.fHeading2,
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppConstant.paddingNormal),
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 56,
                            backgroundColor: CommonColor.whiteBG,
                            foregroundImage: state.user.imageUrl.isNotEmpty
                                ? NetworkImage(state.user.imageUrl)
                                : null,
                            child: state.user.imageUrl.isEmpty
                                ? Text(state.user.name[0].toUpperCase(),
                                    style: CommonText.fHeading2)
                                : null,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: CommonButtonOutlined(
                                  onPressed: () => context
                                      .read<ProfileCubit>()
                                      .changeProfileImage(),
                                  text: 'Edit Photo')),
                        ],
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),
                      Text(state.user.name.toUpperCase(),
                          style: CommonText.fHeading4,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: AppConstant.paddingExtraLarge),
                      SinglePersonalInfoWidget(
                        icon: CommonIcon.username,
                        label: 'Username',
                        value: state.user.username,
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),
                      SinglePersonalInfoWidget(
                        icon: CommonIcon.email,
                        label: 'Email',
                        value: state.user.email,
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),
                      SinglePersonalInfoWidget(
                        icon: CommonIcon.phone,
                        label: 'Phone Number',
                        value: state.user.phone,
                      ),
                      const SizedBox(height: AppConstant.paddingNormal),
                      SinglePersonalInfoWidget(
                        icon: CommonIcon.address,
                        label: 'Address',
                        value: state.user.address,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(AppConstant.paddingNormal),
                  child: CommonButtonFilled(
                    text: 'Logout',
                    onPressed: () => context.read<ProfileCubit>().onLogout(),
                    color: CommonColor.errorColor,
                    isLoading: state.isLogout,
                  ),
                ),
              ],
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load user data',
                      style: CommonText.fBodyLarge),
                  const SizedBox(height: AppConstant.paddingNormal),
                  CommonButtonFilled(
                      onPressed: () => context.read<ProfileCubit>().loadUser(),
                      text: 'Retry'),
                ],
              ),
            );
          }

          return const PersonalInfoPlaceholder();
        },
      ),
    );
  }
}
