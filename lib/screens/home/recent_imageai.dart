import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


class RecentImagePage extends StatefulWidget {
  const RecentImagePage({super.key});

  @override
  State<RecentImagePage> createState() => _RecentImagePageState();
}

class _RecentImagePageState extends State<RecentImagePage> {
  late RiveAnimationController _btnAnimationController;
  List imgList = [];
  getImages() async {
    final directory = Directory("storage/emulated/0/ImageAI");
    imgList = directory.listSync();
  }
  popImage(filepath) {
    showDialog(
        context: context,
        builder: (context) => Dialog( shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ), // RoundedRectangleBorder
          child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration ( color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ), // BoxDecoration
          child: Image.file(filepath),
// Container
        ))); // Dialog
  }


  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    padding: const EdgeInsets.symmetric (horizontal: 16.0, vertical: 8),
    child: GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    ), // SliverGridDelegateWithFixedCrossAxisCount
    itemCount: imgList.length,
    itemBuilder: (BuildContext context, int index) {
    return GestureDetector(
    onTap: () {
    popImage (imgList[index]);
    },
    child: Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular (12),
    ), // BoxDecoration
    child: Image.file(imgList[index]),
    ), // Container
    ); // GestureDetector
    } ),
        ),),
    ),
    ],

    );
  }
}
