import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'write.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'view.dart';
import 'utility.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String deleteId = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, primaryColor: Colors.white,
          brightness: Brightness.dark
      ),
      home: Scaffold(
        key: _scaffoldKey,
        //데이터를 리스트로 뿌려줄 때 유용한 위젯
        body: Column(children: <Widget>[
          //메모앱 상단
          Padding(
              padding: EdgeInsets.only(left: 20, top: 40),
              child: Container(
                child: Text('메모메모',
                    style: TextStyle(fontSize: 36, color: Colors.blue)),
                alignment: Alignment.centerLeft,
              )),

          //메모앱 리스트
          Expanded(child: memoBuilder(context))
        ]),

        floatingActionButton: //InsertMemoButton(scaffoldKey : _scaffoldKey)
        FloatingActionButton.extended(
          onPressed: () {
            insertMemo(context);
          },
          tooltip: '메모를 추가하려면 클릭하세요',
          label: Text('메모 추가'),
          icon: Icon(Icons.add),
        )
      ),
    );
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
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
        if (snap.data == null || snap.data.toString() == "[]") {
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
            Utility util = Utility();
            //var textColor = index > 6? Colors.black:Colors.white;
            var textColor = Colors.white;
            var favorite = memo.favorite == 1? Icon(Icons.star, color: Colors.amberAccent,) : null;

            return Column(

              children: <Widget>[
                Container(
                  height: 80,
                  child: Card(
                    //color: Colors.accents[index % Colors.accents.length],
                    child: ListTile(
                      leading: favorite,
                      trailing: Text(
                        util.timeCheckAmPm(memo.editTime),
                          style: TextStyle(color: textColor)
                      ),
                      title: Text(
                        memo.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textColor)
                      ),
                      subtitle: Text(
                          memo.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor)
                      ),
                      onTap: () => Navigator.push(
                          parentContext,
                          MaterialPageRoute(
                              builder: (context) => ViewPage(id: memo.id))),
                      onLongPress: () {
                        deleteId = memo.id;
                        showAlertDialog(parentContext);
                      },
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
      future: loadMemo(),
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

  insertMemo(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WritePage()));

    var snackMsg = SnackBar(
      content: Text("$result"),
      action: SnackBarAction(
        label: "닫기",
        onPressed: () {},
      ),
    );

    if(result != null) _scaffoldKey.currentState.showSnackBar(snackMsg);
  }

}

//이렇게 구성하면 스낵바는 생성되나 저장시 List에 바로 화면이 보이지 않아 문제가 생김
//class InsertMemoButton extends StatelessWidget {
//  InsertMemoButton({Key key, this.scaffoldKey}) : super(key: key);
//  final GlobalKey<ScaffoldState> scaffoldKey;
//
//  @override
//  Widget build(BuildContext context) {
//    return FloatingActionButton.extended(
//      onPressed: () {
//        _insertMemo(context);
//      },
//      tooltip: '메모를 추가하려면 클릭하세요',
//      label: Text('메모 추가'),
//      icon: Icon(Icons.add),
//    );
//  }
//
//  _insertMemo(BuildContext context) async {
//    final result = await Navigator.push(
//        context, MaterialPageRoute(builder: (context) => WritePage()));
//
//    var snackMsg = SnackBar(
//      content: Text("$result"),
//      action: SnackBarAction(
//        label: "닫기",
//        onPressed: () {},
//      ),
//    );
//
//    if(result != null) scaffoldKey.currentState.showSnackBar(snackMsg);
//  }
//}

