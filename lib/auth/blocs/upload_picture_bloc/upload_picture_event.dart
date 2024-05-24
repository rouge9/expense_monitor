part of 'upload_picture_bloc.dart';

sealed class UploadPictureEvent extends Equatable {
  const UploadPictureEvent();

  @override
  List<Object> get props => [];

  String? get file => null;

  String? get userId => null;
}

final class UploadPicture extends UploadPictureEvent {
  @override
  final String file;
  @override
  final String userId;

  const UploadPicture(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}
