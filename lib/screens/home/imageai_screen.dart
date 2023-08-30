import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';


import '../../apiservice/api_services.dart';
import '../../constants.dart';

class ImageAiPage extends StatefulWidget {
  const ImageAiPage({Key? key}) : super(key: key);

  @override
  State<ImageAiPage> createState() => _ImageAiPageState();
}

class _ImageAiPageState extends State<ImageAiPage> {
  var sizes = ["Small", "Medium", "Large"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropValue;
  var textController = TextEditingController();
  var isloaded = false;
  String image = "";
  ScreenshotController screenshotController = ScreenshotController();
  shareImage() async {
    await screenshotController
        .capture(delay: const Duration (milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        const filename = "share.png";
        final imgpath = await File("$directory/$filename").create();
        await imgpath.writeAsBytes(img);
        Share.shareFiles([imgpath.path], text: "ImageAI");
      } else {
        print("Failed to take a screenshot");
      }
    });
  }
  downloadImg() async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      const foldername = "AI Image";
      final path = Directory("storage/emulated/0/$foldername");
      final filename = "${DateTime
          .now()
          .millisecondsSinceEpoch}.png";
      if (await path.exists()) {
        await screenshotController.captureAndSave(path.path,
            delay: const Duration (milliseconds: 100),
            fileName: filename,
            pixelRatio: 1.0);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Downloaded to ${path.path}"),
            )); // SnackBar
      } else {
        await path.create();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission denied"),
          )); // SnackBar
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: Stack(
          children: [
            Positioned(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1.7,
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
              top: 0,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              duration: const Duration(milliseconds: 260),
              child: Container(

                margin: EdgeInsets.only(left:18,right:18,top:18,bottom:100),
                child: Column(

                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: backgroundColor2.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // BoxDecoration
                                  child: Center(
                                    child: TextFormField(
                                      controller: textController,
                                      textAlign: TextAlign.left,
                                      decoration: const InputDecoration(
                                        hintText: "eg 'A monkey on moon",
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                      ), // InputDecoration
                                    ),
                                  ), // TextFormField
                                ), // Container
                              ),
                              const SizedBox(width: 12),
                              Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                // BoxDecoration child: DropdownButtonHideUnderline(
                                child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                icon: const Icon (Icons.expand_more, color: Colors.black),
        value: dropValue,
        hint: const Text ("Select size"),
        items: List.generate(
        sizes.length,
        (index) => DropdownMenuItem(
        value: values[index],
        child: Text (sizes [index]),
        ), // DropdownMenuItem
        ), onChanged: (value) {
setState(() {
  dropValue = value.toString();

});                                }, // List.generate onChanged: (value) {},

                                  ),

                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 44,
                            width: 200,
                            child: ElevatedButton(
                              child: Text('Generate'),
                              onPressed: () async {
                                if (textController.text.isNotEmpty &&
                                    dropValue!.isNotEmpty) {
                                  setState(() {
                                    isloaded = false;
                                  });

                                  image = await Api.generateImage(
                                      textController.text, dropValue!);
                                  setState(() {
                                    isloaded = true;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text("Please pass the query and size"),
                                    ),
                                  );
                                }
                                ;
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: backgroundColor2.withOpacity(0.8)),
                            ),
                          )
                          //
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: isloaded
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Screenshot(
                                  controller:screenshotController,
                                  child: Image.network(image))),
                          SizedBox(height: 20),

                          Row(children: [
                            Expanded(
                              child: ElevatedButton.icon(onPressed: () {

                              },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(8)),

                                  icon: Icon(Icons.download),
                                  label: Text('Download')),
                            ),
                            SizedBox(width: 8,),
                            ElevatedButton.icon(onPressed: () async {
await shareImage();
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content:
    Text("Image Shared"),
  ),
);

                            },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8)),

                                icon: Icon(Icons.share), label: Text('Share')),

                          ],),
                        ],

                      )
                          : Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ), // BoxDecoration
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/Backgrounds/Spline.png"),
                            const SizedBox(height: 12),
                            const Text(
                              "Waiting for image to be generated...",
                              style: TextStyle(
                                fontSize: 16.0,
                              ), // TextStyle
                            ) // Text
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
