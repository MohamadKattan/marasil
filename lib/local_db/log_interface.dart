//in this class will be basic all method whate will implment to hive+sqlite
import 'package:marasil/model/log.dart';

abstract class LogInterface {
  init();

  addLogs(Log log);

  Future <List<Log>>getLogs();

  deleteLogs(int logId);

  close();



}