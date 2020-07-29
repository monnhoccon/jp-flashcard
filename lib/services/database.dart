import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  Database _database;
  static final DBManager db = DBManager();
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  final String repos = 'repos';
  final String tags = 'tags';
  final String tagList = 'tagList';
  final String wordTypeList = 'wordTypeList';
  final String flashcardList = 'flashcardList';

  Future<Database> initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'test.db'),
        version: 1);
  }

  //ANCHOR General
  createTable(String name, Database db) async {
    if (name == tags) {
      db.execute('''
      CREATE TABLE IF NOT EXISTS tags (
        repoId INTEGER, tag TEXT
      )
      ''');
    } else if (name == repos) {
      db.execute('''
      CREATE TABLE IF NOT EXISTS repos (
        repoId INTEGER PRIMARY KEY, title TEXT, numTotal INTEGER, numMemorized INTEGER
      )
      ''');
    } else if (name == tagList) {
      db.execute('''
      CREATE TABLE IF NOT EXISTS tagList (
        tag TEXT PRIMARY KEY
      )
      ''');
    } else if (name == wordTypeList) {
      db.execute('''
      CREATE TABLE IF NOT EXISTS wordTypeList (
        wordType NTEXT PRIMARY KEY
      )
      ''');
    } else {}
  }

  //repos
  //--------------------------------------------
  Future<void> insertRepo(String title, List<String> tagList) async {
    final db = await database;
    createTable(repos, db);
    int repoId = await db.rawInsert('''
      INSERT INTO repos(
        title, numTotal, numMemorized
      ) VALUES (?, 0, 0)
    ''', [title]);

    createTable(tags, db);
    for (final tag in tagList) {
      await insertTagIntoRepo(repoId, tag);
    }
  }

  Future<void> deleteRepo(int repoId) async {
    final db = await database;
    createTable(repos, db);
    await db.rawDelete('''
      DELETE FROM repos WHERE repoId = ?
    ''', [repoId]);
  }

  Future<dynamic> getRepoList() async {
    final db = await database;
    createTable(repos, db);
    return await db.query(repos);
  }

  Future<dynamic> renameRepo(String newTitle, int repoId) async {
    final db = await database;
    createTable(repos, db);

    return await db.rawUpdate('''
      UPDATE repos
      SET title = ?
      WHERE repoId = ?;
    ''', [newTitle, repoId]);
  }

  Future<dynamic> updateNumTotalOfRepo(
      int repoId, int numTotal, int numCompleted) async {
    final db = await database;
    createTable(repos, db);

    return await db.rawUpdate('''
      UPDATE repos
      SET numTotal = ?, numMemorized = ?
      WHERE repoId = ?;
    ''', [numTotal, numCompleted, repoId]);
  }
  //--------------------------------------------

  void deleteAllFlashcard(int repoId) async {
    deleteTable('flashcardList$repoId');
    deleteTable('wordList$repoId');
    deleteTable('definitionList$repoId');
    deleteTable('wordTypeList$repoId');
  }

  //tags
  //--------------------------------------------
  Future<void> insertTagIntoRepo(int repoId, String tag) async {
    final db = await database;

    bool isExist = await findTagOfRepo(tag, repoId);
    if (!isExist) {
      await db.rawInsert('''
      INSERT INTO tags(
        repoId, tag
      ) VALUES (?, ?)
    ''', [repoId, tag]);
    }
  }

  Future<void> deleteTagFromRepo(int repoId, String tag, bool deleteAll) async {
    final db = await database;
    createTable(tags, db);

    if (deleteAll) {
      await db.rawDelete('''
        DELETE FROM tags WHERE repoId = ?
      ''', [repoId]);
    } else {
      await db.rawDelete('''
        DELETE FROM tags WHERE repoId = ? AND tag = ?
      ''', [repoId, tag]);
    }
  }

  Future<dynamic> getTagListOfRepo(int repoId) async {
    final db = await database;
    createTable(tags, db);
    return await db.rawQuery('''
      SELECT tag FROM tags WHERE repoId = ?
    ''', [repoId]);
  }
  //--------------------------------------------

  //tagList
  //--------------------------------------------
  Future<void> insertTagIntoList(String tag) async {
    final db = await database;
    createTable(tagList, db);
    var duplicated = await db.rawQuery('''
      SELECT * FROM tagList where tag = ?
    ''', [tag]);
    if (duplicated.isEmpty) {
      await db.rawInsert('''
      INSERT INTO tagList(
        tag
      ) VALUES (?)
    ''', [tag]);
    }
  }

  Future<bool> findTagOfRepo(String tag, int repoId) async {
    final db = await database;
    createTable(tags, db);
    var duplicated = await db.rawQuery('''
      SELECT * FROM tags where tag = ? AND repoId = ?
    ''', [tag, repoId]);
    return duplicated.isNotEmpty;
  }

  Future<bool> duplicated(String tag) async {
    final db = await database;
    createTable(tagList, db);
    var duplicated = await db.rawQuery('''
      SELECT * FROM tagList where tag = ?
    ''', [tag]);
    return duplicated.isNotEmpty;
  }

  Future<void> deleteTagFromList(String tag) async {
    final db = await database;
    createTable(tagList, db);
    await db.rawDelete('''
      DELETE FROM tagList WHERE tag = ?
    ''', [tag]);
  }

  Future<dynamic> getTagList() async {
    final db = await database;
    createTable(tagList, db);
    var data = await db.query(tagList);
    return data;
  }

  Future<dynamic> getTags() async {
    final db = await database;
    createTable(tagList, db);
    var data = await db.query(tags);
    return data;
  }
  //--------------------------------------------

  //ANCHOR WordTypeList
  Future<void> initWordTypeList() async {
    List<String> wordTypes = [
      '名詞',
      'い形',
      'な形',
      '副詞',
      '自五',
      '他五',
      '自上ㄧ',
      '他上ㄧ',
      '自下ㄧ',
      '他下ㄧ',
      '自サ',
      '他サ',
      '代名詞',
      '其它',
    ];
    final db = await database;
    createTable(wordTypeList, db);
    for (final wordType in wordTypes) {
      var duplicated = await db.rawQuery('''
        SELECT * FROM wordTypeList WHERE wordType = ?
      ''', [wordType]);
      if (duplicated.isEmpty) {
        await db.rawInsert('''
        INSERT INTO wordTypeList(
          wordType
        ) VALUES (?)
      ''', [wordType]);
      }
    }
  }

  Future<void> insertWordTypeIntoList(String wordType) async {
    final db = await database;
    await initWordTypeList();
    var duplicated = await db.rawQuery('''
      SELECT * FROM wordTypeList WHERE wordType = ?
    ''', [wordType]);
    if (duplicated.isEmpty) {
      await db.rawInsert('''
      INSERT INTO wordTypeList(
        wordType
      ) VALUES (?)
    ''', [wordType]);
    }
  }

  Future<dynamic> getWordTypeList() async {
    final db = await database;
    await initWordTypeList();
    var data = await db.query(wordTypeList);
    return data;
  }
  //--------------------------------------------

  deleteTable(String name) async {
    final db = await database;
    await db.execute('''
      DROP TABLE IF EXISTS $name
    ''');
  }
}
