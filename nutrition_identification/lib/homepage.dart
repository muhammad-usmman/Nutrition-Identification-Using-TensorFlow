import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_identification/main.dart';
import 'package:tflite/tflite.dart';

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
              runModelOnStreamFrames(),
            }
        });
      });
    });

  }

  loadModel()async
  {
    await Tflite.loadModel(
        model:'assets/model.tflite' ,
      labels: 'assets/labels.txt',

    );

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }
  @override
  void dispose() async{
    // TODO: implement dispose
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }

  runModelOnStreamFrames() async
  {
    var recognition = await Tflite.runModelOnFrame(
        bytesList:imgCamera!.planes.map((plane)
        {
          return plane.bytes;
        }).toList(),
      imageHeight: imgCamera!.height,
      imageWidth: imgCamera!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true,

    );

    result = '';
    recognition!.forEach((response)
    {
      result += response['label'] + '   ' +(response['confidence'] as double ).toStringAsFixed(2)+'\n\n';
    });

    setState((){
      result;
    });

    isWorking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
