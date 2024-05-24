import 'package:flutter/material.dart';
import 'package:expense_monitor/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> addCategory(BuildContext context, userId) {
  bool isExpandabel = false;
  String iconSelected = '';
  Color colorSelected = Colors.white;
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryIconController = TextEditingController();
  TextEditingController categoryColorController = TextEditingController();
  bool isLoading = false;
  List<String> myCategoriesIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel',
    'fuel',
    'health',
    'bills',
    'transport'
  ];
  Category category = Category.empty;
  final formKey = GlobalKey<FormState>();
  String? errorMsg;
  return showModalBottomSheet(
      anchorPoint: const Offset(0.5, 0.5),
      sheetAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut, duration: const Duration(milliseconds: 500)),
      scrollControlDisabledMaxHeightRatio: 0.9,
      context: context,
      builder: (ctx) {
        return Form(
          key: formKey,
          child: BlocProvider.value(
            value: context.read<CreateCategoryBloc>(),
            child: StatefulBuilder(builder: (ctx, setState) {
              return BlocListener<CreateCategoryBloc, CreateCategoryState>(
                listener: (context, state) {
                  if (state is CreateCategorySuccess) {
                    Navigator.pop(context, category);
                  } else if (state is CreateCategoryLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  } else if (state is CreateCategoryFailure) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        dismissDirection: DismissDirection.down,
                        behavior: SnackBarBehavior.floating,
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Add Category',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: categoryNameController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              label: const Text('Name'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              errorText: errorMsg,
                              errorStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: categoryIconController,
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            onTap: () {
                              setState(
                                () {
                                  isExpandabel = !isExpandabel;
                                },
                              );
                            },
                            decoration: InputDecoration(
                              label: const Text('Select Icon'),
                              hintText: 'Select Icon',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              suffixIcon: Icon(
                                  isExpandabel
                                      ? FontAwesomeIcons.chevronUp
                                      : FontAwesomeIcons.chevronDown,
                                  size: 12),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: const Radius.circular(10),
                                    bottom: isExpandabel
                                        ? Radius.zero
                                        : const Radius.circular(10),
                                  ),
                                  borderSide: BorderSide.none),
                              errorText: errorMsg,
                              errorStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                            validator: (value) {
                              if (iconSelected.isEmpty) {
                                return 'Icon is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        isExpandabel
                            ? Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(10))),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemCount: myCategoriesIcons.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          iconSelected =
                                              myCategoriesIcons[index];
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/${myCategoriesIcons[index]}.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          color: Colors.grey[200],
                                          border: Border.all(
                                            color: iconSelected ==
                                                    myCategoriesIcons[index]
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: categoryColorController,
                            readOnly: true,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              label: const Text('Color'),
                              hintText: 'Selected Color',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: colorSelected,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              errorText: errorMsg,
                              errorStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return SingleChildScrollView(
                                    child: AlertDialog(
                                      title: const Text(
                                        'Pick a color',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ColorPicker(
                                              color: colorSelected,
                                              onChanged: (color) {
                                                setState(() {
                                                  colorSelected = color;
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              child: TextButton(
                                                onPressed: () {
                                                  Category category =
                                                      Category.empty;
                                                  category.categoryId =
                                                      const Uuid().v1();
                                                  category.name =
                                                      categoryNameController
                                                          .text;
                                                  category.icon = iconSelected;
                                                  category.color =
                                                      colorSelected.value;

                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'PICK',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: isLoading == true
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      category.categoryId = const Uuid().v1();
                                      category.name =
                                          categoryNameController.text;
                                      category.icon = iconSelected;
                                      category.color = colorSelected.value;
                                      category.userId = userId;
                                    });

                                    if (formKey.currentState!.validate()) {
                                      context.read<CreateCategoryBloc>().add(
                                            CreateCategory(category),
                                          );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    // backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      });
}
