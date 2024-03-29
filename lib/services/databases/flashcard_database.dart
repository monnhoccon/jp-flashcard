import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FlashcardDatabase {
  //ANCHOR Public variables
  final int repoId;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  //ANCHOR Constructor
  FlashcardDatabase({this.repoId});

  //ANCHOR APIs
  static db(int repoId) {
    return FlashcardDatabase(repoId: repoId);
  }

  //ANCHOR Initialize database
  Database _database;

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      version: 1,
    );
  }

  //ANCHOR Initialize tables
  Future<void> _initAllTables() async {
    _initFlashcardList();
    _initDefinitionList();
    _initKanjiList();
    _initWordTypeList();
  }

  Future<void> _initFlashcardList() async {
    Database db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS flashcardList$repoId (
        flashcardId INTEGER PRIMARY KEY, 
        word NTEXT,
        favorite BIT, 
        progress INTEGER,
        completeDate DATE
      )
      ''');
    return;
  }

  Future<void> _initDefinitionList() async {
    Database db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS definitionList$repoId (
        definitionId INTEGER PRIMARY KEY, flashcardId INTEGER, definition NTEXT
      )
      ''');
    return;
  }

  Future<void> _initKanjiList() async {
    Database db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS kanjiList$repoId (
        kanjiId INTEGER PRIMARY KEY, flashcardId INTEGER, furigana NTEXT, ind INTEGER, length INTEGER 
      )
      ''');
    return;
  }

  Future<void> _initWordTypeList() async {
    Database db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS wordTypeList$repoId (
        wordTypeId INTEGER PRIMARY KEY, flashcardId INTEGER, wordType NTEXT
      )
      ''');
    return;
  }

  //ANCHOR Insert flashcard
  Future<void> insertFlashcard(FlashcardInfo flashcardInfo) async {
    await _initAllTables();
    int flashcardId = await _insertFlashcard(flashcardInfo);
    await _insertDefinition(flashcardId, flashcardInfo.definition);
    await _insertKanji(flashcardId, flashcardInfo.kanji);
    await _insertWordType(flashcardId, flashcardInfo.wordType);
    return;
  }

  Future<int> _insertFlashcard(FlashcardInfo flashcardInfo) async {
    final db = await database;
    await _initFlashcardList();
    int flashcardId = await db.rawInsert('''
      INSERT INTO flashcardList$repoId (
        word, favorite, progress, completeDate
      ) VALUES (?, ?, ?, ?)
    ''', [
      flashcardInfo.word ?? '',
      flashcardInfo.favorite ?? 0,
      flashcardInfo.progress ?? 0,
      flashcardInfo.completeDate ?? '2020-01-01'
    ]);
    return flashcardId;
  }

  Future<void> _insertDefinition(
      int flashcardId, List<String> definitionList) async {
    Database db = await database;
    for (final definition in definitionList) {
      await db.rawInsert('''
        INSERT INTO definitionList$repoId (
          flashcardId, definition
        ) VALUES (?, ?)
      ''', [flashcardId, definition]);
    }
    return;
  }

  Future<void> _insertKanji(
      int flashcardId, List<KanjiInfo> kanjiInfoList) async {
    Database db = await database;
    for (final kanjiInfo in kanjiInfoList) {
      await db.rawInsert('''
      INSERT INTO kanjiList$repoId (
        flashcardId, furigana, ind, length
      ) VALUES (?, ?, ?, ?)
    ''', [flashcardId, kanjiInfo.furigana, kanjiInfo.index, kanjiInfo.length]);
    }
    return;
  }

  Future<void> _insertWordType(
      int flashcardId, List<String> wordTypeList) async {
    Database db = await database;
    for (final wordType in wordTypeList) {
      await db.rawInsert('''
      INSERT INTO wordTypeList$repoId (
        flashcardId, wordType
      ) VALUES (?, ?)
    ''', [flashcardId, wordType]);
    }
    return;
  }

  //ANCHOR Get flashcard info list
  Future<dynamic> getFlashcardInfoList() async {
    final db = await database;
    await _initAllTables();
    var flashcardTable = await db.rawQuery('''
      SELECT * FROM flashcardList$repoId
    ''');
    var definitionTable = await db.rawQuery('''
      SELECT * FROM definitionList$repoId
    ''');
    var kanjiTable = await db.rawQuery('''
      SELECT * FROM kanjiList$repoId
    ''');
    var wordTypeTable = await db.rawQuery('''
      SELECT * FROM wordTypeList$repoId
    ''');

    List<FlashcardInfo> flashcardInfoList = [];
    for (final flashcard in flashcardTable) {
      List<String> definitionList = [];
      for (final definition in definitionTable) {
        if (definition['flashcardId'] == flashcard['flashcardId']) {
          definitionList.add(definition['definition']);
        }
      }
      List<KanjiInfo> kanjiList = [];
      for (final kanji in kanjiTable) {
        if (kanji['flashcardId'] == flashcard['flashcardId']) {
          kanjiList.add(KanjiInfo(
              furigana: kanji['furigana'],
              index: kanji['ind'],
              length: kanji['length']));
        }
      }
      List<String> wordTypeList = [];
      for (final wordType in wordTypeTable) {
        if (wordType['flashcardId'] == flashcard['flashcardId']) {
          wordTypeList.add(wordType['wordType']);
        }
      }

      //Create flashcard info
      FlashcardInfo info = FlashcardInfo(
        flashcardId: flashcard['flashcardId'],
        word: flashcard['word'],
        definition: definitionList,
        kanji: kanjiList,
        wordType: wordTypeList,
        favorite: flashcard['favorite'] == 1 ? true : false,
        progress: flashcard['progress'],
        completeDate: flashcard['completeDate'],
      );

      flashcardInfoList.add(info);
    }

    return flashcardInfoList;
  }

  //ANCHOR Update flashcard
  Future<void> updateFlashcard(FlashcardInfo flashcardInfo) async {
    final db = await database;
    await _initAllTables();
    await db.rawUpdate('''
      UPDATE flashcardList$repoId
      SET word = ?, favorite = ?, progress = ?, completeDate = ?
      WHERE flashcardId = ?;
    ''', [
      flashcardInfo.word,
      flashcardInfo.favorite ? 1 : 0,
      flashcardInfo.progress,
      flashcardInfo.completeDate,
      flashcardInfo.flashcardId,
    ]);
    await _deleteDefinition(flashcardInfo.flashcardId);
    await _deleteKanji(flashcardInfo.flashcardId);
    await _deleteWordType(flashcardInfo.flashcardId);

    await _insertDefinition(
        flashcardInfo.flashcardId, flashcardInfo.definition);
    await _insertKanji(flashcardInfo.flashcardId, flashcardInfo.kanji);
    await _insertWordType(flashcardInfo.flashcardId, flashcardInfo.wordType);
    return;
  }

  //ANCHOR Delete flashcard
  Future<void> deleteFlashcard(int flashcardId) async {
    final db = await database;
    await _initAllTables();
    await db.rawDelete('''
      DELETE FROM flashcardList$repoId WHERE flashcardId = ?
    ''', [flashcardId]);
    await _deleteDefinition(flashcardId);
    await _deleteKanji(flashcardId);
    await _deleteWordType(flashcardId);
    return;
  }

  Future<void> _deleteDefinition(int flashcardId) async {
    Database db = await database;
    await db.rawDelete('''
      DELETE FROM definitionList$repoId WHERE flashcardId = ?
    ''', [flashcardId]);
    return;
  }

  Future<void> _deleteKanji(int flashcardId) async {
    Database db = await database;
    await db.rawDelete('''
      DELETE FROM kanjiList$repoId WHERE flashcardId = ?
    ''', [flashcardId]);
    return;
  }

  Future<void> _deleteWordType(int flashcardId) async {
    Database db = await database;
    await db.rawDelete('''
      DELETE FROM wordTypeList$repoId WHERE flashcardId = ?
    ''', [flashcardId]);
    return;
  }

  //ANCHOR Delete all flashcard
  Future<void> deleteAllFlashcard() async {
    await _deleteTable('flashcardList$repoId');
    await _deleteTable('wordList$repoId');
    await _deleteTable('definitionList$repoId');
    await _deleteTable('wordTypeList$repoId');
    await _deleteTable('kanjiList$repoId');
    return;
  }

  Future<void> _deleteTable(String name) async {
    final db = await database;
    await db.execute(
      '''
      DROP TABLE IF EXISTS $name
    ''',
    );
    return;
  }

  //ANCHOR Update favorite
  Future<void> updateFavorite(int flashcardId, bool favorite) async {
    final db = await database;
    await _initFlashcardList();
    await db.rawUpdate('''
      UPDATE flashcardList$repoId
      SET favorite = ?
      WHERE flashcardId = ?;
    ''', [favorite ? 1 : 0, flashcardId]);
    return;
  }

  //ANCHOR Update progress
  Future<void> resetAllProgress() async {
    final db = await database;
    await _initFlashcardList();
    await db.rawUpdate('''
      UPDATE flashcardList$repoId
      SET progress = ?
    ''', [0]);
    return;
  }

  Future<void> updateProgress(int flashcardId, int progress) async {
    final db = await database;
    await _initFlashcardList();
    await db.rawUpdate('''
      UPDATE flashcardList$repoId
      SET progress = ?
      WHERE flashcardId = ?;
    ''', [progress, flashcardId]);
    return;
  }

  //ANCHOR Update conplete date
  Future<void> updateCompleteDate(int flashcardId, String completeDate) async {
    final db = await database;
    await _initFlashcardList();
    await db.rawUpdate('''
      UPDATE flashcardList$repoId
      SET completeDate = ?
      WHERE flashcardId = ?;
    ''', [completeDate, flashcardId]);
    return;
  }
}
