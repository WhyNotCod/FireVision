// ignore_for_file: file_names

//------------------------------------------------

// // ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Render extends StatefulWidget {
  const Render({super.key});

  //final String? title;

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  Object? _lightBlueObject;
  late AnimationController _controller;

  //Object? _c;
  void _onSceneCreated(Scene scene) async {
    _scene = scene;
    scene.camera.position.z = 5; //decr # moves camera closer
    // _cube = Object(
    //     scale: Vector3(5.0, 5.0, 5.0),
    //     backfaceCulling: true,
    //     fileName: 'assets/file.obj');

    _cube = Object(
        scale: Vector3(10.0, 10.0, 10.0),
        backfaceCulling: true,
        fileName: 'assets/file.obj');

    // Light blue object
    _lightBlueObject = Object(
      scale: Vector3(2.0, 2.0, 2.0), // Adjust the scale as needed
      position: Vector3(0.0, -4.0,
          0.0), // Position it in the middle of the cube, touching the bottom face
      backfaceCulling: true,
      fileName: 'assets/name.obj',
    );
    _cube!.add(_lightBlueObject!);

    scene.world.add(_cube!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//work
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Fire_3D"),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (_cube != null) {
                  _cube!.rotation.x += details.delta.dy / 100;
                  _cube!.rotation.y += details.delta.dx / 100;
                  _cube!.updateTransform();
                  _scene.update();
                }
              },
              child: Cube(onSceneCreated: _onSceneCreated),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}
