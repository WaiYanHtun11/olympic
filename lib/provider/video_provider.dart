import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../model/constant.dart';
import '../model/video.dart';

class VideoProvider with ChangeNotifier{
  List<Video> _videos = [];
  List<Video> _filterVideos = [];

  List<Video> get getVideos{
    return [..._videos];
  }
  List<Video> get getFilteredVideos{
    return [..._filterVideos];
  }
  
  void filterVideos(String category){
    _filterVideos = [];
    for(Video v in _videos){
      if(v.category.compareTo(category) == 0){
        _filterVideos.add(v);
      }
    }
  }


  Future<void> fetchAndSetVideos() async{
    final response = await http.get(Uri.parse("${Constant.dbUrl}/videos.json"));
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

  Future<void> addVideo(String youtubeUrl,String title,String category) async{
    await http.post(Uri.parse("${Constant.dbUrl}/videos.json"),body: json.encode({
      'url': youtubeUrl,
      'title': title,
      'category': category
    })).then((response){
      _videos.insert(0,
          Video(id: json.decode(response.body)['name'],youtubeUrl: youtubeUrl,title: title, category: category));
      notifyListeners();
    });
  }


  Future<void> updateVideo(Video newVideo) async{
    final existingVideoIndex = _videos.indexWhere((v) => v.id == newVideo.id);

    final url = '${Constant.dbUrl}/videos/${newVideo.id}.json';

    try{
      final response = await http.patch(Uri.parse(url),body: json.encode({
        'url': newVideo.youtubeUrl,
        'title': newVideo.title,
        'category': newVideo.category
      }));
      Video existingVideo = _videos[existingVideoIndex];

      existingVideo.title = newVideo.title;
      existingVideo.youtubeUrl = newVideo.youtubeUrl;
      existingVideo.category = newVideo.category;

      _videos[existingVideoIndex] = existingVideo;
      notifyListeners();

    }catch(error){
      print("$error From Error");
    }
  }

  Future<void> deleteVideo(String id) async{
    final url = '${Constant.dbUrl}/videos/$id.json';
    final existingIndex = _videos.indexWhere((vc) => vc.id == id);
    Video? existingVideo = _videos[existingIndex];
    _videos.removeAt(existingIndex);
    final response = await http.delete(Uri.parse(url));
    if(response.statusCode >= 400){
      _videos.insert(existingIndex, existingVideo);
      notifyListeners();
    }
    existingVideo = null;
    notifyListeners();
  }
}