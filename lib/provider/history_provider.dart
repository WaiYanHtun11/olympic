import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/constant.dart';
import '../model/video.dart';

class HistoryProvider with ChangeNotifier{
  List<Video> _videos = [];

  List<Video> get getVideos{
    return [..._videos];
  }

  Future<void> fetchAndSetVideos(String id) async{
    final response = await http.get(Uri.parse("${Constant.dbUrl}/users/$id/history.json"));
    //print(response.body);
    List<Video> loadedData = [];

    final extractedData = json.decode(response.body) as Map<String,dynamic>;

    if(extractedData.isEmpty) {
      return;
    }

    extractedData.forEach((id, data) {

      loadedData.add(
          Video(id: id, youtubeUrl: data['url'], title: data['title'], category: data['category'])
      );

    });
    _videos = loadedData.toList();
    notifyListeners();
  }

  Future<void> resetData()async {
    _videos = [];
  }

  Future<void> addVideo(String id,Video video) async{
    int index = _videos.indexWhere((v) => v.youtubeUrl.compareTo(video.youtubeUrl) == 0);
    print("Add Video Start Working with id: $id :::::");
    if(index >= 0 || id.isEmpty){
      return;
    }

    await http.post(Uri.parse("${Constant.dbUrl}/users/$id/history.json"),body: json.encode({
      'url': video.youtubeUrl,
      'title': video.title,
      'category': video.category
    })).then((response){
      _videos.insert(0,
          Video(id: json.decode(response.body)['name'],youtubeUrl: video.youtubeUrl,title: video.title, category: video.category));
      notifyListeners();
      print("Adding Successfully");
    });
  }
}