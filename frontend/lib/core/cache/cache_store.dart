import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:hive/hive.dart';

class CacheStore<ValueType> {
  final bool needBeEncrypted;
  late String _boxName;
  Box<ValueType>? _box;

  CacheStore({
    this.needBeEncrypted = false,
  }) {
    _boxName = 'cache_${ValueType.toString().toLowerCase()}';
  }

  Future<void> _openBox() async {
    if (_box == null || !(_box?.isOpen ?? true)) {
      try {
        final keyBox = await Hive.openBox<Uint8List>('encryptionKeyBoxV2');

        if (!keyBox.containsKey('key')) {
          final key = Hive.generateSecureKey() as Uint8List;
          await keyBox.put('key', key);
        }

        _box = Hive.isBoxOpen(_boxName)
            ? Hive.box(_boxName)
            : await Hive.openBox(_boxName,
                encryptionCipher:
                    needBeEncrypted ? HiveAesCipher(keyBox.get('key')!) : null);
      } catch (e) {
        log(
          'Erro box: $e',
          name: 'Cache',
          error: e,
        );
      }
    }
  }

  ///Checks whether the box contains the key[dynamic].
  Future<bool> containsKey(dynamic key) async {
    try {
      await _openBox();
      return _box!.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  ///Get the cached value by the key[dynamic].
  Future<ValueType?> getByKey(dynamic key, {ValueType? defaultValue}) async {
    try {
      await _openBox();
      return _box?.get(key, defaultValue: defaultValue);
    } catch (e) {
      return null;
    }
  }

  ///Get the cached value by the index[int].
  Future<ValueType?> getByIndex(int index) async {
    try {
      await _openBox();
      return _box!.getAt(index);
    } catch (e) {
      return null;
    }
  }

  ///Saves the value[T] with an auto-increment key.
  Future<int?> write(ValueType value) async {
    try {
      await _openBox();
      return _box!.add(value);
    } catch (e) {
      return null;
    }
  }

  ///Saves the values[Iterable] with an auto-increment key.
  Future<Iterable<int>?> writeMany(Iterable<ValueType> values) async {
    try {
      await _openBox();
      return _box!.addAll(values);
    } catch (e) {
      return null;
    }
  }

  ///Saves the value[T] in the key[dynamic].
  Future<bool?> writeByKey(dynamic key, ValueType value) async {
    try {
      await _openBox();
      await _box!.put(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Saves the values[Map], being value[T] in their respective keys[dynamic].
  Future<bool?> writeManyByKey(Map<dynamic, ValueType> values) async {
    try {
      await _openBox();
      await _box!.putAll(values);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Saves the value[T] at the index[int].
  Future<bool?> writeByIndex(int index, ValueType value) async {
    try {
      await _openBox();
      await _box!.putAt(index, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Removes the given key[dynamic] from the box.
  Future<bool?> deleteByKey(dynamic key) async {
    try {
      await _openBox();
      await _box!.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Removes the given index[int] from the box.
  Future<bool?> deleteByIndex(int index) async {
    try {
      await _openBox();
      await _box!.deleteAt(index);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Removes the given keys[Iterable] from the box.
  Future<bool?> deleteManyByKeys(Iterable<dynamic> keys) async {
    try {
      await _openBox();
      await _box!.deleteAll(keys);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Removes all entries from the box.
  Future<bool?> clear() async {
    try {
      await _openBox();
      await _box!.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Returns the key[dynamic] at the index[int].
  Future<dynamic> keyAt(int index) async {
    try {
      await _openBox();
      return _box!.keyAt(index);
    } catch (e) {
      return null;
    }
  }

  ///Returns the values[Iterable] between start[dynamic] and end[dynamic] keys.
  Future<Iterable<ValueType>?> valuesBetween(
      {required dynamic startKey, required dynamic endKey}) async {
    try {
      await _openBox();
      return _box!.valuesBetween(startKey: startKey, endKey: endKey);
    } catch (e) {
      return null;
    }
  }

  ///Returns a broadcast stream of change events.
  ///If the key[dynamic] parameter is provided, only events for the specified key are broadcasted.
  Future<Stream<BoxEvent>?> watch(dynamic key) async {
    try {
      await _openBox();
      return _box!.watch(key: key);
    } catch (e) {
      return null;
    }
  }

  /// Returns `true` if there are no entries in this box.
  Future<bool> get isEmpty async {
    try {
      await _openBox();
      return _box!.isEmpty;
    } catch (e) {
      return true;
    }
  }

  ///Returns true if there is at least one entries in this box.
  Future<bool> get isNotEmpty async {
    try {
      await _openBox();
      return _box!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  ///Whether this box is currently open.
  Future<bool?> get isBoxOpen async {
    try {
      await _openBox();
      return _box!.isOpen;
    } catch (e) {
      return null;
    }
  }

  ///All the keys in the box.
  Future<Iterable<dynamic>?> get keys async {
    try {
      await _openBox();
      return _box!.keys;
    } catch (e) {
      return null;
    }
  }

  ///The number of entries in the box.
  Future<int?> get length async {
    try {
      await _openBox();
      return _box!.length;
    } catch (e) {
      return 0;
    }
  }

  ///The name of the box. Names are always lowercase.
  Future<String?> get boxName async {
    try {
      await _openBox();
      return _box!.name;
    } catch (e) {
      return null;
    }
  }

  ///The location of the box in the file system. In the browser, this is null.
  Future<String?> get path async {
    try {
      await _openBox();
      return _box!.path;
    } catch (e) {
      return null;
    }
  }

  ///The location of the box in the file system. In the browser, this is null.
  Future<Iterable<ValueType>?> get values async {
    try {
      await _openBox();
      return _box!.values;
    } catch (e) {
      return null;
    }
  }

  ///Close the oppened box
  Future<void> closeBox() async => _box!.isOpen ? await _box!.close() : null;
}
