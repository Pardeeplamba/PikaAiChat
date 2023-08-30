import 'dart:ui';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants.dart';
import '../../utils/apikey.dart';
import 'chatmessage.dart';
import 'threedots.dart';
import 'package:rive/rive.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RiveAnimationController _btnAnimationController;
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;

  bool _isTyping = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    chatGPT = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(receiveTimeout: 60000));
    super.initState();
  }

  @override
  void dispose() {
    chatGPT?.close();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();


      final request =
      CompleteText(prompt: message.text, model: kTranslateModelV3);

      final response = await chatGPT!.onCompleteText(request: request);
      Vx.log(response!.choices[0].text);
      insertNewData(response.choices[0].text);

  }

  void insertNewData(String response) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
    Expanded(
    child: Container(
    alignment: Alignment.center,
      height: 44,
      padding: const EdgeInsets.symmetric(
          horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor2.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      // BoxDecoration
      child: Center(
        child: TextField(
          keyboardType: TextInputType.text,
          controller: _controller,
          onSubmitted: (value) => _sendMessage(),
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            hintText: "Let's start here",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ), // InputDecoration
        ),
      ), // TextFormField
    ), // Container
    ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _sendMessage();
              },
            ),

          ],
        ),


      ],
    ).px16();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Stack(

          children: [
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              left: 100,
              bottom: 100,
              child: Image.asset(
                "assets/Backgrounds/Spline.png",
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            const RiveAnimation.asset(
              "assets/RiveAssets/shapes.riv",
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),
            AnimatedPositioned(
              top:  0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 260),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                  child:  Column(
                children: [
                Flexible(
                child: ListView.builder(
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                )),
                if (_isTyping) const ThreeDots(),
            const Divider(
              height: 2.0,
            ),
            Container(

              child: _buildTextComposer(),
            )
          ],
      ),
                ),
              ),
            ),
          ],

      ),
    );
  }
}
