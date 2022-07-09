import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visual_editor/visual-editor.dart';

import '../const/sample-highlights.const.dart';
import '../widgets/demo-scaffold.dart';
import '../widgets/loading.dart';

class DeltaSandbox extends StatefulWidget {
  const DeltaSandbox({Key? key}) : super(key: key);

  @override
  State<DeltaSandbox> createState() => _DeltaSandboxState();
}

class _DeltaSandboxState extends State<DeltaSandbox> {
  EditorController? _visualEditorController;
  late TextEditingController _jsonEditorController;
  final _focusNode = FocusNode();

  @override
  void initState() {
    _loadDocument();
    _jsonEditorController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _jsonEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _scaffold(
        children: _visualEditorController != null
            ? [
                _editor(),
                _deltaDocument(),
              ]
            : [
                Loading(),
              ],
      );

  Widget _scaffold({required List<Widget> children}) => DemoScaffold(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );

  Widget _editor() => Expanded(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: VisualEditor(
            controller: _visualEditorController!,
            scrollController: ScrollController(),
            focusNode: _focusNode,
            config: EditorConfigM(
              placeholder: 'Enter text',
            ),
          ),
        ),
      );

  Widget _deltaDocument() => Expanded(
        child: _editorTitle('Delta Document'),
      );

  Widget _editorTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      );

  Future<void> _loadDocument() async {
    final result = await rootBundle.loadString(
      'assets/docs/all-styles.json',
    );
    final document = DocumentM.fromJson(jsonDecode(result));

    setState(() {
      _visualEditorController = EditorController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
        highlights: SAMPLE_HIGHLIGHTS,
      );
    });
  }
}
