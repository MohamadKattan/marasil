import 'package:flutter/material.dart';
import 'package:marasil/local_db/log_repository.dart';
import 'package:marasil/model/log.dart';
import 'package:marasil/utils/utilities.dart';
import 'package:marasil/widget/cashed_image.dart';
import 'package:marasil/widget/customTile.dart';
import 'package:marasil/widget/quiet_box.dart';

class listLogContainer extends StatefulWidget {
  @override
  _listLogContainerState createState() => _listLogContainerState();
}

class _listLogContainerState extends State<listLogContainer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;
          if (logList.isNotEmpty) {
            return ListView.builder(
                itemCount: logList.length,
                itemBuilder: (context, index) {
                  Log _log = logList[index];
                  bool hasDialed = _log.callStatus == 'dialled';
                  return CustomTile(
                      leading: CashedImage(
                        imageUrl: hasDialed ? _log.receiverPic : _log.callerPic,
                        isRound: true,
                        radius: 45,
                      ),
                      mini: false,
                      title: Text(
                        hasDialed ? _log.receiverName : _log.callerName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      icon: getIcon(_log.callStatus),
                      subtitle: Text(Utils.formatDateSTRING(_log.timestamp),
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      onLongPress: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Delete This log'),
                                actions: [
                                  FlatButton(
                                      onPressed: () async {
                                        Navigator.maybePop(context);
                                        await LogRepository.deleteLogs(index);
                                        // bool mounted;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      child: Text('yes')),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.maybePop(context);
                                      },
                                      child: Text('No')),
                                ],
                              )));
                });
          }
        }
        return Center(child: Text('History call is empty '));
      },
    );
  }

  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15.0;
    switch (callStatus) {
      case 'dialled':
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;
      case 'missed':
        _icon = Icon(
          Icons.call_missed,
          size: _iconSize,
          color: Colors.red,
        );
        break;
      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.white,
        );
    }
    return Container(
      padding: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }
}
