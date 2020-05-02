import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit.dart';


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
      body: ListView(
        //애니메이션 튕겨주는거 구현
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text('메모메모', style: TextStyle(fontSize: 36, color: Colors.blue),),)

          ],),
          ...LoadMemo()
//          Container(color: Colors.redAccent, height: 150),
//          Container(color: Colors.orange, height: 150),
//          Container(color: Colors.yellow, height: 150),
//          Container(color: Colors.green, height: 150),
//          Container(color: Colors.blue, height: 150),
//          Container(color: Colors.purple, height: 150),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

          //화면 전환 함수 구현
          Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => EditPage())
          );    // 현재 화면에 그 위에 새로운 화면을 라우팅 하게 해줌
        },
        tooltip: '노트를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Widget> LoadMemo() {
    List<Widget> memoList = [];
    memoList.add(Container(color: Colors.deepPurpleAccent, height: 150,));
    memoList.add(Container(color: Colors.greenAccent, height: 150,));

    return memoList;
  }
}
