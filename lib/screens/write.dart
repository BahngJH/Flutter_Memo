import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class WritePage extends StatelessWidget {
  String title = "";
  String text = "";
  BuildContext _context;
  String resMsg = "내용이 없어서 저장 안했어요";

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          children: <Widget>[
            TextField(
              onChanged: (String title) {
                this.title = title;
              },
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              decoration: InputDecoration(hintText: '제목을 적어주세요'),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              onChanged: (String text) {
                this.text = text;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(hintText: '내용을 적어주세요'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: Str2Sha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
    );

    await sd.insertMemo(fido);

    print(await sd.memos());
  }

  String Str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);

    return digest.toString();
  }

  noTextSnackBar2(BuildContext context) {
    final snackBar = SnackBar(
      content: Text("나는 스낵바"),
    );
    Scaffold.of(_context).showSnackBar(snackBar);
  }
}

class noTextSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: snackk(context));
  }

  Widget snackk(BuildContext context) {
    final snackBar = SnackBar(
      content: Text("asdasd"),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          //Some code to undo the change
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
