import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Icon? icon;
  final bool isGradient;
  final bool isLoading;
  final Color? loadingColor;

  const Button(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.isGradient = false,
      this.isLoading = false,
      this.loadingColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: isGradient
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                transform: const GradientRotation(0.5),
              )
            : null,
        color: isGradient ? null : Colors.black,
      ),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: loadingColor ?? Colors.white,
              ),
            )
          : TextButton(
              onPressed: () {
                if (!isLoading) {
                  onPressed();
                }
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  const SizedBox(width: 20),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
