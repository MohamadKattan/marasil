// this class if we want to use hive database

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:marasil/local_db/log_interface.dart';
import 'package:marasil/model/log.dart';
import 'package:path_provider/path_provider.dart';

class HiveMethod implements LogInterface {
  String hive_Box = '';
// this method for insltion hive method
  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  // this for add to hive database
  @override
  addLogs(Log log) async {
    //open
    var box = await Hive.openBox(hive_Box);
    //add to listmap
    var logMap = log.toMap(log);
    // add this list to box hive database
    int idOfInput = await box.add(logMap);
    // after add we should close
    close();
    return idOfInput;
  }

  // for update
  update(int i, Log newLog) async {
    //open
    var box = await Hive.openBox(hive_Box);
    // add to list map
    var newLogMap = newLog.toMap(newLog);
    // add updata to box
    box.putAt(i, newLogMap);
    // after that close
    close();
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hive_Box);
    await box.deleteAt(logId);
  }

// this method for get database
  @override
  Future<List<Log>> getLogs() async {
    var box = await Hive.openBox(hive_Box);
    List<Log> logList = [];
    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);
      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }

  @override
  close() => Hive.close();

  @override
  opendb(dbName) => (hive_Box = dbName);
}
