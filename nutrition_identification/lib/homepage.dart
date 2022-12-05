import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_identification/main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isWorking = false;
  String result = '';
  CameraController? cameraController;
  CameraImage? imgCamera;

  initCamera()
  {
    cameraController =CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value)
    {
      if(!mounted)
        {
          return;
        }

      setState((){
        cameraController!.startImageStream((imageFromStream) =>
        {
          if(!isWorking)
            {
              isWorking = true,
              imgCamera = imageFromStream,
            }
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
