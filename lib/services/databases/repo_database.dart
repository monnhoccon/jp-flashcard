import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/services/databases/flashcard_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RepoDatabase {
  //ANCHOR Public variables
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  //ANCHOR Constructor
  RepoDatabase();

  //ANCHOR APIs
  static final RepoDatabase db = RepoDatabase();

  //ANCHOR Initialize databse
  Database _database;

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      version: 1,
    );
  }

  //ANCHOR Initialize tables
  Future<void> _initRepoList() async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS repos (
        repoId INTEGER PRIMARY KEY, title TEXT, numTotal INTEGER, numMemorized INTEGER
      )
      ''');
    return;
  }

  Future<void> _initTagList() async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tagList (
        tag NTEXT PRIMARY KEY
      )
      ''');
    return;
  }

  Future<void> _initTagListOfRepo() async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tagListOfRepo (
        tag NTEXT, repoId INTEGER
      )
      ''');
    return;
  }

  //ANCHOR Insert repo
  Future<void> insertRepo(RepoInfo repoInfo) async {
    final db = await database;
    await _initRepoList();

    int repoId = await db.rawInsert('''
      INSERT INTO repos(
        title, numTotal, numMemorized
      ) VALUES (?, 0, 0)
    ''', [repoInfo.title]);

    await _initTagListOfRepo();
    for (final tag in repoInfo.tagList) {
      await _insertTagIntoRepo(repoId, tag);
    }
    return;
  }

  //ANCHOR Update tag list of repo
  Future<void> updateTagListOfRepo(int repoId, List<String> tagList) async {
    final db = await database;
    await _initTagListOfRepo();
    await db.rawDelete('''
      DELETE FROM tagListOfRepo WHERE repoId = ?
    ''', [repoId]);
    for (final tag in tagList) {
      await _insertTagIntoRepo(repoId, tag);
    }
    return;
  }

  Future<void> _insertTagIntoRepo(int repoId, String tag) async {
    final db = await database;
    await _initTagListOfRepo();
    await db.rawInsert('''
      INSERT INTO tagListofRepo(
        tag, repoId
      ) VALUES (?, ?)
    ''', [tag, repoId]);
    return;
  }

  //ANCHOR Delete repo
  Future<void> deleteRepo(int repoId) async {
    final db = await database;
    await _initRepoList();
    await db.rawDelete('''
      DELETE FROM repos WHERE repoId = ?
    ''', [repoId]);
    await _initTagListOfRepo();
    await db.rawDelete('''
      DELETE FROM tagListOfRepo WHERE repoId = ?
    ''', [repoId]);
    await FlashcardDatabase.db(repoId).deleteAllFlashcard();
    return;
  }

  //ANCHOR Get repo info list
  Future<dynamic> getRepoInfo(int repoId) async {
    final db = await database;
    await _initRepoList();
    var result = await db.rawQuery('''
      SELECT * FROM repos
      WHERE repoId = ?;
    ''', [repoId]);
    var repo = result[0];
    List<String> tagList = [];
    await _getTagListOfRepo(repo['repoId']).then(
      (resultTagList) {
        for (final tag in resultTagList) {
          tagList.add(tag['tag']);
        }
        tagList.sort();
      },
    );

    RepoInfo repoInfo = RepoInfo(
      title: repo['title'],
      repoId: repo['repoId'],
      numMemorized: repo['numMemorized'],
      numTotal: repo['numTotal'],
      tagList: tagList,
    );

    return repoInfo;
  }

  //ANCHOR Get repo info list
  Future<dynamic> getRepoInfoList() async {
    final db = await database;
    await _initRepoList();
    var resultRepoList = await db.query('repos');
    List<RepoInfo> repoInfoList = [];
    for (final repo in resultRepoList) {
      List<String> tagList = [];
      await _getTagListOfRepo(repo['repoId']).then(
        (resultTagList) {
          for (final tag in resultTagList) {
            tagList.add(tag['tag']);
          }
          tagList.sort();
        },
      );
      repoInfoList.add(
        RepoInfo(
          title: repo['title'],
          repoId: repo['repoId'],
          numMemorized: repo['numMemorized'],
          numTotal: repo['numTotal'],
          tagList: tagList,
        ),
      );
    }
    return repoInfoList;
  }

  //ANCHOR Update repo title
  Future<void> updateRepoTitle(int repoId, String newTitle) async {
    final db = await database;
    await _initRepoList();
    await db.rawUpdate('''
      UPDATE repos
      SET title = ?
      WHERE repoId = ?;
    ''', [newTitle, repoId]);
    return;
  }

  //ANCHOR Update repo num total
  Future<void> updateNumTotalOfRepo(
      int repoId, int numTotal, int numCompleted) async {
    final db = await database;
    await _initRepoList();
    await db.rawUpdate('''
      UPDATE repos
      SET numTotal = ?, numMemorized = ?
      WHERE repoId = ?;
    ''', [numTotal, numCompleted, repoId]);
    return;
  }

  Future<dynamic> _getTagListOfRepo(int repoId) async {
    final db = await database;
    await _initTagListOfRepo();
    var data = await db.rawQuery('''
      SELECT tag FROM tagListOfRepo WHERE repoId = ?
    ''', [repoId]);
    return data;
  }

  //ANCHOR Insert tag into list
  Future<void> insertTagIntoList(String tag) async {
    final db = await database;
    await _initTagList();
    if (!await tagDuplicated(tag)) {
      await db.rawInsert('''
      INSERT INTO tagList(
        tag
      ) VALUES (?)
    ''', [tag]);
    }
    return;
  }

  //ANCHOR Tag duplicated
  Future<bool> tagDuplicated(String tag) async {
    final db = await database;
    await _initTagList();
    var duplicated = await db.rawQuery('''
      SELECT * FROM tagList where tag = ?
    ''', [tag]);
    return duplicated.isNotEmpty;
  }

  //ANCHOR Delete tag from list
  Future<void> deleteTagFromList(String tag) async {
    final db = await database;
    await _initTagList();
    await db.rawDelete('''
      DELETE FROM tagList WHERE tag = ?
    ''', [tag]);

    await db.rawDelete('''
      DELETE FROM tagListOfRepo WHERE tag = ?
    ''', [tag]);
    return;
  }

  //ANCHOR Get tag list
  Future<dynamic> getTagList() async {
    final db = await database;
    await _initTagList();
    var data = await db.query('tagList');
    return data;
  }

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
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS wordTypeList (
        wordType NTEXT PRIMARY KEY
      )
      ''',
    );
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
    var data = await db.query('wordTypeList');
    return data;
  }

  _deleteTable(String name) async {
    final db = await database;
    await db.execute('''
      DROP TABLE IF EXISTS $name
    ''');
  }
}
