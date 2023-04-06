import 'dart:convert';

import 'package:http/http.dart';
import 'package:MultiToolsApp/models/post.dart';

class HttpService{
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  Future<List<Post>> getPosts() async{
    Response res = await get(url);
    if (res.statusCode == 200){ //se obteve sucesso na requisição
      List<dynamic> body = jsonDecode(res.body);
      List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    }else{
      throw "Não foi possível recuperar os dados";
    }
  }

  Future<void> deletePost(int id) async{
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/'+id.toString());
    Response res = await delete(url);

    if(res.statusCode == 200){
      print("exclusão feita com sucesso");
    }else{
      print("erro ao excluir");
      throw "Não foi possível excluir os dados";
    }
  }
}