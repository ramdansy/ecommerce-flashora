import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/app_constant.dart';
import '../../../core/app_preferences.dart';
import '../../../domain/entities/user_model.dart';
import '../../../domain/usecases/users/get_user_by_id_usecase.dart';
import '../../routes/app_routes.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserIdUsecase getUserId;

  ProfileCubit(this.getUserId) : super(ProfileInitial());

  UserModel? _user;
  UserModel? get user => _user;

  void loadUser() async {
    emit(ProfileLoading());

    final uid = await AppPreferences.getUserId();
    final resUser = await getUserId.execute(uid!);
    resUser.fold(
      (left) => emit(ProfileError(left.message.toString())),
      (right) {
        _user = right;
        emit(ProfileLoaded(right));
      },
    );
  }

  void changeProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageRef =
          FirebaseStorage.instance.ref().child('images/${_user!.id}');
      final uploadTask = imageRef.putFile(File(pickedFile.path));

      try {
        await uploadTask.whenComplete(() async {
          final downloadUrl = await imageRef.getDownloadURL();
          _updateProfilePicture(downloadUrl);
        });
      } catch (e) {
        emit(const UploadImageError('Failed to upload image'));
      }
    }
  }

  void _updateProfilePicture(String downloadUrl) async {
    await FirebaseFirestore.instance
        .collection(AppConstant.collectionUser)
        .doc(_user!.docId)
        .update({'imageUrl': downloadUrl});
    UserModel newUser = _user!.copyWith(imageUrl: downloadUrl);
    emit(ProfileLoaded(newUser));
  }

  void onLogout() async {
    if (state is ProfileLoaded) {
      emit((state as ProfileLoaded).copyWith(isLogout: true));

      await AppPreferences.removeToken();
      await AppPreferences.removeUserId();
      await FirebaseAuth.instance.signOut();

      Future.delayed(const Duration(seconds: 2), () {
        router.goNamed(RoutesName.login);
      });
    }
  }
}
