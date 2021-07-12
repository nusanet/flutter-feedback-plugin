import 'package:flutter/material.dart';
import 'package:flutter_feedback/localization/lookup_message.dart';
import 'package:flutter_feedback/src/data/model/device_logs/device_logs.dart';

class WidgetEditDeviceLogs extends StatefulWidget {
  final LookupMessage locale;
  final double paddingBottom;
  final DeviceLogs deviceLogs;
  final Color colorPrimary;

  WidgetEditDeviceLogs({
    required this.locale,
    required this.paddingBottom,
    required this.deviceLogs,
    required this.colorPrimary,
  });

  @override
  _WidgetEditDeviceLogsState createState() => _WidgetEditDeviceLogsState();
}

class _WidgetEditDeviceLogsState extends State<WidgetEditDeviceLogs> {
  var isCheckEmail = false;
  var isCheckAppVersion = false;
  var isCheckPlatform = false;
  var isCheckOsVersion = false;
  var isCheckBrand = false;

  @override
  void initState() {
    isCheckEmail = widget.deviceLogs.isCheckEmail;
    isCheckAppVersion = widget.deviceLogs.isCheckAppVersion;
    isCheckPlatform = widget.deviceLogs.isCheckPlatform;
    isCheckOsVersion = widget.deviceLogs.isCheckOsVersion;
    isCheckBrand = widget.deviceLogs.isCheckBrand;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        bottom: widget.paddingBottom > 0 ? widget.paddingBottom : 8,
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
            widget.locale.deviceLogs(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          _buildItemDeviceLog(
            isCheckEmail,
            widget.locale.email(),
            widget.deviceLogs.email,
            (isChecked) => setState(() => isCheckEmail = !isCheckEmail),
          ),
          _buildItemDeviceLog(
            isCheckAppVersion,
            widget.locale.appVersion(),
            widget.deviceLogs.appVersion,
            (isChecked) => setState(() => isCheckAppVersion = !isCheckAppVersion),
          ),
          _buildItemDeviceLog(
            isCheckPlatform,
            widget.locale.platform(),
            widget.deviceLogs.platform,
            (isChecked) => setState(() => isCheckPlatform = !isCheckPlatform),
          ),
          _buildItemDeviceLog(
            isCheckOsVersion,
            widget.locale.osVersion(),
            widget.deviceLogs.osVersion,
            (isChecked) => setState(() => isCheckOsVersion = !isCheckOsVersion),
          ),
          _buildItemDeviceLog(
            isCheckBrand,
            widget.locale.brand(),
            widget.deviceLogs.brand,
            (isChecked) => setState(() => isCheckBrand = !isCheckBrand),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text(widget.locale.cancel().toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: widget.colorPrimary,
                      side: BorderSide(
                        color: widget.colorPrimary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    child: Text(widget.locale.save().toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      primary: widget.colorPrimary,
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        DeviceLogs(
                          email: widget.deviceLogs.email,
                          isCheckEmail: isCheckEmail,
                          appVersion: widget.deviceLogs.appVersion,
                          isCheckAppVersion: isCheckAppVersion,
                          platform: widget.deviceLogs.platform,
                          isCheckPlatform: isCheckPlatform,
                          osVersion: widget.deviceLogs.osVersion,
                          isCheckOsVersion: isCheckOsVersion,
                          brand: widget.deviceLogs.brand,
                          isCheckBrand: isCheckBrand,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDeviceLog(
    bool isChecked,
    String label,
    String value,
    Function(bool? isChecked) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          fillColor: MaterialStateProperty.all(widget.colorPrimary),
          checkColor: Colors.white,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              onChanged.call(!isChecked);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.grey,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
