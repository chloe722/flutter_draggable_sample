import 'package:flutter/material.dart';
import 'package:flutter_brunch/data.dart';
import 'package:flutter_brunch/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<Character, bool> accepted = Map();

  List<Character> shadowCharacters = [...characterList]..shuffle();
  List<Character> characters = [...characterList];

  reset() {
    setState(() {
      accepted.clear();
      shadowCharacters.shuffle();
      characters.shuffle();
    });
  }

  setAccept(Character val) {
    setState(() {
      accepted[val] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => reset(),
        child: Text('Reset'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GridView.extent(
              shrinkWrap: true,
              maxCrossAxisExtent: 200.0,
              children: shadowCharacters
                  .map((character) => DragTargetImage(
                        character: character,
                        accept: accepted[character] == true,
                        setAccept: setAccept,
                      ))
                  .toList()),
          GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: characters
                  .map((character) => DraggableImage(
                      character: character,
                      accept: accepted[character] == true))
                  .toList())
        ],
      ),
    );
  }
}

class DraggableImage extends StatefulWidget {
  DraggableImage({this.accept, this.character});

  bool accept;
  Character character;

  @override
  _DraggableImageState createState() => _DraggableImageState();
}

class _DraggableImageState extends State<DraggableImage> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: widget.accept
          ? Container(child: null)
          : ImageItem(
              image: widget.character.image,
            ),
      feedback: ImageItem(
        image: widget.character.image,
      ),
      childWhenDragging: Container(child: null),
      data: widget.character,
    );
  }
}

class DragTargetImage extends StatefulWidget {
  DragTargetImage({this.character, this.setAccept, this.accept});

  Character character;
  Function(Character) setAccept;
  bool accept;

  @override
  _DragTargetImageState createState() => _DragTargetImageState();
}

class _DragTargetImageState extends State<DragTargetImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(widget.character.shadowImage),
              fit: BoxFit.contain)),
      child: DragTarget(
        builder: (context, List<Character> candidatedatas, rejectedData) {
          return widget.accept
              ? ImageItem(
                  image: widget.character.image,
                )
              : Container(child: null);
        },
        onAccept: (data) {
          if (data == widget.character) {
            widget.setAccept(widget.character);
          }
        },
      ),
    );
  }
}

class ImageItem extends StatelessWidget {
  const ImageItem({Key key, this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.contain,
      width: 100.0,
      height: 100.0,
    );
  }
}
