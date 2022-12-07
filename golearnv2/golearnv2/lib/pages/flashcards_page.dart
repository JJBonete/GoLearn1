// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:golearnv2/components/app/custom_appbar.dart';
import 'package:golearnv2/components/flashcards_page/card_1.dart';
import 'package:golearnv2/components/flashcards_page/card_2.dart';
import 'package:golearnv2/components/flashcards_page/progress_bar.dart';
import 'package:golearnv2/configs/constants.dart';
import 'package:golearnv2/utils/methods.dart';
import 'package:provider/provider.dart';
import 'package:golearnv2/notifiers/flashcards_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

//THIS IS THE CODE FOR THE FLASHCARDS PAGE

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final flashcardsNotifier =
          Provider.of<FlashcardsNotifier>(context, listen: false);
      flashcardsNotifier.runSlideCard1();
      flashcardsNotifier.generateAllSelectedWords();
      flashcardsNotifier.generateCurrentWord(context: context);
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool('guidebox') == null) {
          runGuideBox(context: context, isFirst: true);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kAppBarHeight),
              child: CustomAppBar()),
          body: IgnorePointer(
            ignoring: notifier.ignoreTouches,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 5, 8, 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'assets/images/Wrong.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 50, 5),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/images/Check.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Card2(),
                Card1(),
                Align(alignment: Alignment.topCenter, child: ProgressBar()),
              ],
            ),
          )),
    );
  }
}
