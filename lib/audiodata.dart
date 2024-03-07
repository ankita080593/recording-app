import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class audiodata extends StatefulWidget {
  final String url;

  const audiodata({
    required this.url,
    super.key,
  });

  @override
  State<audiodata> createState() => _audiodataState();
}

class _audiodataState extends State<audiodata> {
  bool isplay = false;
  //
  // PlayerController controller = PlayerController();

  final player = AudioPlayer();                   // Create a player
  // Create a player


  @override
  Widget build(BuildContext context)
  {
    return Row(children: [
      const Text("Audio.mp3"),
      IconButton(
        onPressed: () async {
          if(isplay){
            player.pause();
          }else {
            await player.setUrl(widget.url);
            player.play();
          }
          setState(() {
            isplay = !isplay;
          });
        },
        icon: isplay
            ? Icon(Icons.pause)
            : Icon(
                Icons.play_circle,
              ),
      )
    ]);
  }
}
