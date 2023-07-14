import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:olympic/model/video.dart';
import 'package:olympic/provider/video_provider.dart';
import 'package:provider/provider.dart';

import '../model/constant.dart';
class ManageVideo extends StatefulWidget {
  const ManageVideo({Key? key}) : super(key: key);

  @override
  State<ManageVideo> createState() => _ManageVideoState();
}

class _ManageVideoState extends State<ManageVideo> {
  var titleStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Colors.deepOrangeAccent
  );
  TextEditingController urlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();


  List<String> getSuggestions(String query,List<String> data)=>
      List.of(data).where(
              (category){
            final courseLower = category.toLowerCase();
            final queryLower = query.toLowerCase();
            return courseLower.contains(queryLower);
          }
      ).toList();
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

  @override
  Widget build(BuildContext context) {
    VideoProvider videoProvider = Provider.of<VideoProvider>(context,listen: false);

    Widget categoryPicker = TypeAheadFormField<String?>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: categoryController,
        style: TextStyle(fontSize: 22,foreground: Paint()?..shader = Constant.shader),
        decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 22 ,foreground: Paint()?..shader = Constant.shader),
          labelText: 'Choose Sport Category',

          border: GradientOutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: Constant.colors),
            width: 2,
          ),
          focusedBorder: GradientOutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              gradient:
              LinearGradient(colors: Constant.colors),
              width: 2),

        ),
      ),
      onSuggestionSelected: (suggestion){
        categoryController.text = suggestion!;
      },
      onSaved: (value)=> categoryController.text = value.toString(),
      itemBuilder: (context,String? suggestion) => ListTile(
        title: Text(suggestion!),
      ),
      suggestionsCallback: (pattern) async {
        return getSuggestions(pattern,Constant.sampleCategory);
      },
    );
    Widget buildBottomSheet(BuildContext context,bool isUpdate,String id){
      return SizedBox(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: ()=> Navigator.of(context).pop(), icon: Icon(Icons.close_outlined))
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 400,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(isUpdate ? "Update Video ": "Add New Video",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.deepOrangeAccent
                                )
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: urlController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 22 ,foreground: Paint()?..shader = Constant.shader),
                                label: const Text("Enter Youtube URL",style: TextStyle(fontSize: 20)),
                                border: GradientOutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(colors: Constant.colors),
                                  width: 2,
                                ),
                                focusedBorder: GradientOutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient:
                                    LinearGradient(colors: Constant.colors),
                                    width: 2),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: titleController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 22 ,foreground: Paint()?..shader = Constant.shader),
                                label: const Text("Enter Title",style: TextStyle(fontSize: 20)),
                                border: GradientOutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(colors: Constant.colors),
                                  width: 2,
                                ),
                                focusedBorder: GradientOutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient:
                                    LinearGradient(colors: Constant.colors),
                                    width: 2),
                              ),
                            ),
                            const SizedBox(height: 24),
                            categoryPicker,
                            const SizedBox(height: 24),
                            SizedBox(
                                width: double.infinity,
                                height: 65,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: Constant.colors2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                            blurRadius: 5) //blur radius of shadow
                                      ]
                                  ),
                                  child:  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent
                                      ),
                                      onPressed: (){
                                          if(titleController.text.isNotEmpty && urlController.text.isNotEmpty && categoryController.text.isNotEmpty){
                                            !isUpdate ?
                                            videoProvider.addVideo(urlController.text, titleController.text, categoryController.text) :
                                            videoProvider.updateVideo(
                                                Video(id: id, youtubeUrl: urlController.text, title: titleController.text, category: categoryController.text)
                                            );

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(isUpdate ? "Updated" : "Added"))
                                            );
                                            Navigator.of(context).pop();
                                          }
                                      },
                                      child: const Text("Save",style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white
                                      ),)
                                  ),
                                )
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox()
              ],
            ),
          )
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: videoFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: LinearProgressIndicator(color: Colors.deepOrangeAccent,),
              );
            }else{
              return Consumer<VideoProvider>(
                builder: (context, data, child){
                  // return const Text("");
                  print("${data.getVideos.length} Total Videos");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                          DataColumn(
                            label: Text('     Action'),
                          ),
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
                              DataCell(ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        titleController.text =
                                            data.getVideos[index].title;
                                        urlController.text = data
                                            .getVideos[index].youtubeUrl;
                                        categoryController.text =
                                            data.getVideos[index].category;
                                        showBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                buildBottomSheet(
                                                  context,
                                                  true,
                                                  data.getVideos[index]
                                                      .id,
                                                ));
                                      },
                                      icon: const Icon(
                                        Icons.edit_note_outlined,
                                        color: Colors.deepOrangeAccent,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      "Are you sure to delete this video?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                context)
                                                                .pop(),
                                                        child: const Text(
                                                            "NO")),
                                                    TextButton(
                                                        onPressed: () {
                                                          videoProvider
                                                              .deleteVideo(data
                                                              .getVideos[
                                                          index]
                                                              .id)
                                                              .then((_) {
                                                            Navigator.of(
                                                                context)
                                                                .pop();

                                                          });
                                                        },
                                                        child: const Text(
                                                            "Yes"))
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.deepOrangeAccent,
                                      ))
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },

        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            titleController.text = "";
            urlController.text = "";
            showBottomSheet(
              context: context,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width
              ),
              builder: (context) => buildBottomSheet(context,false, ""),
            );
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}

