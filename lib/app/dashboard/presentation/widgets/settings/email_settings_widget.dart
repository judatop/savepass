import 'package:flutter/material.dart';
import 'package:savepass/main.dart';

class EmailSettingsWidget extends StatelessWidget {
  const EmailSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          supabase.auth.currentUser?.email ?? '',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
