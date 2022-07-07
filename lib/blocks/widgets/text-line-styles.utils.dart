import 'package:flutter/material.dart';

import '../../documents/models/attribute.model.dart';
import '../../documents/models/nodes/line.model.dart';
import '../../documents/models/nodes/text.model.dart';
import '../../documents/models/style.model.dart';
import '../../shared/state/editor.state.dart';
import '../../shared/utils/color.utils.dart';
import '../models/default-styles.model.dart';

// Handles applying the styles of delta operations attributes to the generated text spans.
class TextLineStyleUtils {
  // Whole line styles
  // Returns the styles of a text line depending on the attributes encoded in the delta operations.
  // Combines default general styles with the styles of the delta document (node and line).
  TextStyle getLineStyle(
    DefaultStyles defaultStyles,
    LineM line,
    EditorState state,
  ) {
    var textStyle = const TextStyle();

    // Placeholder
    if (line.style.containsKey(AttributeM.placeholder.key)) {
      return defaultStyles.placeHolder!.style;
    }

    // Headers
    final header = line.style.attributes[AttributeM.header.key];
    final m = <AttributeM, TextStyle>{
      AttributeM.h1: defaultStyles.h1!.style,
      AttributeM.h2: defaultStyles.h2!.style,
      AttributeM.h3: defaultStyles.h3!.style,
    };

    textStyle = textStyle.merge(m[header] ?? defaultStyles.paragraph!.style);

    // Only retrieve exclusive block format for the line style purpose
    AttributeM? block;
    line.style.getBlocksExceptHeader().forEach((key, value) {
      if (AttributeM.exclusiveBlockKeys.contains(key)) {
        block = value;
      }
    });

    TextStyle? toMerge;

    // Block Quote, Code Block, List
    if (block == AttributeM.blockQuote) {
      toMerge = defaultStyles.quote!.style;
    } else if (block == AttributeM.codeBlock) {
      toMerge = defaultStyles.code!.style;
    } else if (block == AttributeM.list) {
      toMerge = defaultStyles.lists!.style;
    }

    // Custom style attributes
    textStyle = textStyle.merge(toMerge);
    textStyle = applyCustomAttributes(
      textStyle,
      line.style.attributes,
      state,
    );

    return textStyle;
  }

  // Line fragments styles
  // Returns the styles of a text line depending on the attributes encoded in the delta operations.
  // Combines default general styles with the styles of the delta document (node and line).
  TextStyle getInlineTextStyle(
    TextM textNode,
    DefaultStyles defaultStyles,
    StyleM nodeStyle,
    StyleM lineStyle,
    bool isLink,
    EditorState state,
  ) {
    print('+++ _getInlineTextStyle()');
    var inlineStyle = const TextStyle();
    final color = textNode.style.attributes[AttributeM.color.key];

    // Copy styles if attribute is present
    <String, TextStyle?>{
      AttributeM.bold.key: defaultStyles.bold,
      AttributeM.italic.key: defaultStyles.italic,
      AttributeM.small.key: defaultStyles.small,
      AttributeM.link.key: defaultStyles.link,
      AttributeM.underline.key: defaultStyles.underline,
      AttributeM.strikeThrough.key: defaultStyles.strikeThrough,
    }.forEach((key, style) {
      final nodeHasAttribute =
          nodeStyle.values.any((attribute) => attribute.key == key);

      if (nodeHasAttribute) {
        // Underline, Strikethrough
        if (key == AttributeM.underline.key ||
            key == AttributeM.strikeThrough.key) {
          var textColor = defaultStyles.color;

          if (color?.value is String) {
            textColor = stringToColor(color?.value);
          }

          inlineStyle = _merge(
            inlineStyle.copyWith(
              decorationColor: textColor,
            ),
            style!.copyWith(
              decorationColor: textColor,
            ),
          );

          // Link
        } else if (key == AttributeM.link.key && !isLink) {
          // null value for link should be ignored
          // i.e. nodeStyle.attributes[Attribute.link.key]!.value == null

          // Other
        } else {
          inlineStyle = _merge(inlineStyle, style!);
        }
      }
    });

    // Inline code
    if (nodeStyle.containsKey(AttributeM.inlineCode.key)) {
      inlineStyle = _merge(
        inlineStyle,
        defaultStyles.inlineCode!.styleFor(lineStyle),
      );
    }

    // Fonts
    final font = textNode.style.attributes[AttributeM.font.key];

    if (font != null && font.value != null) {
      inlineStyle = inlineStyle.merge(TextStyle(
        fontFamily: font.value,
      ));
    }

    final size = textNode.style.attributes[AttributeM.size.key];

    // Size
    // TODO Review: S, M, H - Seems to be no longer used (unless we want to support legacy)
    if (size != null && size.value != null) {
      switch (size.value) {
        case 'small':
          inlineStyle = inlineStyle.merge(defaultStyles.sizeSmall);
          break;

        case 'large':
          inlineStyle = inlineStyle.merge(defaultStyles.sizeLarge);
          break;

        case 'huge':
          inlineStyle = inlineStyle.merge(defaultStyles.sizeHuge);
          break;

        default:
          double? fontSize;

          if (size.value is double) {
            fontSize = size.value;
          } else if (size.value is int) {
            fontSize = size.value.toDouble();
          } else if (size.value is String) {
            fontSize = double.tryParse(size.value);
          }

          if (fontSize != null) {
            inlineStyle = inlineStyle.merge(TextStyle(fontSize: fontSize));
          } else {
            throw 'Invalid size ${size.value}';
          }
      }
    }

    // Color
    if (color != null && color.value != null) {
      var textColor = defaultStyles.color;

      if (color.value is String) {
        textColor = stringToColor(color.value);
      }

      if (textColor != null) {
        inlineStyle = inlineStyle.merge(
          TextStyle(color: textColor),
        );
      }
    }

    // Background
    final background = textNode.style.attributes[AttributeM.background.key];

    if (background != null && background.value != null) {
      final backgroundColor = stringToColor(background.value);
      inlineStyle = inlineStyle.merge(
        TextStyle(
          backgroundColor: backgroundColor,
        ),
      );
    }

    inlineStyle = applyCustomAttributes(
      inlineStyle,
      textNode.style.attributes,
      state,
    );

    print('+++ inlineStyle $inlineStyle');
    return inlineStyle;
  }

  TextStyle applyCustomAttributes(
    TextStyle textStyle,
    Map<String, AttributeM> attributes,
    EditorState state,
  ) {
    if (state.editorConfig.config.customStyleBuilder == null) {
      return textStyle;
    }

    attributes.keys.forEach((key) {
      final attr = attributes[key];

      if (attr != null) {
        // Custom Attribute
        final customAttr = state.editorConfig.config.customStyleBuilder!.call(
          attr,
        );
        textStyle = textStyle.merge(customAttr);
      }
    });

    return textStyle;
  }

  TextAlign getTextAlign(LineM line) {
    final alignment = line.style.attributes[AttributeM.align.key];

    if (alignment == AttributeM.leftAlignment) {
      return TextAlign.start;
    } else if (alignment == AttributeM.centerAlignment) {
      return TextAlign.center;
    } else if (alignment == AttributeM.rightAlignment) {
      return TextAlign.end;
    } else if (alignment == AttributeM.justifyAlignment) {
      return TextAlign.justify;
    }

    return TextAlign.start;
  }

  // === PRIVATE ===

  TextStyle _merge(TextStyle a, TextStyle b) {
    final decorations = <TextDecoration?>[];

    if (a.decoration != null) {
      decorations.add(a.decoration);
    }

    if (b.decoration != null) {
      decorations.add(b.decoration);
    }

    return a.merge(b).apply(
          decoration: TextDecoration.combine(
            List.castFrom<dynamic, TextDecoration>(decorations),
          ),
        );
  }
}
