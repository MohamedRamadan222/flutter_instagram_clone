import 'package:flutter/material.dart';

Future<void> showAppBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        minChildSize: 0.6,
        maxChildSize: 0.95,

        builder: (context, scrollController) {
          return child;
        },
      );
    },
  );
}
