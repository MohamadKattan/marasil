// this class for control any method we want to use by boo (sqlite or hive)
import 'package:marasil/model/log.dart';
import 'package:meta/meta.dart';
import 'package:marasil/local_db/hive.dart';
import 'package:marasil/local_db/sqlite.dart';

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive,@required String dbName}) {
    dbObject = isHive ? HiveMethod() : SqliteMethod();
    dbObject.opendb(dbName);
    dbObject.init();

  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}