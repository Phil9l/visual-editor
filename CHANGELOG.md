## [0.4.0]
* Added custom markers. Multiple marker types can be defined. The client app can define callbacks for hovering the markers.

## [0.3.0]
* Cleaning up editor.dart
* Improved docs
* Break editor.dart in multiple files
* Split source code in modules
* Updated linting options (removed some restrictions to improve readability)
* Moved all legacy files in /core to prepare for new modules
* Renamed to Visual Editor
* Bumped to Flutter 3.0.0
* Removed the mixins from RawEditor
* Separated code into services.
* Refactored many methods to avoid reading/manipulating values straight from the RawEditor context.
  This reduces the coupling, enabling us to isolate code into services that can be unit tested.
* Merged Editor and RawEditor.
* Replaced ChangeNotifiers with state streams.
* Added migration guide
* Updated demo pages
* Migrated state architecture from singleton to one state per editor controller instance.
* Exported the Toolbar buttons so that custom toolbars can be build from scratch
* Delta documents sandbox page, preview the json (development aid)
* Remove tuple dependency
* Fix the placeholder is not displayed bug
* The caret is no longer displayed in readonly mode. The `showCursor` configuration option for `VisualEditor` was removed. It makes no sense to have the cared showing up in readonly mode. Or the caret missing in editable mode.

## [0.2.0]
* Custom highlights

## [0.1.0]
* Rich text editor based on Flutter Quill Delta.

Join on [discord](https://discord.gg/XpGygmXde4) to get advice and help or follow us on [YouTube Visual Coding](https://www.youtube.com/channel/UC2-5lfNbbErIds0Iuai8yfA) to learn more about the architecture of Visual Editor and other Flutter apps.