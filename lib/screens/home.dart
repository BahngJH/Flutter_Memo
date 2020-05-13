import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'write.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deleteId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //데이터를 리스트로 뿌려줄 때 유용한 위젯
      body: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
            child: Container(
              child: Text('메모메모',
                  style: TextStyle(fontSize: 36, color: Colors.blue)),
              alignment: Alignment.centerLeft,
            )),
        Expanded(child: memoBuilder(context))
      ]),

      floatingActionButton:
          insertMemoButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경고창'),
          content: Text("메모를 정말 삭제하겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  deleteMemo(deleteId);
                });
                deleteId = '';
              },
            ),
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }

  Widget memoBuilder(BuildContext parentContext) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.data == null || snap.data == []) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              '지금 바로 "메모 추가" 버튼을 눌러 \n새로운 메모를 추가해보세요!\n\n\n\n\n\n\n\n\n\n',
              style: TextStyle(fontSize: 15, color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          itemCount: snap.data.length,
          itemBuilder: (context, index) {
            Memo memo = snap.data[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                    parentContext,
                    CupertinoPageRoute(
                        builder: (context) => ViewPage(id: memo.id)));
              },
              onLongPress: () {
                deleteId = memo.id;
                showAlertDialog(parentContext);
              },
              child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            memo.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            memo.text,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "최종 수정 시간: " + memo.editTime.split('.')[0],
                            style: TextStyle(fontSize: 11),
                            textAlign: TextAlign.end,
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 230, 230, 1),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 3)],
                    borderRadius: BorderRadius.circular(12),
                  )),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}

class insertMemoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _insertMemo(context);
      },
      tooltip: '메모를 추가하려면 클릭하세요',
      label: Text('메모 추가'),
      icon: Icon(Icons.add),
    );
  }

  _insertMemo(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WritePage()));

    var snackMsg = SnackBar(
      content: Text("$result"),
      action: SnackBarAction(
        label: "닫기",
        onPressed: () {},
      ),
    );

    if (result != null) Scaffold.of(context).showSnackBar(snackMsg);
  }
}
