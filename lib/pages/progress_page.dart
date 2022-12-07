import 'package:flutter/material.dart';
import 'package:golearnv2/components/app/custom_appbar.dart';
import 'package:golearnv2/configs/constants.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kAppBarHeight), child: CustomAppBar()),
    );
  }
}
