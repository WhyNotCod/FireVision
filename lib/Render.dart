// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
//import 'package:three_dart/three_dart.dart' as three;
import 'package:vector_math/vector_math_64.dart';

class Render extends StatefulWidget {
  const Render({super.key});

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _room;
  Object? _name;
  late AnimationController _controller;

  void _onSceneCreated(Scene scene) async {
    _scene = scene;
    scene.camera.position.z = 10; // Adjust camera position

    // Create a large cube to represent the room
    _room = Object(
      scale: Vector3(20.0, 20.0, 20.0), // Room dimensions
      position: Vector3(0, 0, 0),
      fileName: 'assets/file.obj', // Use a cube model
      backfaceCulling: true,
    );

    // Add the room to the scene
    scene.world.add(_room!);

    // Create smaller rectangular objects (e.g., furniture)
    _name = Object(
      scale: Vector3(3.0, 1.0, 2.0), // name dimensions
      position: Vector3(0, 0, 0), // Position inside the room
      fileName: 'assets/name.obj',
    ); // Use a name model
    //material: Material(color: Colors.blue[300]));
    // Add the smaller objects to the scene
    scene.world
        .add(_name!); //! assets var that might be null, is not null at runtime
    //scene.world.add(chair);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("3D Room"),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (_room != null) {
                  _room!.rotation.x += details.delta.dy / 100;
                  _room!.rotation.y += details.delta.dx / 100;
                  _room!.updateTransform();
                }
                _scene.update();
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
//------------------------------------------------

// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:flutter_cube/flutter_cube.dart';

// class Render extends StatefulWidget {
//   const Render({super.key});

//   //final String? title;

//   @override
//   State<Render> createState() => _RenderState();
// }

// class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
//   late Scene _scene;
//   Object? _cube;
//   Object? _lightBlueObject;
//   late AnimationController _controller;

//   //Object? _c;
//   void _onSceneCreated(Scene scene) async {
//     _scene = scene;
//     scene.camera.position.z = 5; //decr # moves camera closer
//     // _cube = Object(
//     //     scale: Vector3(5.0, 5.0, 5.0),
//     //     backfaceCulling: true,
//     //     fileName: 'assets/file.obj');

//     _cube = Object(
//         scale: Vector3(10.0, 10.0, 10.0),
//         backfaceCulling: true,
//         fileName: 'assets/file.obj');

//     // Light blue object
//     _lightBlueObject = Object(
//       scale: Vector3(2.0, 2.0, 2.0), // Adjust the scale as needed
//       position: Vector3(0.0, -4.0,
//           0.0), // Position it in the middle of the cube, touching the bottom face
//       backfaceCulling: true,
//       fileName: 'assets/name.obj',
//     );
//     _cube!.add(_lightBlueObject!);

//     scene.world.add(_cube!);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

// //work
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Fire_3D"),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 if (_cube != null) {
//                   _cube!.rotation.x += details.delta.dy / 100;
//                   _cube!.rotation.y += details.delta.dx / 100;
//                   _cube!.updateTransform();
//                   _scene.update();
//                 }
//               },
//               child: Cube(onSceneCreated: _onSceneCreated),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Back'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
