import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import 'audiodata.dart';

class files extends StatefulWidget {

  const files({super.key});

  @override
  State<files> createState() => _filesState();
}

class _filesState extends State<files> {
  PlayerController controller = PlayerController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List recordings = [];

  void getdata() async {
    QuerySnapshot docRef = await firestore.collection("myrecordngs").get();
    List data = docRef.docs.map((element) => element.data()).toList();
    setState(() {
      recordings = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      // Column(
      //   children: [SizedBox(height: 50,),
      //     Text('${recordings[0].downloadurl}'),
      //   ],
      // )
      ListView.builder(itemCount: recordings.length,
          itemBuilder: (context, index) {
            return audiodata(
              url: recordings[index]['downloadurl'].toString(),
            );
              //ListTile(title:Text('${recordings[index]['downloadurl']}'));
              // Row(
              //     children: [
              //       Text("Audio.mp3"),
              //       IconButton(onPressed: () async {
              //         // if (isplay) {
              //         //   await controller.stopPlayer();
              //         // } else {
              //         //   await controller.preparePlayer(
              //         //       path: recordings[index]['downloadurl']);
              //         //   await controller.startPlayer(
              //         //       finishMode: FinishMode.stop);
              //         // }
              //         setState(() {
              //           isplay = !isplay;
              //         });
              //       },
              //         icon: isplay ? Icon(Icons.pause) : Icon(
              //           Icons.play_circle,),)
              //     ]
              // );
          }),
      // Column(
      //   children: [SizedBox(height: 50,),
      //     Row(
      //         children:[
      //           Text("Audio.mp3"),
      //           IconButton(onPressed: ()async{
      //             if(isplay){
      //               // await controller.pausePlayer();
      //             }else{
      //               //await controller.extractWaveformData(path: d);
      //               // await controller.startPlayer();
      //             }
      //             setState(() {
      //               isplay=!isplay;
      //             });
      //           }, icon: isplay?Icon(Icons.pause): Icon(Icons.play_circle,),)
      //         ]
      //     ),
      //   ],
      // ),
    );
  }
}
