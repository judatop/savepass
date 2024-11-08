import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPermissionScreen extends StatefulWidget {
  final void Function() callbackIfSuccess;

  const PhotoPermissionScreen({super.key, required this.callbackIfSuccess});

  @override
  State<PhotoPermissionScreen> createState() => _PhotoPermissionScreenState();
}

class _PhotoPermissionScreenState extends State<PhotoPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<AndroidDeviceInfo> _getAndroidInfo() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo;
  }

  Future<PermissionStatus> _getStatus() async {
    PermissionStatus status;

    if (Platform.isIOS) {
      status = await Permission.photos.status;
      return status;
    }

    final androidInfo = await _getAndroidInfo();
    if (androidInfo.version.sdkInt <= 32) {
      status = await Permission.storage.status;
    } else {
      status = await Permission.photos.status;
    }

    return status;
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidInfo();
      if (androidInfo.version.sdkInt <= 32) {
        Permission.storage.request().then((value) {
          if (value.isGranted) {
            _goBack();
          }
        });
        return;
      }
    }

    Permission.photos.request().then((value) {
      if (value.isGranted) {
        _goBack();
      }
    });
  }

  void _onTapRequest() async {
    final status = await _getStatus();
    if (status.isGranted) {
      _goBack();
      return;
    }

    if (status.isPermanentlyDenied && mounted) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const _PermanentDeniedAccess();
        },
      );
      return;
    }

    _requestPermission();
  }

  void _goBack() {
    Modular.to.pop();
    widget.callbackIfSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final intl = AppLocalizations.of(context)!;

    return AdsScreenTemplate(
      goBack: true,
      wrapScroll: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: deviceHeight * 0.1),
                  ScaleTransition(
                    scale: _animation,
                    child: Icon(
                      Icons.photo_library,
                      size: deviceWidth * 0.35,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.05),
                  AdsHeadline(
                    text: intl.photoAccessTitle,
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  Text(
                    intl.photoAccessText,
                    style: const TextStyle(
                      fontSize: 16.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceHeight * 0.05),
          AdsFilledButton(
            onPressedCallback: _onTapRequest,
            text: intl.photoAccessButton,
          ),
        ],
      ),
    );
  }
}

class _PermanentDeniedAccess extends StatelessWidget {
  const _PermanentDeniedAccess();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(intl.permanentTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                intl.permanentText,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          AdsFilledButton(
            onPressedCallback: () {
              Modular.to.pop();
              Modular.to.pop();
            },
            text: intl.permanentButton,
          ),
        ],
      ),
    );
  }
}
