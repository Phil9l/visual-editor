import 'package:flutter/material.dart';

const _DEFAULT_MARKER_COLOR = Color.fromRGBO(0xFF, 0xC1, 0x17, .3);
const _HOVERED_MARKER_COLOR = Color.fromRGBO(0xFF, 0xC1, 0x17, .5);

// Custom markers types can be provided to the EditorController.
// Authors can select from different marker types that have been provided by the app developers.
// The markers are defined in the delta document using the marker attribute
// (unlike highlights which are defined programmatically from the controller).
// Callbacks can be defined to react to hovering and tapping.
@immutable
class MarkersTypeM {
  final String id;
  final String name;
  final TextSelection textSelection;
  final Color color;
  final Color hoverColor;
  final Function(MarkersTypeM marker)? onSingleTapUp;
  final Function(MarkersTypeM marker)? onEnter;
  final Function(MarkersTypeM marker)? onHover;
  final Function(MarkersTypeM marker)? onLeave;

  const MarkersTypeM({
    required this.id,
    required this.name,
    required this.textSelection,
    this.color = _DEFAULT_MARKER_COLOR,
    this.hoverColor = _HOVERED_MARKER_COLOR,
    this.onSingleTapUp,
    this.onEnter,
    this.onHover,
    this.onLeave,
  });
}
