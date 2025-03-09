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
  Object? _room;
  Object? _obj1;
  late AnimationController _controller;
  late Animation<Vector3> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // timing
      vsync: this, // vsync, synchronized
    );

    _animation = Tween<Vector3>(
      begin: Vector3(0, 0, 0), // x, y, z
      end: Vector3(1, 0, 1), // Move 1 unit in the x and z directions
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _animation.addListener(() {
      if (_obj1 != null) {
        // Move obj1 around
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
      scale: Vector3(6, 7, 3), // obj1 dimensions
      position: Vector3(-3, 0.5, 0), // Position inside the room
      fileName: 'assets/name.obj',
    ); // Use a name model
    // Add the smaller objects to the scene
    scene.world
        .add(_obj1!); //! assets var that might be null, is not null at runtime

    // Update the state to ensure the dimensions are displayed correctly
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the dimensions of the room in meters
    final roomDimensions = _room != null
        ? 'Room Dimensions: ${_room!.scale.x}m x ${_room!.scale.y}m x ${_room!.scale.z}m'
        : 'Room Dimensions: N/A';

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
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              roomDimensions,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//------------------Box with data points
// '''

// var x = 0;
// var y = 2;
// var z = 2;  // Example value for z


// var data = [
//     [0, 0, 0], [1, 0, 0],   // Line A-B
//     [1, 0, 2], [0, 0, 2], [0, 0, 0],
//     [0, 1, 0], [1, 1, 0], [1, 0, 0], [1, 0, 2],
//     [1, 1, 2], [1, 1, 0], [0, 1, 0], [0, 1, 2],
//     [0, 0, 2], [1, 0, 2], [1, 1, 2], [0, 1, 2]
// ];


// // Replace 2 with z
// for (var i = 0; i < data.length; i++) {
//     for (var j = 0; j < data[i].length; j++) {
//         if (data[i][j] === 2) {
//             data[i][j] = z;
//         }
//         if (j == 0) {
//           data[i][j] += x;
//         }
//         if (j == 1) {
//           data[i][j] += y;
//         }
//     }
// }

// var option = {
//   tooltip: {},
//   backgroundColor: '#fff',
//   visualMap: {
//     show: false,
//     dimension: 2,
//     min: 0,
//     max: 30,
//     inRange: {
//       color: [
//         '#313695',
//         '#4575b4',
//         '#74add1',
//         '#abd9e9',
//         '#e0f3f8',
//         '#ffffbf',
//         '#fee090',
//         '#fdae61',
//         '#f46d43',
//         '#d73027',
//         '#a50026'
//       ]
//     }
//   },
//   //dimentions of static boundary box`
//   xAxis3D: {
//     type: 'value',
//     min: -1.80,  // x-min
//     max: 1.8    // x-max
//   },
//   yAxis3D: {
//     type: 'value',
//     min: 0,   // y-min
//     max: 5.5    // y-max
//   },
//   zAxis3D: {
//     type: 'value',
//     min: 0,     // z-min
//     max: 2.0    // z-max
//   },
//   grid3D: {
//     // boxWidth: 3.6,  // Difference between x-max and x-min (1.8 - (-1.8))
//     // boxHeight: 5.3, // Difference between y-max and y-min (5.5 - 0.2)
//     // boxDepth: 2.0,  // Difference between z-max and z-min (2.0 - 0)
//     viewControl: {
//       projection: 'orthographic'
//     }
//   },
//   series: [{
//           'type': 'line3D',
//           'data': data,
//           'lineStyle': {
//             'width': 4
//           }
//         }]
// };

// '''


//---------------- Got box
//  corect order of lines to make rectangle
// var data = [ 
//         [0, 0, 0], [1, 0, 0],   // Line A-B
//         [1, 0, 1],   [1, 1, 0]
//         [1, 1,1], [1,1,0]
//         [0,0,1], [1,1,1]
        
//           [1, 1, 0], [1, 1, 0],   // Line C-D
//           [0, 1, 0], [0, 0, 0],   // Line D-A
//           [0, 0, 1], [1, 0, 1],   // Line B-C
         
//           [1,1,1], [0,1,1],
//           [0,0,1], [0,1,1],
//           [0,1,0], [1,1,0], [1,0,0] //cube
//           ];

// var option = {
//   tooltip: {},
//   backgroundColor: '#fff',
//   visualMap: {
//     show: false,
//     dimension: 2,
//     min: 0,
//     max: 30,
//     inRange: {
//       color: [
//         '#313695',
//         '#4575b4',
//         '#74add1',
//         '#abd9e9',
//         '#e0f3f8',
//         '#ffffbf',
//         '#fee090',
//         '#fdae61',
//         '#f46d43',
//         '#d73027',
//         '#a50026'
//       ]
//     }
//   },
//   //dimentions of static boundary box`
//   xAxis3D: {
//     type: 'value',
//     min: -1.80,  // x-min
//     max: 1.8    // x-max
//   },
//   yAxis3D: {
//     type: 'value',
//     min: 0,   // y-min
//     max: 5.5    // y-max
//   },
//   zAxis3D: {
//     type: 'value',
//     min: 0,     // z-min
//     max: 2.0    // z-max
//   },
//   grid3D: {
//     // boxWidth: 3.6,  // Difference between x-max and x-min (1.8 - (-1.8))
//     // boxHeight: 5.3, // Difference between y-max and y-min (5.5 - 0.2)
//     // boxDepth: 2.0,  // Difference between z-max and z-min (2.0 - 0)
//     viewControl: {
//       projection: 'orthographic'
//     }
//   },
//   series: [{
//           'type': 'line3D',
//           'data': data,
//           'lineStyle': {
//             'width': 4
//           }
//         }]
// };
