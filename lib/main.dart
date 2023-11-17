import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paint calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Paint calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var key = GlobalKey<FormState>();
  final TextEditingController heightCtrl = TextEditingController();
  final TextEditingController lengthCtrl = TextEditingController();
  final TextEditingController gallonPerFeetCtrl = TextEditingController();
  final TextEditingController capCanCtrl = TextEditingController();
  var calcRes = 0.0;
  var cansCount = 0;
  var paintColorIndex = 0;

  setColor(int index) {
    setState(() {
      paintColorIndex = index;
    });
  }

  @override
  void initState() {
    gallonPerFeetCtrl.text = '150';
    capCanCtrl.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              const SizedBox(height: 26.0),
              MainHeader('Select color'),
              const SizedBox(height: 16.0),
              ColorSelector(setColor),
              const SizedBox(height: 16.0),
              Divider(),
              const SizedBox(height: 16.0),
              MainHeader('Room dimensions, feet'),
              const SizedBox(height: 16.0),
              Form(
                key: key,
                child: Column(children: [
                  TextFieldDecor(
                    TextFormField(
                      controller: heightCtrl,
                      validator: _validator,
                      keyboardType: TextInputType.number,
                      // maxLength: 30,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Room height, feet',
                        hintStyle: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFieldDecor(
                    TextFormField(
                      controller: lengthCtrl,
                      validator: _validator,
                      keyboardType: TextInputType.number,
                      // maxLength: 30,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Length of all walls, feet',
                        hintStyle: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Divider(),
                  const SizedBox(height: 16.0),
                  MainHeader('Feet per one gallon'),
                  const SizedBox(height: 16.0),
                  TextFieldDecor(
                    TextFormField(
                      controller: gallonPerFeetCtrl,
                      validator: _validator,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Feet per one gallon',
                        hintStyle: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  MainHeader('Capacity of one can, gallons'),
                  const SizedBox(height: 16.0),
                  TextFieldDecor(
                    TextFormField(
                      controller: capCanCtrl,
                      validator: _validator,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Capacity of one can, gallons',
                        hintStyle: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calc,
                child: Text('Calculate'),
              ),
              Divider(),
              const SizedBox(height: 16.0),
              MainHeader('Result: ${calcRes.toStringAsFixed(2)}, gallons'),
              const SizedBox(height: 16.0),
              MainHeader(
                'Buy: $cansCount, cans of ${capCanCtrl.text} gallon(s)',
                color: colorsList[paintColorIndex],
              ),
            ]),
          ),
        ));
  }

  String? _validator(String? val) {
    var res = double.tryParse(val ?? '');
    if (res == null) {
      return 'Enter valid number';
    }
    return null;
  }

  _calc() {
    var valid = key.currentState!.validate();
    if (!valid) {
      return;
    }
    var h = double.tryParse(heightCtrl.text);
    var l = double.tryParse(lengthCtrl.text);
    var g = double.tryParse(gallonPerFeetCtrl.text);
    var c = double.tryParse(capCanCtrl.text);

    if (h != null && l != null && g != null && c != null) {
      setState(() {
        calcRes = h * l / g;
        cansCount = (calcRes / c).ceil();
      });
    }
  }
}

class MainHeader extends StatelessWidget {
  final String text;
  final bool isCenter;
  final Color color;
  const MainHeader(this.text,
      {this.isCenter = false, this.color = const Color(0xff808080)});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
          isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 26.0, fontWeight: FontWeight.w700, color: color),
          ),
        )
      ],
    );
  }
}

class ColorSelector extends StatefulWidget {
  final Function setColor;
  const ColorSelector(this.setColor, {super.key});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 14.0),
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(left: 14),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: colorsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: 30,
                height: 30,
                color: colorsList[index],
                child: selected == index
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : null,
              ),
              onTap: () {
                setState(() {
                  selected = index;
                });
                widget.setColor(index);
              },
            );
          },
        ),
      ),
    );
  }
}

const colorsList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.brown
];

class TextFieldDecor extends StatelessWidget {
  final Widget child;
  const TextFieldDecor(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(
          color: const Color(0xffE8E8E8),
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: child,
    );
  }
}
