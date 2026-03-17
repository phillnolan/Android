import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';
import 'image_editor_screen.dart';

class DetailScreen extends StatefulWidget {
  final Note? note;
  const DetailScreen({super.key, this.note});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _noteId;
  String? _imageUrl;
  File? _localImageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteId = widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _imageUrl = widget.note?.imageUrl;
  }

  Future<void> _pickAndEditImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      if (!mounted) return;
      
      // Mở trình chỉnh sửa ảnh
      final File? editedFile = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageEditorScreen(imageFile: imageFile)),
      );

      if (editedFile != null) {
        setState(() {
          _localImageFile = editedFile;
          _imageUrl = null; 
        });
      }
    }
  }

  Future<void> _saveNote() async {
    if (_isSaving) return;
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty && _localImageFile == null && _imageUrl == null) return;

    _isSaving = true;
    String? finalImageUrl = _imageUrl;

    try {
      if (_localImageFile != null) {
        finalImageUrl = await _firestoreService.uploadImage(_localImageFile!, _noteId);
      }

      final noteToSave = Note(
        id: _noteId,
        title: title.isEmpty ? 'Không có tiêu đề' : title,
        content: content,
        lastModified: DateTime.now(),
        imageUrl: finalImageUrl,
      );

      await _firestoreService.saveNote(noteToSave).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Lỗi lưu: $e');
    } finally {
      _isSaving = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _saveNote();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () async {
              await _saveNote();
              if (mounted) Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: _pickAndEditImage,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              if (_localImageFile != null)
                Image.file(_localImageFile!, height: 250, fit: BoxFit.cover)
              else if (_imageUrl != null)
                Image.network(_imageUrl!, height: 250, fit: BoxFit.cover),
              
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Tiêu đề...',
                  hintStyle: TextStyle(color: primaryColor.withOpacity(0.3)),
                  fillColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 0.5),
              TextField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(fontSize: 18, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Bắt đầu ghi chú mây của bạn...',
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
