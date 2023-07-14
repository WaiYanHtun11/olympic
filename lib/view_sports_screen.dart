import 'package:flutter/material.dart';
import 'package:olympic/provider/video_provider.dart';
import 'package:olympic/video_screen.dart';
import 'package:provider/provider.dart';

import 'model/constant.dart';
import 'model/video.dart';
class ViewSportsScreen extends StatefulWidget {
  String name;
  ViewSportsScreen({required this.name,Key? key}) : super(key: key);

  @override
  State<ViewSportsScreen> createState() => _ViewSportsScreenState();
}

class _ViewSportsScreenState extends State<ViewSportsScreen> {
  late Future videoFuture;

  Future _obtainVideoFuture() async {
    return Provider.of<VideoProvider>(context,listen: false).fetchAndSetVideos();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoFuture = _obtainVideoFuture();
  }
  Widget buildCard(Video video){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        onTap: ()=> Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> VideoScreen(video: video))
        ),
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                child: Image.network(
                    Constant.getThumbnail(
                        videoId: Constant.convertUrlToId(
                            video.youtubeUrl) ?? ""),
                    fit: BoxFit.fitHeight

                ),
              ),
              ListTile(
                title: Text(
                  video.title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: const Icon(Icons.chevron_right),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepOrange,
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: videoFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepOrangeAccent,),
              );
            }else{
              return Consumer<VideoProvider>(
                  builder: (context,data,child){
                    data.filterVideos(widget.name);
                    print("Total Video: ${data.getFilteredVideos}");
                    return ListView.builder(
                        itemCount: data.getFilteredVideos.length,
                        itemBuilder: (context ,index){
                          return buildCard(data.getFilteredVideos[index]);
                        }
                    );
                  }
              );
            }
          },
        ),
      ),
    );
  }
}
