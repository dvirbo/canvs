import 'dart:ui';
import 'package:flutter/material.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({Key? key}) : super(key: key);

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<CanvasPoint?> canvasPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canvas"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                canvasPoints.clear();
              });
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Listener(
        onPointerDown: (e) {
          print(e.timeStamp);
          print(e.localPosition);
          print(e.tilt);
          print(e.pressure);

          setState(() {
            addPoint(e);
          });
        },
        onPointerMove: (e) {
          print(e.timeStamp);
          print(e.localPosition);
          print(e.tilt);
          print(e.pressure);

          setState(() {
            addPoint(e);
          });
        },
        onPointerUp: (e) {
          setState(() {
            canvasPoints.add(null);
          });
        },
        child: CustomPaint(
          painter: CanvasPainter(
            canvasPoints: canvasPoints,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }

  addPoint(details) {
    Paint paint = Paint();

    paint.color = Colors.red;
    paint.isAntiAlias = true;
    paint.strokeWidth = 1;
    paint.strokeCap = StrokeCap.round;

    canvasPoints.add(CanvasPoint(details.localPosition, paint));
  }
}

class CanvasPainter extends CustomPainter {
  final List<CanvasPoint?> canvasPoints;

  List<Offset> offsetsList = [];

  CanvasPainter({
    required this.canvasPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < canvasPoints.length; i++) {
      // if (i == canvasPoints.length - 1) continue;

      if (canvasPoints[i] != null &&
          (i == canvasPoints.length - 1 || canvasPoints[i + 1] == null)) {
        offsetsList.clear();
        offsetsList.add(canvasPoints[i]!.offset);

        canvas.drawPoints(
          PointMode.points,
          offsetsList,
          canvasPoints[i]!.paint,
        );
      } else if (canvasPoints[i] != null && canvasPoints[i + 1] != null) {
        canvas.drawLine(
          canvasPoints[i]!.offset,
          canvasPoints[i + 1]!.offset,
          canvasPoints[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CanvasPoint {
  Offset offset;
  Paint paint;

  CanvasPoint(this.offset, this.paint);
}
