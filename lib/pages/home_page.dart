// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:golearnv2/animations/fade_in_animation.dart';
import 'package:golearnv2/components/app/progress_page/progress_tile.dart';
import 'package:golearnv2/components/home_page/topic_tile.dart';
import 'package:golearnv2/configs/constants.dart';
import 'package:golearnv2/data/extras.dart';
import 'package:golearnv2/data/words.dart';
import 'package:golearnv2/databases/database_manager.dart';
import 'package:golearnv2/notifiers/flashcards_notifier.dart';
import 'package:golearnv2/notifiers/review_notifier.dart';
import 'package:golearnv2/pages/review_page.dart';
import 'package:golearnv2/pages/settings_page.dart';
import 'package:golearnv2/utils/methods.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _topics = [];
  List<String> _extras = [];

//
// THIS IS THE CODE FOR GETTER OF THE TOPICS
  @override
  void initState() {
    DatabaseManager().getTopics().then((topics) {
      _topics = topics;
    });

    // DatabaseManager().getWordsOfTopic();

    // _topics.insertAll(0, ['Random 5', 'Random 20', 'Random 50', 'Test All']);

    super.initState();
// NEW ADDED
// THIS IS THE CODE FOR GETTER OF THE EXTRAA TOPICS
    // for (var e in extras) {
    //   if (!_extras.contains(e.extraword)) {
    //     _extras.add(e.extraword);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.04;
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('menuguide') == null) {
        runMenuGuide(context: context, isFirst: false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        //
        // THIS WILL BE THE APPBAR FOR THE HOMEPAGE
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        )),
        toolbarHeight: size.height * 0.10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<FlashcardsNotifier>(context, listen: false)
                        .setTopic(topic: 'Settings');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                  child: SizedBox(
                      width: size.width * 0.1,
                      child: Image.asset('assets/images/Settings.png')),
                ),
                SizedBox(
                  height: size.width * kIconPadding,
                )
              ],
            ),
            const FadeInAnimation(
              child: Text(
                'GoLearn',
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _loadReviewPage(context);
                  },
                  child: SizedBox(
                      width: size.width * 0.1,
                      child: Image.asset('assets/images/Review.png')),
                ),
                SizedBox(
                  height: size.width * kIconPadding,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
        child: CustomScrollView(
          slivers: [
            //
            //THIS IS THE MAIN LOGO OF THE APP
            SliverAppBar(
              backgroundColor: kWhite,
              expandedHeight: size.height * 0.40,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: FadeInAnimation(
                      child: Image.asset('assets/images/GoLearn.png')),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(3.0),
              sliver: SliverGrid(
                //
                //THIS IS THE GRID COUNT OF THE TOPIC TILES

                delegate: SliverChildBuilderDelegate(
                    childCount: _topics.length,
                    (context, index) => TopicTile(
                          topic: _topics[index],
                        )),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
              ),
            ),

            //THIS IS THE GRID COUNT OF THE EXTRA TOPIC TILES
            //NEW ADDED

            SliverPadding(
              padding: EdgeInsets.all(3.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: _extras.length,
                  ((context, index) => ProgressTile(
                        extra: _extras[index],
                      )),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loadReviewPage(BuildContext context) {
    Provider.of<FlashcardsNotifier>(context, listen: false)
        .setTopic(topic: 'Review');
    final reviewNotifier = Provider.of<ReviewNotifier>(context, listen: false);
    reviewNotifier.disableButtons(disable: false);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReviewPage()));
  }
}
