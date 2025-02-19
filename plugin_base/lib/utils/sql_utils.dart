import 'package:sqflite/sqflite.dart';


class TableName{
  static const String cashTaskRecord="cashTaskRecord";
}

class SqlUtils{
  static final SqlUtils _instance = SqlUtils();
  static SqlUtils get instance => _instance;

  Future<Database> initDB()async{
    return await openDatabase(
      "wl.db",
      version: 1,
      onCreate: (db,version){
        db.execute('CREATE TABLE ${TableName.cashTaskRecord} (id INTEGER PRIMARY KEY AUTOINCREMENT, taskComplete INTEGER,taskName TEXT, cashType INTEGER, cashNum INTEGER,taskPro INTEGER, signPro INTEGER, account TEXT)');
      }
    );
  }
}