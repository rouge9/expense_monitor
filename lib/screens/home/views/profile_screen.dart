import 'dart:math';

import 'package:expense_monitor/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:expense_monitor/auth/blocs/update_user_bloc/update_user_bloc.dart';
import 'package:expense_monitor/auth/blocs/google_cubit/google_auth_cubit.dart';
import 'package:expense_monitor/auth/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:expense_monitor/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:expense_monitor/auth/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:expense_monitor/auth/view/welcome_screen.dart';
import 'package:expense_monitor/components/my_text_field.dart';
import 'package:expense_monitor/components/profile_menu.dart';
import 'package:expense_monitor/screens/home/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  MyUser user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

bool isLoading = false;
bool isEdit = false;
TextEditingController nameController = TextEditingController();
final _formKey = GlobalKey<FormState>();
String? _errorMsg;

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UploadPictureBloc, UploadPictureState>(
          listener: (context, state) {
            if (state is UploadPictureLoading) {
              setState(() {
                isLoading = true;
              });
            }
            if (state is UploadPictureSuccess) {
              setState(() {
                widget.user.picture = state.pictureUrl;
                isLoading = false;
              });
            }
          },
        ),
        BlocListener<UpdateUserBloc, UpdateUserState>(
          listener: (context, state) {
            if (state is UpdateUserSuccess) {
              setState(() {
                widget.user = state.myUser;
                widget.user.picture = state.myUser.picture;
                isLoading = false;
              });
            } else if (state is UpdateUserFailure) {
              setState(() {
                _errorMsg = state.errorMsg;
                isLoading = false;
              });
            } else if (state is UpdateUserLoading) {
              setState(() {
                isLoading = true;
              });
            }
          },
        )
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state.status ==
                              AuthenticationStatus.authenticated) {
                            return BlocProvider(
                                create: (context) => MyUserBloc(
                                    myUserRepository: context
                                        .read<AuthenticationBloc>()
                                        .userRepository)
                                  ..add(
                                    GetMyUser(
                                        myUserId: context
                                            .read<AuthenticationBloc>()
                                            .state
                                            .user!
                                            .uid),
                                  ),
                                child: HomeScreen(
                                  userId: state.user!.uid,
                                ));
                          } else {
                            return const WelcomeScreen();
                          }
                        },
                      ),
                    ),
                  );
                  isEdit = false;
                },
                icon: Icon(CupertinoIcons.arrow_left_circle_fill,
                    color: Theme.of(context).colorScheme.outline),
              ),
            ),
          ),
          leadingWidth: 70,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              widget.user.picture == '' || isEdit
                                  ? GestureDetector(
                                      onTap: () async {
                                        final picker = ImagePicker();

                                        final pickedImage =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedImage != null) {
                                          CroppedFile? croppedFile =
                                              await ImageCropper().cropImage(
                                            sourcePath: pickedImage.path,
                                            aspectRatio: const CropAspectRatio(
                                                ratioX: 1, ratioY: 1),
                                            compressQuality: 70,
                                            maxWidth: 500,
                                            maxHeight: 500,
                                            uiSettings: [
                                              AndroidUiSettings(
                                                  toolbarTitle: 'Cropper',
                                                  toolbarColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  toolbarWidgetColor:
                                                      Colors.white,
                                                  initAspectRatio:
                                                      CropAspectRatioPreset
                                                          .original,
                                                  lockAspectRatio: false),
                                              IOSUiSettings(
                                                title: 'Cropper',
                                              ),
                                            ],
                                          );
                                          if (croppedFile != null) {
                                            setState(() {
                                              context
                                                  .read<UploadPictureBloc>()
                                                  .add(UploadPicture(
                                                      croppedFile.path,
                                                      widget.user.userId));
                                            });
                                          }
                                        }
                                      },
                                      child: isLoading
                                          ? Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                              ),
                                            )
                                          : isEdit
                                              ? Stack(children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Colors.yellow[800],
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                widget.user
                                                                    .picture!),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: Icon(Icons.add,
                                                          size: 15,
                                                          color: Colors
                                                              .yellow[900]),
                                                    ),
                                                  ),
                                                ])
                                              : Stack(children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[800],
                                                        shape: BoxShape.circle),
                                                    child: Icon(
                                                        Icons
                                                            .add_a_photo_outlined,
                                                        size: 25,
                                                        color:
                                                            Colors.yellow[900]),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: Icon(Icons.add,
                                                          size: 15,
                                                          color: Colors
                                                              .yellow[900]),
                                                    ),
                                                  ),
                                                ]),
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow[800],
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.user.picture!),
                                              fit: BoxFit.cover)),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              isEdit
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Form(
                                        key: _formKey,
                                        child: MyTextField(
                                          controller: nameController,
                                          hintText: 'Name',
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Name cannot be empty';
                                            }
                                            return null;
                                          },
                                          obscureText: false,
                                          keyboardType: TextInputType.text,
                                          errorMsg: _errorMsg,
                                          autofocus: true,
                                        ),
                                      ),
                                    )
                                  : isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Container(
                                                width: 100,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text(
                                                widget.user.name,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface),
                                              ),
                                              Text(
                                                widget.user.email,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface),
                                              ),
                                            ]),
                            ],
                          ),
                          isEdit
                              ? Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<UpdateUserBloc>().add(
                                              UpdateUser(MyUser(
                                                  userId: widget.user.userId,
                                                  name: nameController.text,
                                                  email: widget.user.email,
                                                  picture:
                                                      widget.user.picture)));

                                          setState(() {
                                            isEdit = !isEdit;
                                            nameController.clear();
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.check,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isEdit = !isEdit;
                                          nameController.clear();
                                        });
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.x,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                  ],
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isEdit = !isEdit;
                                      nameController.clear();
                                    });
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.userPen,
                                    size: 18,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ProfileMenu(
                          icon: Icon(FontAwesomeIcons.user,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface),
                          name: 'Account',
                          desc: 'Personal, Payment, Security',
                          onPressed: () {},
                        ),
                        ProfileMenu(
                          icon: Icon(FontAwesomeIcons.bell,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface),
                          name: 'Notification',
                          desc: 'Your notification settings',
                          onPressed: () {},
                        ),
                        ProfileMenu(
                          icon: Icon(FontAwesomeIcons.arrowRightFromBracket,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface),
                          name: 'Log out',
                          desc: 'Log out of your account',
                          onPressed: () {
                            if (GoogleSignIn().currentUser != null) {
                              context
                                  .read<SignInBloc>()
                                  .add(const SignOutRequired());

                              Navigator.pop(context);
                            } else {
                              context
                                  .read<GoogleAuthCubit>()
                                  .resetAccount()
                                  .then((_) {
                                context
                                    .read<SignInBloc>()
                                    .add(const SignOutRequired());
                              });
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'More',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ProfileMenu(
                          icon: Icon(FontAwesomeIcons.question,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface),
                          name: 'Help',
                          desc: 'FAQ, Contact Us, Privacy Policy',
                          onPressed: () {},
                        ),
                        ProfileMenu(
                          icon: Icon(FontAwesomeIcons.heart,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface),
                          name: 'About App',
                          desc: 'Information about the app',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
