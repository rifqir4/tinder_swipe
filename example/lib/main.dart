import 'package:flutter/material.dart';
import 'package:tinder_swipe/tinder_swipe.dart';
// ignore: implementation_imports
import 'package:tinder_swipe/src/swipe_child.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TinderSwipeController<String> _controller =
      TinderSwipeController<String>();
  List<String> mylist = [
    "String 1",
    "String 2",
    "String 3",
    "String 4",
  ];

  @override
  void initState() {
    super.initState();
    _controller.addData(mylist);

    _controller.initCallback((status, length, data) {
      debugPrint(status.toString());
      debugPrint(length.toString());
      debugPrint(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Builder(
                builder: (_) {
                  final tinder = TinderSwipe<String>(
                    controller: _controller,
                    builder: (context, value, index, isFront) {
                      return Container(
                        width: double.infinity,
                        color: Colors.grey,
                        child: Column(
                          children: [
                            const Text("KARTU"),
                            Text(value),
                          ],
                        ),
                      );
                    },
                    enableCardSwipe: (value) {
                      if (value == 'String 2') return false;
                      return true;
                    },
                    swipingBadge: (status, data) {
                      var dataString =
                          status == CardStatus.like ? "PAKIT" : "MONJOWW";
                      debugPrint('data ${[status, data]}');
                      if (data is SwipeChild) {
                        dataString = '${[data.index, data.data]}';
                        if (data.data == 'String 2') return Container();
                      }

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: status == CardStatus.like
                                ? Colors.green
                                : Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          dataString,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: status == CardStatus.like
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      );
                    },
                  );

                  return tinder;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.dislike();
                },
                child: const Text("Dislike"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.removed(force: true);
                },
                child: const Text("Removed"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.rewind(prevData: "String 4");
                },
                child: const Text("Rewind"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.like();
                },
                child: const Text("Like"),
              ),
            ],
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
