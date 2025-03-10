import 'package:flutter/material.dart';

import '../../shared/utils/platform.utils.dart';
import 'default-block-style.model.dart';
import 'default-text-block-style.model.dart';
import 'inline-code-style.model.dart';
import 'vertical-spacing.model.dart';

// Default document styles
class DefaultStyles {
  final DefaultTextBlockStyle? h1;
  final DefaultTextBlockStyle? h2;
  final DefaultTextBlockStyle? h3;
  final DefaultTextBlockStyle? paragraph;
  final TextStyle? bold;
  final TextStyle? italic;
  final TextStyle? small;
  final TextStyle? underline;
  final TextStyle? strikeThrough;

  /// Theme of inline code.
  final InlineCodeStyle? inlineCode;
  final TextStyle? sizeSmall; // 'small'
  final TextStyle? sizeLarge; // 'large'
  final TextStyle? sizeHuge; // 'huge'
  final TextStyle? link;
  final Color? color;
  final DefaultTextBlockStyle? placeHolder;
  final DefaultListBlockStyle? lists;
  final DefaultTextBlockStyle? quote;
  final DefaultTextBlockStyle? code;
  final DefaultTextBlockStyle? indent;
  final DefaultTextBlockStyle? align;
  final DefaultTextBlockStyle? leading;

  DefaultStyles({
    this.h1,
    this.h2,
    this.h3,
    this.paragraph,
    this.bold,
    this.italic,
    this.small,
    this.underline,
    this.strikeThrough,
    this.inlineCode,
    this.link,
    this.color,
    this.placeHolder,
    this.lists,
    this.quote,
    this.code,
    this.indent,
    this.align,
    this.leading,
    this.sizeSmall,
    this.sizeLarge,
    this.sizeHuge,
  });

  static DefaultStyles getInstance(BuildContext context) {
    final themeData = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);
    final baseStyle = defaultTextStyle.style.copyWith(
      fontSize: 16,
      height: 1.3,
    );
    final baseSpacing = VerticalSpacing(top: 6, bottom: 0);
    String fontFamily;

    if (isAppleOS(themeData.platform)) {
      fontFamily = 'Menlo';
    } else {
      fontFamily = 'Roboto Mono';
    }

    final inlineCodeStyle = TextStyle(
      fontSize: 14,
      color: themeData.colorScheme.primary.withOpacity(0.8),
      fontFamily: fontFamily,
    );

    return DefaultStyles(
      h1: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 34,
          color: defaultTextStyle.style.color!.withOpacity(0.70),
          height: 1.15,
          fontWeight: FontWeight.w300,
        ),
        VerticalSpacing(top: 16, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      h2: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 24,
          color: defaultTextStyle.style.color!.withOpacity(0.70),
          height: 1.15,
          fontWeight: FontWeight.normal,
        ),
        VerticalSpacing(top: 8, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      h3: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 20,
          color: defaultTextStyle.style.color!.withOpacity(0.70),
          height: 1.25,
          fontWeight: FontWeight.w500,
        ),
        VerticalSpacing(top: 8, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      paragraph: DefaultTextBlockStyle(
        baseStyle,
        VerticalSpacing(top: 0, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      bold: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      italic: const TextStyle(
        fontStyle: FontStyle.italic,
      ),
      small: const TextStyle(
        fontSize: 12,
        color: Colors.black45,
      ),
      underline: const TextStyle(
        decoration: TextDecoration.underline,
      ),
      strikeThrough: const TextStyle(
        decoration: TextDecoration.lineThrough,
      ),
      inlineCode: InlineCodeStyle(
        backgroundColor: Colors.grey.shade100,
        radius: const Radius.circular(3),
        style: inlineCodeStyle,
        header1: inlineCodeStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w300,
        ),
        header2: inlineCodeStyle.copyWith(
          fontSize: 22,
        ),
        header3: inlineCodeStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      link: TextStyle(
        color: themeData.colorScheme.secondary,
        decoration: TextDecoration.underline,
      ),
      placeHolder: DefaultTextBlockStyle(
        defaultTextStyle.style.copyWith(
          fontSize: 20,
          height: 1.5,
          color: Colors.grey.withOpacity(0.6),
        ),
        VerticalSpacing(top: 0, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      lists: DefaultListBlockStyle(
        baseStyle,
        baseSpacing,
        VerticalSpacing(top: 0, bottom: 6),
        null,
        null,
      ),
      quote: DefaultTextBlockStyle(
        TextStyle(
          color: baseStyle.color!.withOpacity(0.6),
        ),
        baseSpacing,
        VerticalSpacing(top: 6, bottom: 2),
        BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 4,
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
      code: DefaultTextBlockStyle(
        TextStyle(
          color: Colors.blue.shade900.withOpacity(0.9),
          fontFamily: fontFamily,
          fontSize: 13,
          height: 1.15,
        ),
        baseSpacing,
        VerticalSpacing(top: 0, bottom: 0),
        BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      indent: DefaultTextBlockStyle(
        baseStyle,
        baseSpacing,
        VerticalSpacing(top: 0, bottom: 6),
        null,
      ),
      align: DefaultTextBlockStyle(
        baseStyle,
        VerticalSpacing(top: 0, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      leading: DefaultTextBlockStyle(
        baseStyle,
        VerticalSpacing(top: 0, bottom: 0),
        VerticalSpacing(top: 0, bottom: 0),
        null,
      ),
      sizeSmall: const TextStyle(
        fontSize: 10,
      ),
      sizeLarge: const TextStyle(
        fontSize: 18,
      ),
      sizeHuge: const TextStyle(
        fontSize: 22,
      ),
    );
  }

  DefaultStyles merge(DefaultStyles other) {
    return DefaultStyles(
      h1: other.h1 ?? h1,
      h2: other.h2 ?? h2,
      h3: other.h3 ?? h3,
      paragraph: other.paragraph ?? paragraph,
      bold: other.bold ?? bold,
      italic: other.italic ?? italic,
      small: other.small ?? small,
      underline: other.underline ?? underline,
      strikeThrough: other.strikeThrough ?? strikeThrough,
      inlineCode: other.inlineCode ?? inlineCode,
      link: other.link ?? link,
      color: other.color ?? color,
      placeHolder: other.placeHolder ?? placeHolder,
      lists: other.lists ?? lists,
      quote: other.quote ?? quote,
      code: other.code ?? code,
      indent: other.indent ?? indent,
      align: other.align ?? align,
      leading: other.leading ?? leading,
      sizeSmall: other.sizeSmall ?? sizeSmall,
      sizeLarge: other.sizeLarge ?? sizeLarge,
      sizeHuge: other.sizeHuge ?? sizeHuge,
    );
  }
}
