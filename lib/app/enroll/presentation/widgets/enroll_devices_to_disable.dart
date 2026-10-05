import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_bloc.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_event.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_state.dart';

class EnrollDevicesToDisable extends StatelessWidget {
  const EnrollDevicesToDisable({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<EnrollBloc>();
    final textTheme = Theme.of(context).textTheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<EnrollBloc, EnrollState>(
      buildWhen: (previous, current) =>
          (previous.model.devices != current.model.devices),
      builder: (context, state) {
        final devices = state.model.devices;

        if (devices.isEmpty) {
          return Container();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: devices.length,
          separatorBuilder: (_, __) =>
               SizedBox(height: deviceHeight * 0.01),
          itemBuilder: (context, index) {
            final e = devices[index];

            return AdsCard(
              onTap: () => bloc.add(
                EnrollNewDeviceEvent(deviceId: e.deviceId),
              ),
              child: Padding(
                padding:  EdgeInsets.all(deviceWidth * 0.035),
                child: Row(
                  children: [
                    Icon(e.type == 'Android' ? Icons.android : Icons.apple),
                    Text(
                      '  ${e.deviceName}',
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
