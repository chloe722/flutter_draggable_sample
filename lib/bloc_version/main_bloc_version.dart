import 'package:flutter/material.dart';
import 'package:flutter_brunch/bloc_version/home_bloc.dart';
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
  HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = HomeBloc();
    super.initState();
  }

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => homeBloc.reset(),
          child: Text('Reset'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<List<CharacterContainer>>(
                stream: homeBloc.shadowCharacters,
                builder: (context, snapshot) {
                  return snapshot.data != null && snapshot.hasData
                      ? GridView.extent(
                          shrinkWrap: true,
                          maxCrossAxisExtent: 200.0,
                          children: snapshot.data
                              .map((i) => DragTargetImage(
                                  characterContainer: i, bloc: homeBloc))
                              .toList())
                      : Container(child: null);
                }),
            StreamBuilder<List<CharacterContainer>>(
                stream: homeBloc.characters,
                builder: (context, snapshot) {
                  return snapshot.data != null && snapshot.hasData
                      ? GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: snapshot.data
                              .map((i) => DraggableImage(
                                  characterContainer: i, bloc: homeBloc))
                              .toList())
                      : Container(child: null);
                })
          ],
        ));
  }
}

class DraggableImage extends StatefulWidget {
  DraggableImage({this.bloc, this.characterContainer});

  HomeBloc bloc;
  CharacterContainer characterContainer;

  @override
  _DraggableImageState createState() => _DraggableImageState();
}

class _DraggableImageState extends State<DraggableImage> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: widget.characterContainer.isAccepted
          ? Container(child: null)
          : ImageItem(
              image: widget.characterContainer.character.image,
            ),
      feedback: ImageItem(
        image: widget.characterContainer.character.image,
      ),
      childWhenDragging: Container(child: null),
      data: widget.characterContainer.character,
    );
  }
}

class DragTargetImage extends StatefulWidget {
  DragTargetImage({this.bloc, this.characterContainer});

  CharacterContainer characterContainer;
  HomeBloc bloc;

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
              image:
                  AssetImage(widget.characterContainer.character.shadowImage),
              fit: BoxFit.contain)),
      child: DragTarget(
        builder: (context, List<Character> candidateData, rejectedData) {
          return widget.characterContainer.isAccepted
              ? ImageItem(
                  image: widget.characterContainer.character.image,
                )
              : Container(child: null);
        },
        onAccept: (Character data) {
          if (data == widget.characterContainer.character) {
            widget.bloc.setAccepted(data);
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
