import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;


void main() => runApp(new MarvelApp());class MarvelApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(title: Text("Marvel Comics!"),),
          body: InfinitySaga()
      ),
    );
  }
}class InfinitySaga extends StatefulWidget{
  InfinitySaga() : super();
  @override
  ListInfinitySaga createState()  => new ListInfinitySaga();
}
class InfinityComic{
  final String title;
  final String cover;
  InfinityComic(this.title, this.cover);
}class ListInfinitySaga extends State<InfinitySaga>{  Future<List<InfinityComic>> _getComics() async{
  var now = new DateTime.now();
  var md5D = generateMd5(now.toString()+"77fdf82ddea3dc66b21b564ec4d349d2b1d75090"+"674d007c066093f19241ed01e7b961ec");
  var url = "https://gateway.marvel.com:443/v1/public/characters?&ts=" + now.toString()+  "&apikey=674d007c066093f19241ed01e7b961ec&hash="+md5D;
  print(url);
  var uri = Uri.parse(url);
  var data = await http.get(uri);
  var jsonData = json.decode(data.body);
  List<InfinityComic> comics = [];
  var dataMarvel = jsonData["data"];
  var results = dataMarvel["results"];
  for(var comic in results){
    var thumb = comic["thumbnail"];
    var image = "${thumb["path"]}.jpg";
    InfinityComic infinityComic = InfinityComic(comic["name"], image);
    comics.add(infinityComic);
  }
  return comics;
}  String generateMd5(String input) {
  return crypto.md5.convert(utf8.encode(input)).toString();
}  @override
Widget build(BuildContext context) {
  // TODO: implement build
  return new Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _getComics(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("loading...."
                  )
                  ,)
                ,);
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: CircleAvatar(backgroundImage:
                      NetworkImage(snapshot.data[index].cover
                      ),
                      ),
                      title: Text(snapshot.data[index].title),
                    );
                  }
              );
            }
          },
        ),
      )
  );
}
}