import 'package:jp_flashcard/models/repo_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RepoManager {
  Database _database;
  static final RepoManager db = RepoManager();
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'test.db'),
        version: 1);
  }

  //ANCHOR Initialize tables
  Future<void> _initRepoList() async {
    final db = await database;
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS repos (
        repoId INTEGER PRIMARY KEY, title TEXT, numTotal INTEGER, numMemorized INTEGER
      )
      ''',
    );
    return;
  }

  Future<void> _initTagList() async {
    final db = await database;
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS tagList (
        tag NTEXT PRIMARY KEY
      )
      ''',
    );
    return;
  }

  Future<void> _initTagListOfRepo(int repoId) async {
    final db = await database;
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS tagList$repoId (
        tag NTEXT
      )
      ''',
    );
    return;
  }

  //ANCHOR Insert repo
  Future<void> insertRepo(String title, List<String> tagList) async {
    final db = await database;
    await _initRepoList();

    int repoId = await db.rawInsert(
      '''
      INSERT INTO repos(
        title, numTotal, numMemorized
      ) VALUES (?, 0, 0)
    ''',
      [title],
    );

    await _initTagListOfRepo(repoId);
    for (final tag in tagList) {
      await insertTagIntoRepo(repoId, tag);
    }
  }

  Future<void> updateTagListOfRepo(int repoId, List<String> tagList) async {
    await deleteTable('tagList$repoId');
    for (final tag in tagList) {
      await insertTagIntoRepo(repoId, tag);
    }
    return;
  }

  Future<void> insertTagIntoRepo(int repoId, String tag) async {
    final db = await database;
    await _initTagListOfRepo(repoId);
    await db.rawInsert(
      '''
      INSERT INTO tagList$repoId(
        tag
      ) VALUES (?)
    ''',
      [tag],
    );
  }

  //ANCHOR Delete repo
  Future<void> deleteRepo(int repoId) async {
    final db = await database;
    await _initRepoList();
    await db.rawDelete(
      '''
      DELETE FROM repos WHERE repoId = ?
    ''',
      [repoId],
    );
    await deleteTable('tagList$repoId');
    return;
  }

  Future<dynamic> getRepoInfoList() async {
    final db = await database;
    await _initRepoList();
    var resultRepoList = await db.query('repos');
    List<RepoInfo> repoInfoList = [];
    for (final repo in resultRepoList) {
      List<String> tagList = [];
      await getTagListOfRepo(repo['repoId']).then(
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

  Future<void> updateRepoTitle(String newTitle, int repoId) async {
    final db = await database;
    await _initRepoList();
    await db.rawUpdate(
      '''
      UPDATE repos
      SET title = ?
      WHERE repoId = ?;
    ''',
      [newTitle, repoId],
    );
    return;
  }

  Future<dynamic> updateNumTotalOfRepo(
      int repoId, int numTotal, int numCompleted) async {
    final db = await database;
    await _initRepoList();
    return await db.rawUpdate(
      '''
      UPDATE repos
      SET numTotal = ?, numMemorized = ?
      WHERE repoId = ?;
    ''',
      [numTotal, numCompleted, repoId],
    );
  }
  //--------------------------------------------

  //tags
  //--------------------------------------------

  Future<void> deleteTagFromRepo(int repoId, String tag) async {
    final db = await database;
    await _initTagListOfRepo(repoId);

    await db.rawDelete(
      '''
        DELETE FROM tagList$repoId WHERE  tag = ?
      ''',
      [tag],
    );

    return;
  }

  Future<dynamic> getTagListOfRepo(int repoId) async {
    final db = await database;
    await _initTagListOfRepo(repoId);
    return await db.rawQuery(
      '''
      SELECT tag FROM tagList$repoId
    ''',
    );
  }
  //--------------------------------------------

  //tagList
  //--------------------------------------------
  Future<void> insertTagIntoList(String tag) async {
    final db = await database;
    await _initTagList();
    var duplicated = await db.rawQuery(
      '''
      SELECT * FROM tagList where tag = ?
    ''',
      [tag],
    );
    if (duplicated.isEmpty) {
      await db.rawInsert(
        '''
      INSERT INTO tagList(
        tag
      ) VALUES (?)
    ''',
        [tag],
      );
    }
  }

  Future<bool> duplicated(String tag) async {
    final db = await database;
    await _initTagList();
    var duplicated = await db.rawQuery(
      '''
      SELECT * FROM tagList where tag = ?
    ''',
      [tag],
    );
    return duplicated.isNotEmpty;
  }

  Future<void> deleteTagFromList(String tag) async {
    final db = await database;
    await _initTagList();
    await db.rawDelete('''
      DELETE FROM tagList WHERE tag = ?
    ''', [tag]);
  }

  Future<dynamic> getTagList() async {
    final db = await database;
    await _initTagList();
    var data = await db.query('tagList');
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
  //--------------------------------------------

  deleteTable(String name) async {
    final db = await database;
    await db.execute('''
      DROP TABLE IF EXISTS $name
    ''');
  }
}
