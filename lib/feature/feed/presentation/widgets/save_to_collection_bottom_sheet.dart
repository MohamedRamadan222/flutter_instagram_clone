import 'package:flutter/material.dart';

class SaveToCollectionBottomSheet extends StatefulWidget {
  final Map post;
  final BuildContext parentContext;

  const SaveToCollectionBottomSheet({
    super.key,
    required this.post,
    required this.parentContext,
  });

  @override
  State<SaveToCollectionBottomSheet> createState() =>
      _SaveToCollectionBottomSheetState();
}

class _SaveToCollectionBottomSheetState
    extends State<SaveToCollectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
