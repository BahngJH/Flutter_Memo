import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class WritePage extends StatefulWidget {
  @override
  _WritePage createState() => _WritePage();
}

class _WritePage extends State<WritePage> {
  String title = "";
  String text = "";
  String resMsg = "내용이 없어서 저장 안했어요";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, primaryColor: Colors.white,
          brightness: Brightness.dark
      ),
      home: Scaffold(
        //resizeToAvoidBottomInset: true,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                if (title.isNotEmpty || text.isNotEmpty) {
                  saveDB();
                  resMsg = "메모저장!";
                }
                Navigator.pop(context, resMsg);
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: TextField(
                  maxLines: 1,
                  maxLength: 25,
                  onChanged: (String title) {
                    this.title = title;
                  },
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: '메모 제목',
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              //Flexible로 공간을 내 맘대로 유지함
              //3 flex : 6분의 3 즉 1/2 이 비율로 조절 가능
              //Flexible의 fit : FlexFit.loose 옵션은 차지한 부분의 절반만 사용하게함
              Flexible(
                flex: 2,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (String text) {
                    this.text = text;
                  },
                  decoration: InputDecoration(
                    labelText: '메모 내용',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: str2Sha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
      favorite: 0
    );

    await sd.insertMemo(fido);

    print(await sd.memos());
  }

  String str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);

    return digest.toString();
  }
}
