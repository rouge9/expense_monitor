part of 'upload_picture_bloc.dart';

sealed class UploadPictureState extends Equatable {
  const UploadPictureState();

  @override
  List<Object> get props => [];
}

final class UploadPictureInitial extends UploadPictureState {}

final class UploadPictureLoading extends UploadPictureState {}

final class UploadPictureSuccess extends UploadPictureState {
  final String pictureUrl;

  const UploadPictureSuccess(this.pictureUrl);

  @override
  List<Object> get props => [pictureUrl];
}

final class UploadPictureFailure extends UploadPictureState {
  final String error;

  const UploadPictureFailure(this.error);

  @override
  List<Object> get props => [error];
}
