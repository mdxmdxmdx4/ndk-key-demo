import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:convert/convert.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hash Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('com.example.mylib/key_generator');
  String _key = "No key generated yet";

  Future<void> _generateKey() async {
    String key;
    try {
      final String result = await platform.invokeMethod('generateKey');
      key = result;
      List<String> stringBytes = result.substring(1, result.length - 1).split(", ");
      List<int> intBytes = stringBytes.map((s) => int.parse(s)).toList();
      List<int> byteBytes = intBytes.map((i) => i & 0xFF).toList();
      String hexString = hex.encode(byteBytes);
      key = hexString;
    } on PlatformException catch (e) {
      key = "Failed to generate key: '${e.message}'.";
    }

    setState(() {
      _key = key;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:Padding(
      padding: EdgeInsets.all(8.0),
        child:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_key',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 53),
                    backgroundColor:  Colors.deepPurple.shade100
                ),
                onPressed: _generateKey,
                child: Text('Generate Key')
            ),
          ],
        ),
      ),
      ),
    );
  }
}
