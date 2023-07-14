import 'package:flutter/material.dart';
import 'package:olympic/model/login_user.dart';
import 'package:olympic/provider/history_provider.dart';
import 'package:provider/provider.dart';

import '../model/constant.dart';
import '../provider/video_provider.dart';
class ViewHistory extends StatefulWidget {
  const ViewHistory({required this.loginUser,Key? key}) : super(key: key);
  final LoginUser loginUser;

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  late Future historyFuture;

  Future _obtainHistoryFuture() async {
    return Provider.of<HistoryProvider>(context,listen: false).fetchAndSetVideos(widget.loginUser.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historyFuture = _obtainHistoryFuture();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var titleStyle = const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Colors.deepOrangeAccent
    );

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepOrangeAccent,
        title: Text('${widget.loginUser.fullName}\'s History'),
      ),
      body: FutureBuilder(
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent));
            }else{
              return Consumer<HistoryProvider>(
                  builder: (context,data,child){
                    if(data.getVideos.isEmpty){
                      return const Center(child: Text('No Watched History'));
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            dataTextStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87
                            ),
                            headingRowColor:
                            MaterialStateProperty.all(Colors.white70),
                            showBottomBorder: true,
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            headingTextStyle: titleStyle,
                            columns: const [
                              DataColumn(
                                label: Text('Preview'),
                              ),
                              DataColumn(
                                label: Text('Title'),
                              ),
                              DataColumn(
                                label: Text('Youtube Url'),
                              ),
                              DataColumn(label: Text('Category')),
                            ],
                            rows: List<DataRow>.generate(
                              data.getVideos.length,
                                  (index) => DataRow(
                                cells: [
                                  DataCell(SizedBox(
                                    width: 80,
                                    child: Image.network(
                                        Constant.getThumbnail(
                                            videoId: Constant.convertUrlToId(
                                                data.getVideos[index]
                                                    .youtubeUrl) ??
                                                ""),
                                        fit: BoxFit.cover),
                                  )),

                                  DataCell(Text(data
                                      .getVideos[index].title.length >=
                                      20
                                      ? "${data.getVideos[index].title.substring(0, 20)}... "
                                      : data.getVideos[index].title)),
                                  DataCell(SizedBox(
                                      width: 250,
                                      child: Text(
                                          data.getVideos[index].youtubeUrl))),
                                  DataCell(
                                      Text(data.getVideos[index].category)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          }
      ),
    );
  }
}
