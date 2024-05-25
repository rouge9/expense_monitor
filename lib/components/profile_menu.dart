import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileMenu extends StatelessWidget {
  final String name;
  final String desc;
  final Function onPressed;
  final Icon icon;

  const ProfileMenu(
      {super.key,
      required this.name,
      required this.desc,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: icon),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          desc,
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ]),
                ],
              ),
              IconButton(
                onPressed: () {
                  onPressed();
                },
                icon: Icon(
                  FontAwesomeIcons.chevronRight,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
