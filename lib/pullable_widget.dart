import 'package:flutter/material.dart';

class PullableWidget extends StatefulWidget {
  final VoidCallback onPull;

  PullableWidget({required this.onPull});

  @override
  _PullableWidgetState createState() => _PullableWidgetState();
}

class _PullableWidgetState extends State<PullableWidget> {
  double _position = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Set height to screen height
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _position += details.delta.dy;
            if (_position < 0) _position = 0;
            if (_position > MediaQuery.of(context).size.height) {
              _position = MediaQuery.of(context).size.height;
            }
          });
        },
        onVerticalDragEnd: (details) {
          if (_position > 50) {
            widget.onPull();
          }
          setState(() {
            _position = 100.0;
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, _position),
              painter: RopePainter(),
            ),
            Positioned(
              top: _position - 60,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: Container(
                width: 40,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'PULL',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
