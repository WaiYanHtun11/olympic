import 'package:flutter/material.dart';
import 'package:olympic/admin/view_history.dart';
import 'package:olympic/model/login_user.dart';
import 'package:olympic/provider/history_provider.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);
  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {

  var titleStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Colors.deepOrangeAccent
  );

  late Future userFuture;

  Future _obtainUserFuture() async {
    return Provider.of<UserProvider>(context,listen: false).fetchAndSetUsers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userFuture = _obtainUserFuture();
  }
  @override
  Widget build(BuildContext context) {
    Widget buildBottomSheet(BuildContext context,LoginUser loginUser){
      return SizedBox(child: ViewHistory(loginUser: loginUser));
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: userFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: LinearProgressIndicator(color: Colors.deepOrangeAccent,),
              );
            }else{
              return Consumer<UserProvider>(
                builder: (context, data, child){
                  // return const Text("");

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
                            label: Text('Name'),
                          ),
                          DataColumn(
                            label: Text('Mail'),
                          ),
                          DataColumn(
                            label: Text('Phone Number'),
                          ),
                          // DataColumn(
                          //   label: Text('Country'),
                          // ),
                          // DataColumn(
                          //   label: Text('Favorite Sport'),
                          // ),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: List<DataRow>.generate(
                          data.getUsers.length,
                              (index) => DataRow(
                            cells: [
                              DataCell(Text(data.getUsers[index].fullName)),
                              DataCell(Text(data.getUsers[index].mail)),
                              DataCell(Text(data.getUsers[index].phNo)),

                              // DataCell(Text(data.getUsers[index].country)),
                              // DataCell(Text(data.getUsers[index].favoriteSport)),
                              DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          icon: const Icon(Icons.remove_red_eye_outlined,size: 32,color: Colors.deepOrangeAccent),
                                          onPressed: (){
                                            Provider.of<HistoryProvider>(context,listen: false).resetData();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => ViewHistory(loginUser: data.getUsers[index])
                                                )
                                            );
                                          }
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.delete,size: 32,color: Colors.deepOrangeAccent),
                                          onPressed: ()=> showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("User Deletion Alert!"),
                                                content: const Text("Are you sure you want to delete this user?",style: TextStyle(fontSize: 20),),
                                                actions: [
                                                  TextButton(onPressed: ()=> Navigator.of(context).pop(), child: const Text('NO',style: TextStyle(fontSize: 16),)),
                                                  TextButton(onPressed: (){
                                                    Provider.of<UserProvider>(context,listen: false).deleteUser(data.getUsers[index].id);
                                                    Navigator.of(context).pop();
                                                  }, child: const Text('Yes',style: TextStyle(fontSize: 16),))
                                                ],
                                              )
                                          )
                                      ),
                                    ],
                                  )

                              )

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
    );
  }
}
