import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../services/file_service.dart';
import 'image_editor_screen.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late Note _note;
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _note = widget.note ?? Note.createNew();
    _titleCtrl = TextEditingController(text: _note.title);
    _contentCtrl = TextEditingController(text: _note.content);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(_onWillPop);
  }

  @override
  void dispose() {
    ModalRoute.of(context)?.removeScopedWillPopCallback(_onWillPop);
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await _autoSave();
    return true;
  }

  Future<void> _autoSave() async {
    _note.title = _titleCtrl.text;
    _note.content = _contentCtrl.text;
    _note.updatedAt = DateTime.now();
    final notes = StorageService.loadNotes();
    final idx = notes.indexWhere((n) => n.id == _note.id);
    if (idx >= 0) {
      notes[idx] = _note;
    } else {
      notes.add(_note);
    }
    await StorageService.saveNotes(notes);
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Soạn ghi chú'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration.collapsed(hintText: 'Tiêu đề'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                    IconButton(
                    onPressed: () async {
                      final path = await FileService.pickAndSaveImage(fromCamera: false);
                      if (path != null) {
                        setState(() {
                          _note.imagePaths.add(path);
                        });
                        await _autoSave();
                      }
                    },
                    icon: const Icon(Icons.photo_library),
                    tooltip: 'Chọn ảnh',
                  ),
                  IconButton(
                    onPressed: () async {
                      final path = await FileService.pickAndSaveImage(fromCamera: true);
                      if (path != null) {
                        setState(() {
                          _note.imagePaths.add(path);
                        });
                        await _autoSave();
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    tooltip: 'Chụp ảnh',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(dateFmt.format(_note.updatedAt), style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6))),
              ),
              const SizedBox(height: 8),
                    if (_note.imagePaths.isNotEmpty) ...[
                      SizedBox(
                        height: 180,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (c, i) {
                                  final imgPath = _note.imagePaths[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final edited = await Navigator.of(context).push<String?>(
                                              MaterialPageRoute(builder: (_) => ImageEditorScreen(imagePath: imgPath)),
                                            );
                                            if (edited != null && edited.isNotEmpty) {
                                              final old = _note.imagePaths[i];
                                              _note.imagePaths[i] = edited;
                                              await FileService.deleteFileIfExists(old);
                                              await _autoSave();
                                              setState(() {});
                                            }
                                          },
                                          child: Image.file(File(imgPath), fit: BoxFit.cover, width: 280),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: CircleAvatar(
                                    backgroundColor: cs.onSurface.withOpacity(0.45),
                                            child: IconButton(
                                              onPressed: () async {
                                                final old = _note.imagePaths[i];
                                                _note.imagePaths.removeAt(i);
                                                await FileService.deleteFileIfExists(old);
                                                await _autoSave();
                                                setState(() {});
                                              },
                                      icon: Icon(Icons.delete, color: cs.onSurface),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemCount: _note.imagePaths.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
              Expanded(
                child: TextField(
                  controller: _contentCtrl,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(hintText: 'Nội dung...'),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
