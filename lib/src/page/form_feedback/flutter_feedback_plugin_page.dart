import 'dart:io';

import 'package:coderjava_image_editor_pro/coderjava_image_editor_pro.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feedback/localization/en_message.dart';
import 'package:flutter_feedback/localization/id_message.dart';
import 'package:flutter_feedback/localization/lookup_message.dart';
import 'package:flutter_feedback/src/data/model/device_logs/device_logs.dart';
import 'package:flutter_feedback/src/widget/widget_dialog.dart';
import 'package:flutter_feedback/src/widget/widget_edit_device_logs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../preview_image/flutter_feedback_preview_image_page.dart';

/// Listener untuk menampilkan loading atau tidak
final _valueListenableLoading = ValueNotifier<bool>(false);

/// Warna primary dari identitas app Anda
late Color _colorPrimary;

/// Callback function ketika respon kode dari API adalah 401
Function()? _onDialog401Showing;

/// Localization untuk bahasa yang digunakan di halaman ini
late LookupMessage _locale;

/// Alias function ketika button `SEND` ditekan
typedef _OnSubmitFeedback = void Function(
  List<String> listScreenshots,
  String category,
  String description,
  DeviceLogs deviceLogs,
);

/// Halaman ini berfungsi untuk menampilkan form feedback.
class FormFeedbackController {
  void submitFeedback() {
    _valueListenableLoading.value = true;
  }

  /// Action ketika gagal kirim feedback
  void failureFeedback(
    BuildContext context,
    String errorMessage, {
    SnackBarBehavior? snackBarBehavior,
    EdgeInsetsGeometry? snackBarMargin,
    Color? snackbarBackgroundColor,
  }) {
    _valueListenableLoading.value = false;
    if (errorMessage.contains('401')) {
      _showDialog401(context);
      return;
    }
    _showSnackBar(
      context,
      errorMessage,
      snackBarBehavior: snackBarBehavior,
      snackbarBackgroundColor: snackbarBackgroundColor,
      snackBarMargin: snackBarMargin,
    );
  }

  /// Action ketika berhasil kirim feedback
  void successFeedback(BuildContext context) {
    _valueListenableLoading.value = false;
    _showDialogSuccess(context);
  }
}

class FlutterFeedbackPluginPage extends StatefulWidget {
  /// Hasil file screenshot
  final File fileScreenshot;

  /// Callback ketika button `SEND` ditekan
  final _OnSubmitFeedback onSubmitFeedback;

  /// Username yang sedang login
  final String username;

  /// Label username
  final String labelUsername;

  /// Nilai version name dari app
  final String appVersion;

  /// Warna primary dari identitas app Anda.
  final Color colorPrimary;

  /// Warna secondary dari identitas app Anda.
  final Color colorSecondary;

  /// Warna dari widget [AppBar]. Nilai default-nya [Colors.blue]
  final Color colorAppBar;

  /// List action yang didalam [AppBar].
  final List<Widget>? actionAppBar;

  /// Warna dari tulisan didalam widget [AppBar]. Nilai default-nya adalah [Colors.grey.shade700]
  final Color? colorTitleAppBar;

  /// Function yang dijalankan ketika respon kode dari API 401.
  final Function()? onDialog401Showing;

  /// Bahasa yang dipakai di halaman ini. Untuk saat ini support `en` dan `id`.
  final String locale;

  /// Style dari button send.
  final ButtonStyle? buttonSendStyle;

  /// Child dari button send.
  final Widget? childButtonSend;

  /// Height dari button send.
  final double? heightButtonSend;

  /// Warna background di SnackBar
  final Color? snackBarErrorBackgroundColor;

  /// Behavior snackbar
  final SnackBarBehavior? snackbarBehavior;

  /// Margin untuk snackbar
  final EdgeInsetsGeometry? snackbarMargin;

  /// Widget untuk ditempatkan paling atas di form nya
  final List<Widget>? headerWidgets;

  FlutterFeedbackPluginPage({
    required this.fileScreenshot,
    required this.onSubmitFeedback,
    required this.username,
    required this.labelUsername,
    required this.appVersion,
    this.colorPrimary = Colors.blue,
    this.colorSecondary = Colors.white,
    this.colorAppBar = Colors.blue,
    this.actionAppBar,
    this.colorTitleAppBar,
    this.onDialog401Showing,
    this.locale = 'en',
    this.buttonSendStyle,
    this.childButtonSend,
    this.heightButtonSend,
    this.snackBarErrorBackgroundColor,
    this.snackbarBehavior,
    this.snackbarMargin,
    this.headerWidgets,
  }) {
    _colorPrimary = this.colorPrimary;
    _onDialog401Showing = this.onDialog401Showing;
  }

  @override
  _FlutterFeedbackPluginPageState createState() =>
      _FlutterFeedbackPluginPageState();
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
  var platform = '';
  var osVersion = '';
  var brand = '';
  var isCheckUsername = true;
  var isCheckAppVersion = true;
  var isCheckPlatform = true;
  var isCheckOsVersion = true;
  var isCheckBrand = true;

  @override
  void initState() {
    listAttachments.add(widget.fileScreenshot.path);
    listAttachments.add('');
    _initLocale();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        platform = 'Android';
        osVersion = androidInfo.version.sdkInt.toString();
        brand = (androidInfo.brand) + ' ' + (androidInfo.model);
        if (brand.trim().isEmpty) {
          brand = '-';
        }
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        platform = 'IOS';
        osVersion = iosInfo.systemVersion;
        brand = (iosInfo.model) + ' (' + (iosInfo.name) + ')';
      }
    });
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
        actions: widget.actionAppBar,
        backgroundColor: widget.colorAppBar,
        iconTheme:
            IconThemeData(color: widget.colorTitleAppBar ?? Colors.grey[700]),
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
                ...widget.headerWidgets ?? [],
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
                                  final chooseAddAttachment =
                                      await showModalBottomSheet(
                                    context: context,
                                    enableDrag: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: paddingBottom > 0
                                              ? paddingBottom
                                              : 8,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 2,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              _locale.addPhoto(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[700],
                                              ),
                                              title: Text(
                                                _locale.camera(),
                                              ),
                                              onTap: () {
                                                Navigator.pop(
                                                    context, 'camera');
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.photo,
                                                color: Colors.grey[700],
                                              ),
                                              title: Text(
                                                _locale.gallery(),
                                              ),
                                              onTap: () {
                                                Navigator.pop(
                                                    context, 'gallery');
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ) as String?;
                                  if (chooseAddAttachment != null) {
                                    if (chooseAddAttachment == 'camera') {
                                      final pickedImageCamera =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 30,
                                      );
                                      if (pickedImageCamera != null) {
                                        listAttachments.removeLast();
                                        listAttachments
                                            .add(pickedImageCamera.path);
                                        listAttachments.add('');
                                        if (listAttachments.length > 3) {
                                          listAttachments.removeLast();
                                        }
                                        setState(() {});
                                      }
                                    } else if (chooseAddAttachment ==
                                        'gallery') {
                                      final pickedImageGallery =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 30,
                                      );
                                      if (pickedImageGallery != null) {
                                        listAttachments.removeLast();
                                        listAttachments
                                            .add(pickedImageGallery.path);
                                        listAttachments.add('');
                                        if (listAttachments.length > 3) {
                                          listAttachments.removeLast();
                                        }
                                        setState(() {});
                                      }
                                    }
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
                                      _doTapImage(index, pathImage);
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
                                      _doTapImage(index, pathImage);
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
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    var editDeviceLogs = await showModalBottomSheet<DeviceLogs>(
                        context: context,
                        enableDrag: false,
                        isDismissible: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return WidgetEditDeviceLogs(
                            locale: _locale,
                            paddingBottom: paddingBottom,
                            deviceLogs: DeviceLogs(
                              username: widget.username,
                              labelUsername: widget.labelUsername,
                              isCheckUsername: isCheckUsername,
                              appVersion: widget.appVersion,
                              isCheckAppVersion: isCheckAppVersion,
                              platform: platform,
                              isCheckPlatform: isCheckPlatform,
                              osVersion: osVersion,
                              isCheckOsVersion: isCheckOsVersion,
                              brand: brand,
                              isCheckBrand: isCheckBrand,
                            ),
                            colorPrimary: widget.colorPrimary,
                          );
                        });
                    if (editDeviceLogs != null) {
                      setState(() {
                        isCheckUsername = editDeviceLogs.isCheckUsername;
                        isCheckAppVersion = editDeviceLogs.isCheckAppVersion;
                        isCheckPlatform = editDeviceLogs.isCheckPlatform;
                        isCheckOsVersion = editDeviceLogs.isCheckOsVersion;
                        isCheckBrand = editDeviceLogs.isCheckBrand;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _locale.deviceLogs(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                _setDataDeviceLogs(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _locale.edit(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: widget.colorPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.fileLines,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
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
                    _buildWidgetChoiceChip(_locale.suggestion(), _locale.suggestionValue()),
                    _buildWidgetChoiceChip(_locale.appreciation(), _locale.appreciationValue()),
                    _buildWidgetChoiceChip(_locale.complain(), _locale.complainValue()),
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
                      return value == null || value.isEmpty
                          ? _locale.enterYourFeedback()
                          : null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: widget.heightButtonSend,
            child: ElevatedButton(
              onPressed: () {
                if (listAttachments.length == 1 &&
                    listAttachments.first.isEmpty) {
                  _showSnackBar(
                    context,
                    _locale.pleaseUploadScreenshot(),
                    snackBarBehavior: widget.snackbarBehavior,
                    snackbarBackgroundColor:
                        widget.snackBarErrorBackgroundColor,
                    snackBarMargin: widget.snackbarMargin,
                  );
                  return;
                } else if (selectedCategory.isEmpty) {
                  _showSnackBar(
                    context,
                    _locale.pleaseSelectFeedbackCategory(),
                    snackBarBehavior: widget.snackbarBehavior,
                    snackbarBackgroundColor:
                        widget.snackBarErrorBackgroundColor,
                    snackBarMargin: widget.snackbarMargin,
                  );
                  return;
                } else if (formState.currentState!.validate()) {
                  widget.onSubmitFeedback.call(
                    listAttachments,
                    selectedCategory,
                    controllerFeedback.text.trim(),
                    DeviceLogs(
                      username: widget.username,
                      labelUsername: widget.labelUsername,
                      isCheckUsername: isCheckUsername,
                      appVersion: widget.appVersion,
                      isCheckAppVersion: isCheckAppVersion,
                      platform: platform,
                      isCheckPlatform: isCheckPlatform,
                      osVersion: osVersion,
                      isCheckOsVersion: isCheckOsVersion,
                      brand: brand,
                      isCheckBrand: isCheckBrand,
                    ),
                  );
                }
              },
              style: widget.buttonSendStyle ??
                  ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: widget.colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
              child: widget.childButtonSend ??
                  Text(
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

  String _setDataDeviceLogs() {
    final listDeviceLogs = <String>[];
    var strDeviceLogs = '';
    if (isCheckUsername) {
      listDeviceLogs.add(widget.labelUsername);
    }
    if (isCheckAppVersion) {
      listDeviceLogs.add(_locale.appVersion());
    }
    if (isCheckPlatform) {
      listDeviceLogs.add(_locale.platform());
    }
    if (isCheckOsVersion) {
      listDeviceLogs.add(_locale.osVersion());
    }
    if (isCheckBrand) {
      listDeviceLogs.add(_locale.brand());
    }
    if (listDeviceLogs.isEmpty) {
      strDeviceLogs = _locale.noLogData();
      return strDeviceLogs;
    } else if (listDeviceLogs.length == 1) {
      strDeviceLogs = listDeviceLogs.first;
      return strDeviceLogs;
    } else if (listDeviceLogs.length == 2) {
      strDeviceLogs = listDeviceLogs.join(' ' + _locale.and() + ' ');
      return strDeviceLogs;
    }
    listDeviceLogs.insert(listDeviceLogs.length - 1, _locale.and());
    strDeviceLogs = listDeviceLogs
        .join(', ')
        .replaceAll(_locale.and() + ',', _locale.and());
    return strDeviceLogs;
  }

  void _doTapImage(int index, String pathImage) async {
    var actionAttachment;
    if (Platform.isIOS) {
      actionAttachment = await showCupertinoModalPopup<String>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text(
                    _locale.viewScreenshot(),
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => Navigator.pop(context, 'view'),
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    _locale.editScreenshot(),
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => Navigator.pop(context, 'edit'),
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    _locale.deleteScreenshot(),
                    style: TextStyle(color: Colors.red),
                  ),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, 'delete'),
                ),
              ],
            );
          });
    } else {
      actionAttachment = await showModalBottomSheet<String>(
        context: context,
        enableDrag: false,
        builder: (context) {
          return _buildWidgetMenuActionAttachment(pathImage);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      );
    }
    if (actionAttachment != null) {
      if (actionAttachment == 'edit') {
        _doEditImage(index);
      } else if (actionAttachment == 'delete') {
        listAttachments.removeAt(index);
        if (listAttachments.last.isNotEmpty) {
          listAttachments.add('');
        }
        setState(() {});
      } else if (actionAttachment == 'view') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlutterFeedbackPreviewImagePage(pathImage),
          ),
        );
      }
    }
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

  Widget _buildWidgetMenuActionAttachment(String pathImage) {
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
            style: Theme.of(context).textTheme.titleSmall,
          ),
          ListTile(
            leading: Icon(
              Icons.photo,
              color: Colors.grey[700],
            ),
            title: Text(_locale.viewScreenshot()),
            onTap: () {
              Navigator.pop(context, 'view');
            },
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

  Widget _buildWidgetChoiceChip(String label, String value) {
    final isSelected = value == selectedCategory;
    return ChoiceChip(
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? widget.colorPrimary : Colors.grey,
          ),
      selected: isSelected,
      onSelected: (_) => setState(() {
        selectedCategory = value;
      }),
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
          defaultPickerColor: widget.colorPrimary,
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
    } else {
      _locale = EnMessage();
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
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: _colorPrimary),
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

void _showSnackBar(
  BuildContext context,
  String text, {
  SnackBarBehavior? snackBarBehavior,
  EdgeInsetsGeometry? snackBarMargin,
  Color? snackbarBackgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: snackBarBehavior,
      margin: snackBarMargin,
      backgroundColor: snackbarBackgroundColor,
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
