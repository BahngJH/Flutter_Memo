import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'edit.dart';
import 'package:share/share.dart';
import 'utility.dart';

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Memo _memo;
  Memo _secondMemo;

  @override
  Widget build(BuildContext context) {
    if (_memo != null && _secondMemo == null) _secondMemo = _memo;
    return loadBuilder();
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
    await showDialog(
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

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
        future: loadMemo(widget.id),
        builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
          Utility util = Utility();

          if (snapshot.data == null) {
            return MaterialApp(
                theme: ThemeData(
                    primarySwatch: Colors.deepOrange,
                    primaryColor: Colors.white,
                    brightness: Brightness.dark),
                home: Scaffold(
                  body: Center(
                    child: Text("불러올 데이터가 없습니다."),
                  ),
                ));
          }
          print(snapshot);
          print(snapshot.hasData);
          if (snapshot.hasData) {
            _memo = snapshot.data[0];
            //print("DB에서 조회한 데이터 : "+_memo.favorite.toString());

            return MaterialApp(
              theme: ThemeData(
                  primarySwatch: Colors.deepOrange,
                  primaryColor: Colors.white,
                  brightness: Brightness.dark),
              home: Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () => share(context),
                    ),
                    IconButton(
                      icon: Icon(_secondMemo == null
                          ? _memo.favorite == 0 ? Icons.star_border : Icons.star
                          : _secondMemo.favorite == 0
                              ? Icons.star_border
                              : Icons.star, color: Colors.amberAccent),
                      onPressed: () {
                        updateFavorite(_toggleFavorite());
                      },
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
                            MaterialPageRoute(
                                builder: (context) => EditPage(id: widget.id)));
                      },
                    )
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 70,
                        child: SingleChildScrollView(
                          child: Text(
                            _memo.title,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),

                      //긴글 텍스트 스크롤 생성하게 도와줌
                      Expanded(
                          flex: 1,
                          child:
                              SingleChildScrollView(child: Text(_memo.text))),
                      Text(
                        "최근 수정 시간 : " +
                            util.timeCheckAmPm(_memo.editTime) +
                            "\n",
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.end,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: Text(
                          "최초 만든 시간 : " + util.timeCheckAmPm(_memo.createTime),
                          style: TextStyle(fontSize: 11),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          //동그란 프로그래스 바
          return CircularProgressIndicator();
        });
  }

  int _toggleFavorite() {
    setState(() {
      if (_secondMemo == null && _memo.favorite == 0)
        _memo.favorite = 1;
      else if (_secondMemo == null && _memo.favorite == 1)
        _memo.favorite = 0;
      else if (_secondMemo != null && _secondMemo.favorite == 0)
        _secondMemo.favorite = 1;
      else if (_secondMemo != null && _secondMemo.favorite == 1)
        _secondMemo.favorite = 0;
    });
    return _secondMemo == null ? _memo.favorite : _secondMemo.favorite;
  }

  void updateFavorite(int currentVal) async {
    DBHelper sd = DBHelper();
    var fido = Memo(
      id: _memo.id,
      title: _memo.title,
      text: _memo.text,
      createTime: _memo.createTime,
      editTime: _memo.editTime,
      favorite: currentVal
    );

    return await sd.updateMemo(fido);
  }
}
