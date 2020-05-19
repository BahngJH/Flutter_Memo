class Memo{
  final String id;
  final String title;
  final String text;
  final String createTime;
  String editTime;
  int favorite;

  Memo({this.id, this.title, this.text, this.createTime, this.editTime, this.favorite});

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'text' : text,
      'createTime' : createTime,
      'editTime' : editTime,
      'favorite' : favorite
    };
  }

  //각 memo 정보를 보기 쉽도록 print문을 사용하여 toString을 구현하세요
  @override
  String toString(){
    return 'Memo {'
        'id: $id, title: $title, text: $text, createTime: $createTime, editTime: $editTime, favorite: $favorite'
        '}';
  }

}