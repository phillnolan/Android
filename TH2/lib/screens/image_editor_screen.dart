import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class ImageEditorScreen extends StatefulWidget {
  final File imageFile;
  const ImageEditorScreen({super.key, required this.imageFile});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  // Sử dụng Controller cho ImagePainter
  final ImagePainterController _controller = ImagePainterController();

  Future<void> _saveImage() async {
    // Xuất ảnh ra bytes
    final imageBytes = await _controller.exportImage();
    if (imageBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg').create();
      await file.writeAsBytes(imageBytes);
      if (mounted) Navigator.pop(context, file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa ảnh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveImage,
          ),
        ],
      ),
      body: ImagePainter.file(
        widget.imageFile,
        controller: _controller, // Sử dụng controller thay cho key
        scalable: true,
      ),
    );
  }
}
