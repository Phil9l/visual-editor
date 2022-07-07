import 'package:flutter/material.dart';

import '../../../controller/controllers/editor-controller.dart';
import '../../../documents/models/attribute.model.dart';
import '../../../shared/models/editor-icon-theme.model.dart';
import '../../../shared/widgets/dropdown-button.dart';

// Controls the size of the currently selected text
// ignore: must_be_immutable
class SizesDropdown extends StatelessWidget {
  final Map<String, int> fontSizes;
  final double iconSize;
  final EditorIconThemeM? iconTheme;
  final double toolbarIconSize;
  final EditorController controller;
  int initialFontSizeValue;

  SizesDropdown({
    required this.fontSizes,
    required this.toolbarIconSize,
    required this.controller,
    required this.initialFontSizeValue,
    this.iconSize = 40,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownBtn(
        iconTheme: iconTheme,
        iconSize: toolbarIconSize,
        attribute: AttributeM.size,
        controller: controller,
        items: [
          for (MapEntry<String, int> fontSize in fontSizes.entries)
            PopupMenuItem<int>(
              key: ValueKey(fontSize.key),
              value: fontSize.value,
              child: Text(fontSize.key.toString()),
            ),
        ],
        onSelected: (newSize) {
          if ((newSize != null) && (newSize as int > 0)) {
            controller.formatSelection(
              AttributeM.fromKeyValue('size', newSize),
            );
          }
          if (newSize as int == 11) {
            controller.formatSelection(
              AttributeM.fromKeyValue('size', null),
            );
          }
        },
        rawitemsmap: fontSizes,
        initialValue: (initialFontSizeValue != null) &&
                (initialFontSizeValue <= fontSizes.length - 1)
            ? initialFontSizeValue
            : 11,
      );
}
