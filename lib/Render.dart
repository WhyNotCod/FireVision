// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Render extends StatefulWidget {
  const Render({super.key});

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;

  void _onSceneCreated(Scene scene) async {
    _scene = scene;
    scene.camera.position.z = 50;

    // Define the vertices of the cube
    final vertices = [
      Vector3(-1, -1, -1),
      Vector3(1, -1, -1),
      Vector3(1, 1, -1),
      Vector3(-1, 1, -1),
      Vector3(-1, -1, 1),
      Vector3(1, -1, 1),
      Vector3(1, 1, 1),
      Vector3(-1, 1, 1),
    ];

    // Define the edges of the cube (pairs of vertex indices)
    final edges = [
      [0, 1], [1, 2], [2, 3], [3, 0], // Back face
      [4, 5], [5, 6], [6, 7], [7, 4], // Front face
      [0, 4], [1, 5], [2, 6], [3, 7], // Connecting edges
    ];

    // Create a custom object for the cube
    _cube = Object(scale: Vector3(5.0, 5.0, 5.0));

    // Add edges to the cube using individual line segments
    for (final edge in edges) {
      final line = Object(
        position: Vector3.zero(),
        mesh: Mesh(
          vertices: [vertices[edge[0]], vertices[edge[1]]],
          indices: [Polygon(0, 1, 2)],
          // Use a custom shader or material to render the lines in red
        ),
      );
      _cube!.add(line);
    }

    scene.world.add(_cube!);
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
        title: const Text("Fire_3D"),
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
//------------------------------------------------

// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:flutter_cube/flutter_cube.dart';
// //import 'package:model_viewer_plus/model_viewer_plus.dart';

// class Render extends StatefulWidget {
//   const Render({super.key});

//   //final String? title;

//   @override
//   State<Render> createState() => _RenderState();
// }

// class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
//   late Scene _scene;
//   Object? _cube;
//   late AnimationController _controller;

//   //Object? _c;
//   void _onSceneCreated(Scene scene) async {
//     _scene = scene;
//     scene.camera.position.z = 50;
//     // _cube = Object(
//     //     scale: Vector3(5.0, 5.0, 5.0),
//     //     backfaceCulling: true,
//     //     fileName: 'assets/file.obj');

//     _cube = Object(
//         scale: Vector3(5.0, 5.0, 5.0),
//         backfaceCulling: true,
//         fileName: 'assets/file.obj');
//     //_cube!.add(_c!);

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
