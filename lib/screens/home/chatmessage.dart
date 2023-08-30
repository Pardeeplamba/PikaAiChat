import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatMessage extends StatelessWidget {
   ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
    });

  final String text;
  final String sender;
  final FlutterTts flutterTt= FlutterTts();

  @override
  Widget build(BuildContext context) {
    Future speak() async{
      await flutterTt.speak(text);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              child: Text(sender,style: TextStyle(color:sender == "user" ? Vx.red200 : Vx.green200),)
                  .text
                  .make()


            ),
            SizedBox(height: 5,),
            sender=="bot" ?InkWell(
            onTap: (){
    FlutterClipboard.copy(text.trim()).then(( value ) =>
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
            Text("Copied"),
          ),
        )

    );

    },
            child: Container(
                width: 60,
                height: 60,
                child: Lottie.asset('assets/lottie/copy.json'))
              ,):Text(" "),
            SizedBox(height: 5,),

            sender=="bot" ?InkWell(
              onTap: (){
speak();

              },
              child: Container(
                  width: 60,
    height: 60,
                  child: Lottie.asset('assets/lottie/speak.json'))
              ,):Text(" "),

          ],
        ),
        Expanded(
          child:  text.trim().text.bodyText1(context).make().px8(),
        ),
      ],
    ).py8();
  }
}
