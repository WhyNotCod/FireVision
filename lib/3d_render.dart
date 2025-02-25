//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Render extends StatefulWidget {
  const Render({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Render> createState() => _RenderState();
}

class _RenderState extends State<Render> with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;

  Object? _c;
  void _onSceneCreated(Scene scene) async {
    _scene = scene;
    scene.camera.position.z = 50;
    _cube = Object(
        scale: Vector3(5.0, 5.0, 5.0),
        backfaceCulling: true,
        fileName: 'assets/file.obj');
    _c = Object(
        scale: Vector3(5.0, 5.0, 5.0),
        backfaceCulling: true,
        fileName: 'assets/file.obj');
    _cube!.add(_c!);

    scene.world.add(_cube!);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(microseconds: 30000),
      vsync: this)
      ..addListener(() {
        if (_cube != null) {
          _cube!.rotation.y = _controller.value * 360;
          _cube!.updateTransform();
          _scene.update();
        }
      })
    ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title!),),
      body: Center(
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
      
    );
  }
}
