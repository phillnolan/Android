import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndSaveImage({bool fromCamera = false}) async {
    // Request permissions
    try {
      if (fromCamera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return null;
      } else {
        // request storage or photos permission depending on platform
        final photos = Permission.photos;
        final storage = Permission.storage;
        final pStatus = await photos.request();
        final sStatus = await storage.request();
        if (!pStatus.isGranted && !sStatus.isGranted) return null;
      }
    } catch (_) {}

    final XFile? xfile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (xfile == null) return null;
    final bytes = await xfile.readAsBytes();
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(xfile.path)}';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<void> deleteFileIfExists(String? path) async {
    if (path == null) return;
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
