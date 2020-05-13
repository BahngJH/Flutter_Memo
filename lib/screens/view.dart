import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'edit.dart';
import 'package:share/share.dart';

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Memo _memo = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => share(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteMemo(_memo.id);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => EditPage(id: widget.id)));
            },
          )
        ],
      ),
      body: Padding(padding: EdgeInsets.all(20), child: LoadBuilder()),
    );
  }

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = "제목 : ${_memo.title}\n  ${_memo.text}";

    Share.share(text,
        subject: "***메모 메시지***\n",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("삭제 경고창"),
            content: Text("메모를 정말 삭제하겠습니까?"),
            actions: <Widget>[
              FlatButton(
                child: Text("삭제"),
                onPressed: () {
                  Navigator.pop(context);
                  deleteMemo(_memo.id);
                },
              ),
              FlatButton(
                child: Text("취소"),
                onPressed: () {},
              )
            ],
          );
        });
  }

  LoadBuilder() {
    return FutureBuilder<List<Memo>>(
        future: loadMemo(widget.id),
        builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
          if (snapshot.data == null) {
            return Container(child: Text("데이터를 불러올 수 없습니다."));
          } else {
            _memo = snapshot.data[0];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 70,
                  child: SingleChildScrollView(
                    child: Text(
                      _memo.title,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Expanded(child: Text(_memo.text)),
                Text(
                  "메모 만든 시간 " + _memo.createTime.split('.')[0],
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.end,
                ),
                Text(
                  "메모 수정 시간 " + _memo.editTime.split('.')[0],
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.end,
                ),
              ],
            );
          }
        });
  }
}
