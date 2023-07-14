
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:olympic/model/login_user.dart';
import 'package:olympic/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';
import 'home_screen.dart';
import 'main.dart';
import 'model/constant.dart';
class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key,required this.user}) : super(key: key);
  final LoginUser user;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String imageUrl = '';

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  double progress = 0;

  bool isUpdateDone = false;

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.user.fullName;
    phoneController.text = widget.user.phNo;

    super.initState();
  }

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> updateProfile()async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Card(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrangeAccent,
            ),
          ),
        )
    );
    Provider.of<UserProvider>(context,listen: false).updateUser(
        LoginUser(id: widget.user.id, fullName: nameController.text, mail: widget.user.mail, phNo: phoneController.text)
    ).then((_){
      FirebaseAuth.instance.currentUser!.updateDisplayName(nameController.text);
     uploadFile().then((_){
       setState(() {
         isUpdateDone = true;
       });
       navigatorKey.currentState!.pop();
     });

    });

  }
  Future<void> uploadFile() async{
    if(pickedFile == null) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask?.whenComplete(() => null);
    final urlDownload = await snapshot?.ref.getDownloadURL();
    await user?.updatePhotoURL(urlDownload);
    final existingProfileLink = user?.photoURL;
    if(existingProfileLink.toString().isNotEmpty){
      try{
        await FirebaseStorage.instance.refFromURL(existingProfileLink!).delete();

      }catch(e){
        print("Error to delete photo");
      }
    }
  }

  // Widget buildProgress()=> StreamBuilder<TaskSnapshot>(
  //   stream: uploadTask?.snapshotEvents,
  //   builder: (context,snapshot){
  //     if(snapshot.hasData){
  //       final data = snapshot.data;
  //       setState(() {
  //         progress = data!.bytesTransferred / data.totalBytes;
  //       });
  //       return SizedBox(
  //           height: 30,
  //         child: Stack(
  //           fit: StackFit.expand,
  //           children: [
  //             LinearProgressIndicator(
  //               value: progress,
  //               backgroundColor: Colors.deepOrangeAccent,
  //               color: Colors.green,
  //             ),
  //             Center(
  //               child: Text(
  //                 '${(100*progress).roundToDouble()}%'
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     }else{
  //       return const SizedBox(height: 50);
  //     }
  //   },
  // );

  Widget buildImage(){
    if(pickedFile == null){
      if(FirebaseAuth.instance.currentUser?.photoURL == null){
        return const CircleAvatar(
          radius: 75,
          backgroundColor: Colors.white,
          child: Icon(Icons.account_circle,color: Colors.deepOrangeAccent,size: 80,),
        );

      }else{
        return CircleAvatar(
          radius: 75,
          backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL?? "")
        );
      }
    }else{
      return CircleAvatar(
        radius: 75,
        backgroundImage: FileImage(
          File(pickedFile!.path!),
        ),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    var paint = Paint()?..shader = Constant.shader;

    var alertDialog = AlertDialog(
      title: const Text("Log out Alert!"),
      content: const Text("Are you sure you want to log out?",style: TextStyle(fontSize: 20),),
      actions: [
        TextButton(onPressed: ()=> Navigator.of(context).pop(), child: const Text('NO',style: TextStyle(fontSize: 16),)),
        TextButton(onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context)=> const AuthScreen())
          );

        }, child: const Text('Yes',style: TextStyle(fontSize: 16),))
      ],
    );
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepOrangeAccent,
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isUpdateDone ? Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xBCE57C6E),
              child: Icon(Icons.check,color: Colors.white,size: 60,),
            ),
            const SizedBox(height: 32),
            const Text('Update Complete',style: TextStyle(
              color: Colors.deepOrangeAccent,
              fontSize: 20
            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                    onPressed: (){
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context)=> HomeScreen())
                      // );
                      navigatorKey.currentState!.popUntil((route)=> route.isFirst);
                    },
                    child: const Text('Back',style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 16
                    ))
                ),
                TextButton(
                    onPressed: ()=> showDialog(
                        context: context,
                        builder: (context) => alertDialog
                    ),
                    child: const Text('Log Out',style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 16
                    ))
                ),

              ],
            ),
          ],
        ) : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: InputDecoration(
                  label: const Text("Update Your Name",style: TextStyle(fontSize: 18)),
                  labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
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
              const SizedBox(height: 18),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 18 ,foreground: Paint()?..shader = Constant.shader),
                  label: const Text("Update Phone  No",style: TextStyle(fontSize: 18)),
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
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      gradient: LinearGradient(colors: Constant.colors3),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Profile Picture',style: TextStyle(fontSize: 20,foreground: paint),),
                    const SizedBox(height: 30),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.deepOrangeAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: buildImage(),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.deepOrangeAccent,
                            child: IconButton(
                             onPressed: selectFile,
                              icon: const Icon(Icons.edit,size: 25,color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
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
                        borderRadius: BorderRadius.circular(50),
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
                        onPressed: updateProfile,
                        child: const Text("Update",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),)
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
