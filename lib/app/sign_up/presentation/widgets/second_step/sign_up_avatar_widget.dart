import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_bloc.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';

class SignUpAvatarWidget extends StatefulWidget {
  const SignUpAvatarWidget({super.key});

  @override
  State<SignUpAvatarWidget> createState() => _SignUpAvatarWidgetState();
}

class _SignUpAvatarWidgetState extends State<SignUpAvatarWidget> {
  void _onTapUploadPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bloc = Modular.get<SignUpBloc>();
      bloc.add(AvatarChangedEvent(imagePath: image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.model.selectedImg != current.model.selectedImg,
      builder: (context, state) {
        final imagePath = state.model.selectedImg;

        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              imagePath != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(imagePath)),
                      radius: 75,
                    )
                  : CircleAvatar(
                      radius: 75,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(
                        Icons.person,
                        size: 75,
                        color: Colors.white,
                      ),
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: AdsFilledRoundIconButton(
                  onPressedCallback: _onTapUploadPhoto,
                  icon: const Icon(
                    Icons.upload,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
