// this class if we want to use hive database

import 'package:marasil/local_db/log_interface.dart';
import 'package:marasil/model/log.dart';

class HiveMethod implements LogInterface{
  @override
  addLogs(Log log) {
    // TODO: implement addLogs
    throw UnimplementedError();
  }

  @override
  close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  deleteLogs(int logId) {
    // TODO: implement deleteLogs
    throw UnimplementedError();
  }

  @override
  Future<List<Log>> getLogs() {
    // TODO: implement getLogs
    throw UnimplementedError();
  }

  @override
  init() {
    // TODO: implement init
    throw UnimplementedError();
  }
}