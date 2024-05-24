import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'upload_picture_event.dart';
part 'upload_picture_state.dart';

class UploadPictureBloc extends Bloc<UploadPictureEvent, UploadPictureState> {
  final UserRepository _userRepository;

  UploadPictureBloc(this._userRepository) : super(UploadPictureInitial()) {
    on<UploadPictureEvent>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage =
            await _userRepository.uploadPicture(event.file!, event.userId!);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure(e.toString()));
      }
    });
  }
}
