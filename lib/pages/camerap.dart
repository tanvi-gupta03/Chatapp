import 'package:camera/camera.dart';
import 'package:disapp/pages/finalcam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
late List<CameraDescription> cameras;
class camerapage extends StatefulWidget{
  const camerapage({Key? key}) : super(key: key);

  @override
  State<camerapage> createState() => _camerapageState();
}

class _camerapageState extends State<camerapage> {
  late CameraController _cameraController;
  late Future<void> cameravalue;
  void takePhoto(BuildContext context) async {
  try {
    XFile? picture = await _cameraController.takePicture();
    if (picture != null) {
      // Picture was taken successfully
      // Navigate to the next page or handle the picture accordingly
      Navigator.push(context, MaterialPageRoute(builder: (context) => FinalCameraPage(imagePath: picture.path)));
    } else {
      // Picture was not taken successfully
      // Handle the error, show a dialog, or perform any other necessary action.
      print("Failed to take picture");
    }
  } catch (e) {
    print("Error taking picture: $e");
    // Handle the error, show a dialog, or perform any other necessary action.
  }
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController= CameraController(cameras[0], ResolutionPreset.high);
    cameravalue= _cameraController.initialize();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(future: cameravalue, builder: (context ,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return CameraPreview(_cameraController);
            }
            else{
              return CircularProgressIndicator();
            }
          }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.flash_off,color: Colors.white,size: 20,)),
                      IconButton(onPressed: (){
                        takePhoto(context);
                      }, icon: Icon(Icons.circle_rounded,color: Colors.white,size: 50,)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.flip_camera_ios,color: Colors.white,size: 20,)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}