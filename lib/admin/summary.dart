import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:olympic/provider/user_provider.dart';
import 'package:olympic/provider/video_provider.dart';
import 'package:provider/provider.dart';

import '../model/constant.dart';
class Summary extends StatefulWidget {
  Summary({Key? key,required this.switchScreen}) : super(key: key);
  void Function(int index) switchScreen;


  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  late Future userFuture;
  late Future videoFuture;

  Future _obtainVideoFuture() async {
    return Provider.of<VideoProvider>(context,listen: false).fetchAndSetVideos();
  }

  Future _obtainUserFuture() async {
    return Provider.of<UserProvider>(context,listen: false).fetchAndSetUsers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userFuture = _obtainUserFuture();
    videoFuture = _obtainVideoFuture();
  }

  Widget buildCard(IconData iconData,String title,int count,index){
    return  SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 10,
      height: 200,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: ()=> widget.switchScreen(index),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Colors.deepOrangeAccent,
                size: Constant.isWeb ? 80 : 60,
              ),
              Text(
                  title,
                style: TextStyle(
                  fontSize: Constant.isWeb ? 26 : 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                  '${count}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),

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
      body: Padding(
        padding: EdgeInsets.all(Constant.isWeb ? 20 : 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
                future: userFuture,
                builder: (context,snapshot){
                  return Consumer<UserProvider>(
                      builder: (context,data,child){
                        return buildCard(Icons.groups_outlined, "Total Users",data.getUsers.length,1);

                      }
                  );
                }
            ),
            FutureBuilder(
                future: videoFuture,
                builder: (context,snapshot){
                  return Consumer<VideoProvider>(
                      builder: (context,data,child){
                        return buildCard(Icons.movie_outlined, "Total Videos",data.getVideos.length,2);
                      }
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
