import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sow_remember/routers.dart';
import 'package:sow_remember/screen/word_list.dart';
import 'package:sow_remember/bloc/user_bloc.dart';

import '../service/user_service.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({Key? key}) : super(key: key);

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _MenuModel {
  final String title;
  final String description;
  final Color color;
  final int qty;
  final Widget icon;
  final String route;
  final String key;
  final double paddingTop;

  _MenuModel(
      {required this.title,
      required this.description,
      required this.color,
      required this.key,
      required this.paddingTop,
      required this.route,
      required this.icon,
      required this.qty});
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  List<_MenuModel> menu = [
    _MenuModel(
        title: 'Verbos regulares',
        description: 'Agrega los verbos regulares',
        color: Colors.purple,
        qty: 5,
        icon: Lottie.asset('assets/animations/110457-notes-document.json',
            width: 150.0, height: 150.0, repeat: true),
        route: '',
        key: 'REMINDER',
        paddingTop: -70),
    _MenuModel(
        title: 'Verbos irregulares',
        description: 'Agrega los verbos irregulares',
        color: Colors.blueAccent,
        qty: 5,
        icon: Lottie.asset('assets/animations/110457-notes-document.json',
            width: 150.0, height: 150.0, repeat: true),
        route: '',
        key: 'REMINDER',
        paddingTop: -70),
    _MenuModel(
        title: 'Alarmas',
        description: 'Programa tus recordatorios',
        color: Colors.red,
        qty: 5,
        icon: Lottie.asset('assets/animations/reminder_animation.json',
            width: 100.0, height: 100.0, repeat: true),
        route: '',
        key: 'REMINDER',
        paddingTop: -55),
    _MenuModel(
        title: 'Palabras en inglés',
        description: 'Agrega tus palabras en inglés y traducelas',
        color: Colors.orange,
        qty: 190,
        icon: Lottie.asset('assets/animations/light2.json',
            width: 90.0, height: 90.0, fit: BoxFit.fill, repeat: true),
        // Icon(
        //   Icons.lightbulb,
        //   size: 90.0,
        //   color: Colors.yellow,
        // ),
        route: Routers.createWord,
        key: 'WORD',
        paddingTop: -50),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              children: [
                Text(
                  'Hola ${context.watch<UserBloc>().username}',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                const Icon(Icons.waving_hand_sharp)
              ],
            ),
            centerTitle: false,
            pinned: true,
            toolbarHeight: 90.0,
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      UserService.logout();
                      Navigator.pushReplacementNamed(context, Routers.login);
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 35.0,
                    )),
              )
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 50.0,
                  crossAxisSpacing: 16),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if (menu[index].key == 'WORD') {
                        showBottomSheetUtil(context,
                            buildDraggable((_, controller) {
                          return const BottomSheetBorder(
                            child: WordListScreen(),
                          );
                        }));
                      }
                    },
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: menu[index].color,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                spreadRadius: 1.0,
                                offset: Offset(4.0, 4.0),
                              ),
                            ],
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 4.0, right: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  menu[index].title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  menu[index].description,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                menu[index].key == 'WORD'
                                    ? countWord()
                                    : Text(
                                        0.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: menu[index].route.isEmpty
                                    ? null
                                    : () => Navigator.pushNamed(
                                        context, menu[index].route),
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: menu[index].paddingTop,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: menu[index].icon,
                              )),
                        ),
                      ],
                    ),
                  );
                },
                childCount: menu.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget countWord() {
    print(UserService.getUserId());
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('WordMeaning')
          //.where('user_id', isEqualTo: UserService.getUserId())
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        return Text(
          textAlign: TextAlign.center,
          '${snapshot.hasData ? snapshot.data!.docs.length : 0}',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
        );
      },
    );
  }
}

Future<dynamic> showBottomSheetUtil(BuildContext context, Widget widget,
    {bool isScrollControlled = true, bool enableDrag = true}) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return widget;
    },
  );
}

class BottomSheetBorder extends StatelessWidget {
  final Widget child;

  const BottomSheetBorder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: child,
    );
  }
}

Widget buildDraggable(ScrollableWidgetBuilder scrollableWidgetBuilder,
    {double initialChildSize = 0.95, double maxChildSize = 0.95}) {
  return DraggableScrollableSheet(
    initialChildSize: initialChildSize,
    minChildSize: 0.2,
    maxChildSize: maxChildSize,
    builder: scrollableWidgetBuilder,
  );
}

Widget buildBottomSheetLine() {
  return Column(
    children: [
      const SizedBox(
        height: 12.0,
      ),
      Center(
        child: Container(
          width: 40.0,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey[300],
          ),
        ),
      ),
      const SizedBox(
        height: 12.0,
      ),
    ],
  );
}
