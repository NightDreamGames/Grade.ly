import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:gradely/UI/settings_route.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'Translation/i18n.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'Misc/storage.dart';
import 'Calculations/manager.dart';
import 'UI/default_theme.dart';
import 'UI/fade_page_route.dart';
import 'UI/popup_sub_menu.dart';
import 'UI/subject_route.dart';
import 'UI/title.dart';
import 'UI/view_state.dart';

void main() async {
  await Settings.init();

  // Compatibility.periodPreferences();

  /*switch (Preferences.getPreference("dark_theme", "auto")) {
            case "on":
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                break;
            case "off":
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                break;
            default:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                } else {
                    AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                }
                break;
        }*/

  await Manager.init();

  // Serialization.Deserialize();

  /*if (Preferences.getPreference("isFirstRun", "true") == "true") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubjectRoute()),
    ).then((value) {
                      rebuild();
                      print("AAAAAAAAAAA");
                    });
  }*/

  //Compatibility.init();

  Manager.calculate();

  runApp(
    MaterialApp(
      localizationsDelegates: const [
        I18nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: I18nDelegate.supportedLocals,
      theme: DefaultTheme.darkTheme,
      darkTheme: DefaultTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/subject': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  void rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    setOptimalDisplayMode();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      rebuild();
    }
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported.where((DisplayMode m) => m.width == active.width && m.height == active.height).toList()
      ..sort((DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode = sameResolution.isNotEmpty ? sameResolution.first : active;

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: I18n.of(context).more_options,
                onSelected: (value) {
                  if (value == "2") {
                    Navigator.pushNamed(
                      context,
                      "/settings",
                    ).then((value) {
                      rebuild();
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  List<String> a = [];

                  switch (Manager.maxTerm) {
                    case 2:
                      a = [
                        I18n.of(context).semester_1,
                        I18n.of(context).semester_2,
                        I18n.of(context).year,
                      ];
                      break;
                    case 3:
                      a = [
                        I18n.of(context).trimester_1,
                        I18n.of(context).trimester_2,
                        I18n.of(context).trimester_3,
                        I18n.of(context).year,
                      ];
                      break;
                  }

                  List<PopupMenuEntry<String>> entries = [];
                  if (Manager.maxTerm != 1) {
                    entries.add(
                      PopupSubMenuItem<String>(
                        title: I18n.of(context).select_term,
                        items: a,
                        onSelected: (value) async {
                          if (value == I18n.of(context).semester_1 || value == I18n.of(context).trimester_1) {
                            Manager.currentTerm = 0;
                          } else if (value == I18n.of(context).semester_2 || value == I18n.of(context).trimester_2) {
                            Manager.currentTerm = 1;
                          } else if (value == I18n.of(context).trimester_3) {
                            Manager.currentTerm = 2;
                          } else if (value == I18n.of(context).year) {
                            Manager.currentTerm = -1;
                          }

                          rebuild();
                        },
                      ),
                    );
                  }
                  entries.add(PopupSubMenuItem<String>(
                    title: I18n.of(context).sort_by,
                    items: [
                      I18n.of(context).az,
                      I18n.of(context).grade,
                    ],
                    onSelected: (value) {
                      if (value == I18n.of(context).az) {
                        Storage.setPreference<int>("sort_mode1", 0);
                      } else if (value == I18n.of(context).grade) {
                        Storage.setPreference<int>("sort_mode1", 1);
                      }

                      Manager.sortAll();
                      rebuild();
                    },
                  ));
                  entries.add(PopupMenuItem<String>(
                    value: "2",
                    onTap: () {},
                    child: Text(I18n.of(context).settings),
                  ));

                  return entries;
                },
              ),
            ],
            expandedHeight: 150,
            flexibleSpace: CustomizableSpaceBar(
              builder: (context, scrollingRate) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 24),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      getTitle(context),
                      style: TextStyle(
                        fontSize: 42 - 18 * scrollingRate,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 54,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              I18n.of(context).average,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          Manager.getCurrentTerm(context: context).getResult(),
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 0, color: Theme.of(context).dividerColor, thickness: 1),
                ),
              ],
            ),
          ),
          ListWidget(rebuild),
        ],
      ),
    );
  }
}

class ListWidget extends StatelessWidget {
  final Function function;

  const ListWidget(this.function, {Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListRow(index, function);
        },
        addAutomaticKeepAlives: true,
        childCount: Manager.getCurrentTerm(context: context).subjects.length,
      ),
    );
  }
}

class ListRow extends StatelessWidget {
  final int index;
  final Function function;
  const ListRow(this.index, this.function, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            /*Navigator.push(context, FadePageRoute(
              builder: (context) {
                return SubjectRoute(
                  subject: Manager.getCurrentTerm(context: context).subjects[index],
                );
              },
            )).then((_) => function());*/

            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: SubjectRoute(
                  subject: Manager.getCurrentTerm(context: context).subjects[index],
                ),
              ),
            ).then((_) => function());
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          title: /*Hero(
            tag: Manager.getCurrentTerm(context: context).subjects[index].name,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return DestinationTitle(
                title: Manager.getCurrentTerm(context: context).subjects[index].name,
                isOverflow: false,
                viewState: flightDirection == HeroFlightDirection.push ? ViewState.enlarge : ViewState.shrink,
                beginFontStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                endFontStyle: const TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
              );
            },
            child:*/
              DestinationTitle(
            title: Manager.getCurrentTerm(context: context).subjects[index].name,
            isOverflow: false,
            viewState: ViewState.shrunk,
            beginFontStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
            endFontStyle: const TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
            //),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*Hero(
                tag: "${Manager.getCurrentTerm(context: context).subjects[index].name}_result",
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return DestinationTitle(
                    title: Manager.getCurrentTerm(context: context).subjects[index].getResult(),
                    isOverflow: false,
                    viewState: flightDirection == HeroFlightDirection.push ? ViewState.enlarge : ViewState.shrink,
                    beginFontStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                    endFontStyle: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  );
                },
                child: */
              Text(
                Manager.getCurrentTerm(context: context).subjects[index].getResult(),
                style: const TextStyle(fontSize: 20.0),
                //),
              ),
              const Padding(padding: EdgeInsets.only(right: 24)),
              const Icon(
                Icons.navigate_next,
                size: 24.0,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: Theme.of(context).dividerColor),
        ),
      ],
    );
  }
}

String getTitle(var context) {
  switch (Manager.currentTerm) {
    case 0:
      switch (Manager.maxTerm) {
        case 3:
          return I18n.of(context).trimester_1;
        case 2:
          return I18n.of(context).semester_1;
        case 1:
          return I18n.of(context).year;
      }
      break;
    case 1:
      switch (Manager.maxTerm) {
        case 3:
          return I18n.of(context).trimester_2;
        case 2:
          return I18n.of(context).semester_2;
      }
      break;
    case 2:
      return I18n.of(context).trimester_3;
    case -1:
      return I18n.of(context).year;
  }

  return I18n.of(context).app_name;
}
