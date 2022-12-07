// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:golearnv2/animations/fade_in_animation.dart';
import 'package:golearnv2/configs/constants.dart';
import 'package:golearnv2/utils/methods.dart';

class ProgressTile extends StatelessWidget {
  const ProgressTile({Key? key, required this.extra}) : super(key: key);

  final String extra;

  //THIS IS THE CODE FOR THE LOOK OF THE TILES IN THE MENUN

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: GestureDetector(
        onTap: () {
          print('tile tapped $extra');
          loadSession(context: context, topic: extra);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(kCircularBorderRadious)),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Hero(
                        tag: extra,
                        child: Image.asset('assets/images/$extra.png')),
                  )),
              Expanded(
                child: Text(
                  extra,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
