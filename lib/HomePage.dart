import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'files.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String timertext = '00.00.00';
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  //String elapsedTime = "00:00:00.00";
  bool isshow = true;
  late final RecorderController recorderController;
bool isplay=false;
  //PlayerController controller = PlayerController();                   // Initialise
  void initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..sampleRate = 16000;
  }

  void startRecording() async {

    await recorderController.record();
    String path = (await getTemporaryDirectory()).path;
    await recorderController.record(path: path);
  }
  void startStopwatch() {
    stopwatch.start();
    timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        timertext = stopwatch.elapsed.toString().substring(0, 8);
      });
    });
  }
  void stopStopwatch() {
    stopwatch.stop();
    timer.cancel();
  }
  void resetStopwatch() {
    stopwatch.reset();
    timer.cancel();
    setState(() {
      timertext = "00:00.00";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseController();
    // setState(() {
    //   isshow=!isshow;
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorderController.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AudioWaveforms(
            size: Size(MediaQuery.of(context).size.width, 200.0),
            recorderController: recorderController,

          ),
          SizedBox(height: 40,),
          Text('$timertext',style: TextStyle(fontSize: 30),),
          SizedBox(height: MediaQuery.of(context).size.height / 3),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isshow,
                replacement: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: IconButton(
                      onPressed: () async {
                         String? path = await recorderController.stop();
                         stopStopwatch();

                        if (path != null) {
                          Reference ref = FirebaseStorage.instance
                              .ref()
                              .child('recordngs')
                              .child('/audio.aac');
                           UploadTask uploadtask=  ref.putFile(File(path));
                           TaskSnapshot snapshots=await uploadtask;
                           String downloadurl=await snapshots.ref.getDownloadURL();


                          FirebaseFirestore   firestore = FirebaseFirestore.instance;
                          var uuid = Uuid().v4();

                          //var id=1;
                          final recordng= <String, String>{
                            "id": uuid.toString(), //uuid
                            "downloadurl": downloadurl,
                          };

                          firestore
                              .collection("myrecordngs")
                              .doc(uuid.toString()) //uuid
                              .set(recordng)
                              .onError((e, _) => print("Error writing document: $e"));






                        } else {
                          print("Error in Store");
                        }
                        setState(() {
                          isshow = !isshow;
                        });

                      },
                      icon: Icon(Icons.pause)),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: IconButton(
                      onPressed: () {
                        startStopwatch();
                        startRecording();
                        setState(() {
                          isshow = !isshow;
                        });
                      },
                      icon: Icon(Icons.play_arrow)),
                ),
              ),
              IconButton(onPressed: (){
                resetStopwatch();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>files()));
              }, icon: Icon(Icons.folder))
            ],
          )
        ],
      ),
    );
  }
}
