import 'dart:io';
// removed unused import
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  Stroke({required this.points, required this.color, required this.strokeWidth});
}

class ImageEditorScreen extends StatefulWidget {
  final String imagePath;
  const ImageEditorScreen({super.key, required this.imagePath});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  ui.Image? _image;
  List<Stroke> _strokes = [];
  Stroke? _current;
  Color? _color;
  double _strokeWidth = 4.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _color ??= Theme.of(context).colorScheme.primary;
  }

  Future<void> _loadImage() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    setState(() => _image = frame.image);
  }

  void _start(Offset pos) {
    final fallback = Theme.of(context).colorScheme.onSurface;
    _current = Stroke(points: [pos], color: _color ?? fallback, strokeWidth: _strokeWidth);
    setState(() {});
  }

  void _update(Offset pos) {
    if (_current == null) return;
    _current!.points.add(pos);
    setState(() {});
  }

  void _end() {
    if (_current != null) {
      _strokes.add(_current!);
      _current = null;
    }
    setState(() {});
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      _strokes.removeLast();
      setState(() {});
    }
  }

  void _clear() {
    _strokes.clear();
    setState(() {});
  }

  Future<String?> _saveEditedImage() async {
    if (_image == null) return null;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, _image!.width.toDouble(), _image!.height.toDouble()));
    // draw original image
    final paint = Paint();
    canvas.drawImage(_image!, Offset.zero, paint);
    // scale factor from display to actual image assumed 1:1 since we render in image pixels
    // draw strokes
    for (final s in _strokes) {
      final pnt = Paint()
        ..color = s.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = s.strokeWidth;
      final path = Path();
      if (s.points.isNotEmpty) {
        path.moveTo(s.points.first.dx, s.points.first.dy);
        for (var i = 1; i < s.points.length; i++) {
          path.lineTo(s.points[i].dx, s.points[i].dy);
        }
        canvas.drawPath(path, pnt);
      }
    }
    final picture = recorder.endRecording();
    final img = await picture.toImage(_image!.width, _image!.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa ảnh'),
        actions: [
          IconButton(onPressed: _undo, icon: const Icon(Icons.undo)),
          IconButton(onPressed: _clear, icon: const Icon(Icons.clear)),
          IconButton(
              onPressed: () async {
                final path = await _saveEditedImage();
                if (!mounted) return;
                Navigator.of(context).pop(path);
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: _image == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    // fit image into available space while keeping aspect
                    final scale = 
                        constraints.maxWidth / _image!.width < constraints.maxHeight / _image!.height
                            ? constraints.maxWidth / _image!.width
                            : constraints.maxHeight / _image!.height;
                    final displayW = _image!.width * scale;
                    final displayH = _image!.height * scale;
                    return Center(
                      child: GestureDetector(
                        onPanStart: (e) {
                          final pos = e.localPosition;
                          _start(Offset(pos.dx / scale, pos.dy / scale));
                        },
                        onPanUpdate: (e) {
                          final pos = e.localPosition;
                          _update(Offset(pos.dx / scale, pos.dy / scale));
                        },
                        onPanEnd: (_) => _end(),
                        child: SizedBox(
                          width: displayW,
                          height: displayH,
                          child: CustomPaint(
                            painter: _ImagePainter(image: _image!, strokes: _strokes, current: _current, scale: scale),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Builder(builder: (context) {
                        final cs = Theme.of(context).colorScheme;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () => setState(() => _color = cs.primary), icon: Icon(Icons.brush, color: cs.primary)),
                            IconButton(onPressed: () => setState(() => _color = cs.secondary), icon: Icon(Icons.brush, color: cs.secondary)),
                            IconButton(onPressed: () => setState(() => _color = cs.tertiary ?? cs.primary), icon: Icon(Icons.brush, color: cs.tertiary ?? cs.primary)),
                          ],
                        );
                      }),
                      Slider(value: _strokeWidth, min: 1, max: 20, onChanged: (v) => setState(() => _strokeWidth = v)),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;
  final List<Stroke> strokes;
  final Stroke? current;
  final double scale;
  _ImagePainter({required this.image, required this.strokes, this.current, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    // src not used
    // draw image scaled to size
    paintImage(canvas: canvas, rect: dst, image: image, fit: BoxFit.fill);
    // draw strokes scaled to display
    for (final s in strokes) {
      final p = Paint()
        ..color = s.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = s.strokeWidth * scale;
      final path = Path();
      if (s.points.isNotEmpty) {
        path.moveTo(s.points.first.dx * scale, s.points.first.dy * scale);
        for (var i = 1; i < s.points.length; i++) {
          path.lineTo(s.points[i].dx * scale, s.points[i].dy * scale);
        }
        canvas.drawPath(path, p);
      }
    }
    if (current != null) {
      final cp = Paint()
        ..color = current!.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = current!.strokeWidth * scale;
      final path = Path();
      if (current!.points.isNotEmpty) {
        path.moveTo(current!.points.first.dx * scale, current!.points.first.dy * scale);
        for (var i = 1; i < current!.points.length; i++) {
          path.lineTo(current!.points[i].dx * scale, current!.points[i].dy * scale);
        }
        canvas.drawPath(path, cp);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
