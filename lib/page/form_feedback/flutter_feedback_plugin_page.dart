import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:coderjava_image_editor_pro/coderjava_image_editor_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feedback/localization/en_message.dart';
import 'package:flutter_feedback/localization/id_message.dart';
import 'package:flutter_feedback/localization/lookup_message.dart';
import 'package:flutter_feedback/widget/widget_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../preview_image/flutter_feedback_preview_image_page.dart';

final _valueListenableLoading = ValueNotifier<bool>(false);
late final Color _colorPrimary;
Function()? _onDialog401Showing;
late final LookupMessage _locale;

typedef _OnSubmitFeedback = void Function(
  List<String> listScreenshots,
  String category,
  String description,
);

class FormFeedbackController {
  void submitFeedback() {
    _valueListenableLoading.value = true;
  }

  void failureFeedback(BuildContext context, String errorMessage) {
    _valueListenableLoading.value = false;
    if (errorMessage.contains('401')) {
      _showDialog401(context);
      return;
    }
    _showSnackBar(context, errorMessage);
  }

  void successFeedback(BuildContext context) {
    _valueListenableLoading.value = false;
    _showDialogSuccess(context);
  }
}

class FlutterFeedbackPluginPage extends StatefulWidget {
  final File fileScreenshot;
  final _OnSubmitFeedback onSubmitFeedback;
  final Color colorPrimary;
  final Color colorSecondary;
  final Color colorAppBar;
  final Color? colorTitleAppBar;
  final Function()? onDialog401Showing;
  final String locale;

  FlutterFeedbackPluginPage(
    this.fileScreenshot,
    this.onSubmitFeedback, {
    this.colorPrimary = Colors.blue,
    this.colorSecondary = Colors.white,
    this.colorAppBar = Colors.blue,
    this.colorTitleAppBar,
    this.onDialog401Showing,
    this.locale = 'en',
  }) {
    _colorPrimary = this.colorPrimary;
    _onDialog401Showing = this.onDialog401Showing;
  }

  @override
  _FlutterFeedbackPluginPageState createState() => _FlutterFeedbackPluginPageState();
}

class _FlutterFeedbackPluginPageState extends State<FlutterFeedbackPluginPage> {
  final formState = GlobalKey<FormState>();
  final controllerFeedback = TextEditingController();
  final listAttachments = <String>[];

  var indexSelectedCategory = -1;
  var selectedCategory = '';
  var paddingBottom = 0.0;
  var paddingTop = 0.0;
  var heightScreen = 0.0;

  @override
  void initState() {
    listAttachments.add(widget.fileScreenshot.path);
    listAttachments.add('');
    _initLocale();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    paddingBottom = mediaQueryData.padding.bottom;
    paddingTop = mediaQueryData.padding.top;
    heightScreen = mediaQueryData.size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _locale.feedback(),
          style: TextStyle(
            color: widget.colorTitleAppBar ?? Colors.grey[700],
          ),
        ),
        backgroundColor: widget.colorAppBar,
        iconTheme: IconThemeData(color: widget.colorTitleAppBar ?? Colors.grey[700]),
      ),
      body: Stack(
        children: [
          _buildWidgetForm(),
          _buildWidgetLoading(),
        ],
      ),
    );
  }

  Widget _buildWidgetForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        paddingBottom > 0 ? paddingBottom : 16,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Text(
                  _locale.weWouldLikeYourFeedback(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  _locale.whatIsYourOpinionOfThisPage(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  width: double.infinity,
                  height: 128,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listAttachments.length,
                    itemBuilder: (context, index) {
                      final pathImage = listAttachments[index];
                      return pathImage.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedImageGallery = await ImagePicker().getImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 30,
                                  );
                                  if (pickedImageGallery != null) {
                                    listAttachments.removeLast();
                                    listAttachments.add(pickedImageGallery.path);
                                    listAttachments.add('');
                                    if (listAttachments.length > 3) {
                                      listAttachments.removeLast();
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Center(
                                  child: DottedBorder(
                                    color: Colors.grey,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FlutterFeedbackPreviewImagePage(pathImage),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 128,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(pathImage),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (index == 0) {
                                        _doEditImage(index);
                                        return;
                                      }
                                      final editDeleteAttachment = await showModalBottomSheet<String>(
                                        context: context,
                                        enableDrag: false,
                                        builder: (context) {
                                          return _buildWidgetEditDeleteAttachment();
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                      );
                                      if (editDeleteAttachment != null) {
                                        if (editDeleteAttachment == 'edit') {
                                          _doEditImage(index);
                                        } else if (editDeleteAttachment == 'delete') {
                                          listAttachments.removeAt(index);
                                          if (listAttachments.last.isNotEmpty) {
                                            listAttachments.add('');
                                          }
                                          setState(() {});
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _locale.pleaseSelectYourFeedbackCategoryBelow(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildWidgetChoiceChip(_locale.suggestion()),
                    _buildWidgetChoiceChip(_locale.appreciation()),
                    _buildWidgetChoiceChip(_locale.complain()),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _locale.pleaseLeaveYourFeedback(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Form(
                  key: formState,
                  child: TextFormField(
                    controller: controllerFeedback,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      hintText: _locale.typeMessageHere(),
                      isDense: true,
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return value == null || value.isEmpty ? _locale.enterYourFeedback() : null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedCategory.isEmpty) {
                  _showSnackBar(context, _locale.pleaseSelectFeedbackCategory());
                  return;
                } else if (formState.currentState!.validate()) {
                  widget.onSubmitFeedback.call(
                    listAttachments,
                    selectedCategory,
                    controllerFeedback.text.trim(),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: widget.colorPrimary,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
              child: Text(
                _locale.send().toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetLoading() {
    return ValueListenableBuilder(
      valueListenable: _valueListenableLoading,
      builder: (BuildContext context, bool isLoading, Widget? child) {
        if (isLoading) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Platform.isIOS
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoActivityIndicator(),
                          SizedBox(height: 8),
                          Text(
                            _locale.loading(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildWidgetEditDeleteAttachment() {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: paddingBottom > 0 ? paddingBottom : 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _locale.screenshots(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          ListTile(
            leading: Icon(
              Icons.brush,
              color: Colors.grey[700],
            ),
            title: Text(_locale.editScreenshot()),
            onTap: () {
              Navigator.pop(context, 'edit');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.grey[700],
            ),
            title: Text(_locale.deleteScreenshot()),
            onTap: () {
              Navigator.pop(context, 'delete');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetChoiceChip(String label) {
    final isSelected = label == selectedCategory;
    return ChoiceChip(
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
            color: isSelected ? widget.colorPrimary : Colors.grey,
          ),
      selected: isSelected,
      onSelected: (_) => setState(() => selectedCategory = label),
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? widget.colorPrimary : Colors.grey,
        ),
      ),
    );
  }

  void _doEditImage(int index) async {
    final resultEditImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoderJavaImageEditorPro(
          appBarColor: Colors.black87,
          bottomBarColor: Colors.black87,
          defaultPathImage: listAttachments[index],
          isShowingChooseImage: false,
          isShowingFlip: false,
          isShowingRotate: false,
          isShowingBlur: false,
          isShowingFilter: false,
          isShowingEmoji: false,
        ),
      ),
    ) as File?;
    if (resultEditImage != null) {
      setState(() => listAttachments[index] = resultEditImage.path);
    }
  }

  void _initLocale() {
    if (widget.locale.toLowerCase() == 'en') {
      _locale = EnMessage();
    } else if (widget.locale.toLowerCase() == 'id') {
      _locale = IdMessage();
    }
  }
}

void _showDialog401(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WidgetDialog(
        title: _locale.info(),
        content: _locale.refreshTokenExpired(),
        actionsAlertDialog: <Widget>[
          TextButton(
            child: Text(
              _locale.login().toUpperCase(),
              style: Theme.of(context).textTheme.button?.copyWith(color: _colorPrimary),
            ),
            onPressed: () async {
              if (_onDialog401Showing != null) {
                _onDialog401Showing?.call();
              }
            },
          ),
        ],
        actionsCupertinoDialog: <Widget>[
          CupertinoDialogAction(
            child: Text(
              _locale.login(),
            ),
            isDefaultAction: true,
            onPressed: () async {
              if (_onDialog401Showing != null) {
                _onDialog401Showing?.call();
              }
            },
          ),
        ],
      );
    },
  );
}

void _showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void _showDialogSuccess(BuildContext context) async {
  final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WidgetDialog(
          title: _locale.info(),
          content: _locale.thankYouForTheFeedback(),
          actionsAlertDialog: [
            TextButton(
              child: Text(_locale.ok().toUpperCase()),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
          actionsCupertinoDialog: [
            CupertinoDialogAction(
              child: Text(_locale.ok()),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      });
  if (result != null) {
    Navigator.pop(context);
  }
}
