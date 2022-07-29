import 'package:flutter/material.dart';
import 'package:tinder_swipe/tinder_swipe.dart';

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
  final SwipeController _controller = SwipeController();
  List<String> mylist = [
    "String 1",
    "String 2",
    "String 3",
    "String 4",
  ];

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
              child: TinderSwipe<String>(
                controller: _controller,
                // data: mylist,
                builder: (context, value, index) {
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
                callback: (CardStatus status, int length, dynamic data) {
                  debugPrint(status.toString());
                  debugPrint(length.toString());
                },
                swipingBadge: (status) {
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
                      status == CardStatus.like ? "PAKIT" : "MONJOWW",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status == CardStatus.like
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.addData([
                    "String 9",
                    "String 8",
                  ].toList());
                },
                child: const Text("Dislike"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.rewind("String 4");
                },
                child: const Text("Rewind"),
              ),
              ElevatedButton(
                onPressed: () {
                  // _controller.like();
                  _controller.clearData();
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
