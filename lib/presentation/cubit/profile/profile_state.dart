part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserModel user;
  final bool isLogout;

  const ProfileLoaded(this.user, {this.isLogout = false});

  @override
  List<Object> get props => [user, isLogout];

  ProfileLoaded copyWith({
    UserModel? user,
    bool? isLogout,
  }) {
    return ProfileLoaded(
      user ?? this.user,
      isLogout: isLogout ?? this.isLogout,
    );
  }
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

final class UploadImageLoading extends ProfileState {}

final class UploadImageSuccess extends ProfileState {}

final class UploadImageError extends ProfileState {
  final String message;

  const UploadImageError(this.message);

  @override
  List<Object> get props => [message];
}
