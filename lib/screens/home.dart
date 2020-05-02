import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        Expanded(child: memoBuilder())
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //화면 전환 함수 구현
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      EditPage())); // 현재 화면에 그 위에 새로운 화면을 라우팅 하게 해줌
        },
        tooltip: '메모를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> LoadMemo() {
    List<Widget> memoList = [];
    memoList.add(Container(
      color: Colors.deepPurpleAccent,
      height: 150,
    ));
    memoList.add(Container(
      color: Colors.greenAccent,
      height: 150,
    ));

    return memoList;
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Widget memoBuilder() {
    return FutureBuilder(
      builder: (context, Snap) {
        if (Snap.data.isEmpty) {
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
          itemCount: Snap.data.length,
          itemBuilder: (context, index) {
            Memo memo = Snap.data[index];
            return Container(
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
                    Text(memo.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    Text(memo.text, style: TextStyle(fontSize: 15)),
                  ],),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("최종 수정 시간: "+memo.editTime.split('.')[0],
                      style: TextStyle(fontSize: 11),
                      textAlign: TextAlign.end,)
                    ],
                  )
                ],
              ),

                decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 1,
              ),
              boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 3)],
              borderRadius: BorderRadius.circular(12),
            ));
          },
        );
      },
      future: loadMemo(),
    );
  }
}
