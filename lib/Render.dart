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
  Object? _obj1;
  late AnimationController _controller;
  late Animation<Vector3> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), //timing
      vsync: this, //vsync, synchronised
    );

    _animation = Tween<Vector3>(
      begin: Vector3(0, 0, 0), //x, y, z
      end: Vector3(1, 0, 1), // Move 10 units in the x direction, x, z, y
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _animation.addListener(() {
      if (_obj1 != null) {
        //move name obj around
        _obj1!.position.setFrom(_animation.value);
        _obj1!.updateTransform();
        _scene.update();
      }
    });

    _controller.repeat(reverse: true); // Repeat the animation back and forth
  }

  void _onSceneCreated(Scene scene) async {
    _scene = scene;
    scene.camera.position.z =
        20; // Adjust camera position, smaller is closer to camera

    // Create a large cube to represent the room
    _room = Object(
      scale: Vector3(60.0, 60.0, 60.0), // Room dimensions
      position: Vector3(0, 0, 0),
      fileName: 'assets/file.obj', // Use a cube model
      backfaceCulling: true,
    );

    // Add the room to the scene
    scene.world.add(_room!);

    // Create smaller rectangular objects (e.g., furniture)
    _obj1 = Object(
      scale: Vector3(6.0, 7.0, 3.0), // name dimensions
      position: Vector3(-3, 0.5, 0), // Position inside the room
      fileName: 'assets/name.obj',
    ); // Use a name model
    //material: Material(color: Colors.blue[300]));
    // Add the smaller objects to the scene
    scene.world
        .add(_obj1!); //! assets var that might be null, is not null at runtime
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
                  _room!.rotation.x += details.localPosition.dy / 100;
                  _room!.rotation.y += details.localPosition.dx / 100;
                  //_room!.rotation.z += details.localPosition.dx / 100;
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
