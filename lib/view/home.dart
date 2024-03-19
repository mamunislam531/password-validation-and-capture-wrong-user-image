import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 0;
  XFile? images;

  Future<String?> takePic() async {
    final camera = (await availableCameras())[1];
    final controller = CameraController(camera, ResolutionPreset.high);
    try {
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      final image = await controller.takePicture();
      controller.dispose();
      images = image;
      setState(() {});
      return image.path;
    } catch (e) {
      controller.dispose();
      return null;
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text("Try to unlock this app"),
            const SizedBox(
              height: 20,
            ),
            count > 0 ? Text("Wrong password try : $count") : const Text(""),
            Form(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.toString() == "") {
                      return "Enter password";
                    } else if (value.toString() != "mamun") {
                      return "Wrong password, try again";
                    }
                    return null;
                  },
                ),
              ),
            ),
            count < 3
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        if (!formKey.currentState!.validate()) {
                          count++;
                          if (count > 2) {
                            takePic();
                          }
                          return;
                        }
                      });
                    },
                    child: const Card(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        child: Text(
                          "Enter",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                : const Text(""),
            const SizedBox(
              height: 20,
            ),
            images == null
                ? const Text("")
                : Column(
                    children: [
                      Image.file(
                        File(images!.path),
                        height: 300,
                        width: 280,
                        fit: BoxFit.fill,
                      ),
                      const Text(
                        "You are wrong user...!!!",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )
                    ],
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          count = 0;
          images = null;
          controller.clear();
          setState(() {});
        },
        child: const Icon(Icons.lock_reset_sharp),
      ),
    );
  }
}
