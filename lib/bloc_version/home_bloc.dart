import 'package:flutter_brunch/data.dart';
import 'package:flutter_brunch/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc {
  final _characters = BehaviorSubject<List<Character>>()
    ..add([...characterList]..shuffle());
  final _shadowCharacters = BehaviorSubject<List<Character>>()
    ..add([...characterList]);
  final _accepted = BehaviorSubject<Set<Character>>()..add(Set());

  get characters => Observable.combineLatest2<List<Character>, Set<Character>,
              List<CharacterContainer>>(_characters, _accepted,
          (characters, accepted) {
        return characters
            .map((character) =>
                CharacterContainer(character, accepted.contains(character)))
            .toList();
      });

  get shadowCharacters => Observable.combineLatest2<
              List<Character>,
              Set<Character>,
              List<CharacterContainer>>(_shadowCharacters, _accepted,
          (characters, accepted) {
        return characters
            .map((character) =>
                CharacterContainer(character, accepted.contains(character)))
            .toList();
      });

  setAccepted(Character val) {
    _accepted.add(Set()
      ..addAll(_accepted.value)
      ..add(val));
  }

  reset() {
    _accepted.add(Set());
    _characters.add([..._characters.value]..shuffle());
    _shadowCharacters.add([..._shadowCharacters.value]..shuffle());
  }

  dispose() {
    _characters.close();
    _shadowCharacters.close();
    _accepted.close();
  }
}

class CharacterContainer {
  CharacterContainer(this.character, this.isAccepted);

  Character character;
  bool isAccepted;
}
