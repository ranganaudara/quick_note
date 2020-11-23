class Note{
  int id;
  String title;
  String body;

  Note({this.id, this.title, this.body});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json["id"],
    title: json["title"],
    body: json["body"]
  );

  Map<String, dynamic> toMap()=>{
    "id":id,
    "title": title,
    "body": body
  };
}