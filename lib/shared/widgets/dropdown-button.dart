import 'dart:async';

import 'package:flutter/material.dart';

import '../../controller/controllers/editor-controller.dart';
import '../../documents/models/attribute.model.dart';
import '../../documents/models/style.model.dart';
import '../models/editor-icon-theme.model.dart';
import '../state/editor-state-receiver.dart';
import '../state/editor.state.dart';

// Btn shortname was used to avoid collision with Flutter DropdownButton.
// ignore: must_be_immutable
class DropdownBtn<T> extends StatefulWidget with EditorStateReceiver {
  final double iconSize;
  final Color? fillColor;
  final double hoverElevation;
  final double highlightElevation;
  final T initialValue;
  final List<PopupMenuEntry<T>> items;
  final Map<String, int> rawitemsmap;
  final ValueChanged<T> onSelected;
  final EditorIconThemeM? iconTheme;
  final AttributeM attribute;
  final EditorController controller;

  // Used internally to retrieve the state from the EditorController instance to which this button is linked to.
  // Can't be accessed publicly (by design) to avoid exposing the internals of the library.
  late EditorState _state;

  @override
  void setState(EditorState state) {
    _state = state;
  }

  DropdownBtn({
    required this.initialValue,
    required this.items,
    required this.rawitemsmap,
    required this.attribute,
    required this.controller,
    required this.onSelected,
    this.iconSize = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
    this.iconTheme,
    Key? key,
  }) : super(key: key) {
    controller.setStateInEditorStateReceiver(this);
  }

  @override
  _DropdownBtnState<T> createState() => _DropdownBtnState<T>();
}

class _DropdownBtnState<T> extends State<DropdownBtn<T>> {
  String _currentValue = '';
  late final StreamSubscription _updateListener;

  StyleM get _selectionStyle => widget.controller.getSelectionStyle();

  @override
  void initState() {
    super.initState();
    _updateListener = widget._state.refreshEditor.updateEditor$.listen(
      (_) => _didChangeEditingValue,
    );
    _currentValue = widget.rawitemsmap.keys.elementAt(
      widget.initialValue as int,
    );
  }

  @override
  void dispose() {
    _updateListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: widget.iconSize * 1.81,
      ),
      child: RawMaterialButton(
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.iconTheme?.borderRadius ?? 2,
          ),
        ),
        fillColor: widget.fillColor,
        elevation: 0,
        hoverElevation: widget.hoverElevation,
        highlightElevation: widget.hoverElevation,
        onPressed: _showMenu,
        child: _selector(context),
      ),
    );
  }

  Widget _selector(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentValue.toString(),
            style: TextStyle(
              fontSize: widget.iconSize / 1.15,
              color: widget.iconTheme?.iconUnselectedColor ??
                  theme.iconTheme.color,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.arrow_drop_down,
            size: widget.iconSize / 1.15,
            color:
                widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color,
          )
        ],
      ),
    );
  }

  // === UTILS ===

  void _didChangeEditingValue() {
    setState(() => _currentValue = _getKeyName(_selectionStyle.attributes));
  }

  String _getKeyName(Map<String, AttributeM> attrs) {
    if (widget.attribute.key == AttributeM.size.key) {
      final attribute = attrs[widget.attribute.key];

      if (attribute == null) {
        return widget.rawitemsmap.keys
            .elementAt(widget.initialValue as int)
            .toString();
      } else {
        return widget.rawitemsmap.entries
            .firstWhere((element) => element.value == attribute.value,
                orElse: () => widget.rawitemsmap.entries.first)
            .key;
      }
    }

    return widget.rawitemsmap.keys
        .elementAt(widget.initialValue as int)
        .toString();
  }

  void _showMenu() {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final button = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<T>(
      context: context,
      elevation: 4,
      // widget.elevation ?? popupMenuTheme.elevation,
      initialValue: widget.initialValue,
      items: widget.items,
      position: position,
      shape: popupMenuTheme.shape,
      // widget.shape ?? popupMenuTheme.shape,
      color: popupMenuTheme.color, // widget.color ?? popupMenuTheme.color,
      // captureInheritedThemes: widget.captureInheritedThemes,
    ).then((newValue) {
      if (!mounted) {
        return null;
      }
      if (newValue == null) {
        // if (widget.onCanceled != null) widget.onCanceled();
        return null;
      }

      setState(() {
        _currentValue = widget.rawitemsmap.entries
            .firstWhere((element) => element.value == newValue,
                orElse: () => widget.rawitemsmap.entries.first)
            .key;
        widget.onSelected(newValue);
      });
    });
  }
}
