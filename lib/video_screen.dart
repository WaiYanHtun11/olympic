import 'dart:async';

import 'package:flutter/material.dart';
import 'package:olympic/provider/history_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'model/constant.dart';
import 'model/video.dart';
class VideoScreen extends StatefulWidget {
  Video video;
  VideoScreen({required this.video,Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = YoutubePlayerController.fromVideoId(
      autoPlay: true,

      // initialVideoId: widget.playId,

      params:  const YoutubePlayerParams(

        showControls: true,
        playsInline: true,
        strictRelatedVideos: true,
        color: "white",

        // color: "black",
        showFullscreenButton: true,


        // privacyEnhanced: true,
      ), videoId: Constant.convertUrlToId(widget.video.youtubeUrl).toString(),
    );
    addToHistory();
  }

  void addToHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";

    await Future.delayed(const Duration(seconds: 20)).then((_){
      Provider.of<HistoryProvider>(context,listen: false).addVideo(userId, widget.video);
    });
  }

  Widget _buildRowText(String text,bool isTitle,bool isDescription){
    //Fluttertoast.showToast(msg: widget.path+"from lecture control widget");
    Widget _textfield;
    if(isTitle){
      _textfield = Text(text,style: const TextStyle(
          fontSize: 20 ,
          color: Colors.black,
          fontWeight: FontWeight.w500 ),
      );

    }else{

      _textfield = Text(text,style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.normal),
        textAlign: TextAlign.start,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Expanded(child: _textfield)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        controller: _controller,
        aspectRatio: 16 / 9,
        backgroundColor: Colors.white,
        builder: (context, player) {
          return Scaffold(
            appBar:AppBar(
              title: Text(widget.video.title),
              foregroundColor: Colors.deepOrangeAccent,
            ) ,
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 700,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: player,
                      ),
                      Visibility(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              _buildRowText("Title", true, false),
                              _buildRowText(widget.video.title, false,false), // _buildRowText("Resource Links", true, false),
                              const SizedBox(height: 100)
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
