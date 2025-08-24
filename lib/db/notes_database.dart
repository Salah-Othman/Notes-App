import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdTime': createdTime.toIso8601String(),
  };

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json['id'] as int?,
    title: json['title'] as String,
    content: json['content'] as String,
    createdTime: DateTime.parse(json['createdTime'] as String),
  );

  Note copy({int? id, String? title, String? content, DateTime? createdTime}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdTime: createdTime ?? this.createdTime,
      );
}

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('Notes.db');
    return _database!;
  }

  _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      createdTime TEXT NOT NULL
    )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'notes',
      columns: ['id', 'title', 'content', 'createdTime'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'createdTime DESC');
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
