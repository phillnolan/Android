import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';

import '../models/note.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  List<Note> _filtered = [];
  final _searchCtrl = TextEditingController();
  // current firebase user id (if signed in)
  String? _uid;

  @override
  void initState() {
    super.initState();
    _load();
    AuthService.authStateChanges().listen((u) async {
      setState(() {
        _uid = u?.uid;
      });
      if (u != null) {
        // try to merge remote notes
        final remote = await FirestoreService.loadNotes(u.uid);
        if (remote.isNotEmpty) {
          // naive merge: append remote notes that don't exist locally
          final existingIds = _notes.map((e) => e.id).toSet();
          final toAdd = remote.where((r) => !existingIds.contains(r.id)).toList();
          if (toAdd.isNotEmpty) {
            _notes.addAll(toAdd);
            await StorageService.saveNotes(_notes);
            _load();
          }
        }
      }
    });
  }

  void _load() {
    final notes = StorageService.loadNotes();
    setState(() {
      _notes = notes;
      _filtered = List.from(_notes.reversed);
    });
  }

  Future<void> _saveAll() async {
    await StorageService.saveNotes(_notes);
  }

  void _onSearch(String q) {
    final ql = q.toLowerCase();
    setState(() {
      _filtered = _notes.reversed
          .where((n) => n.title.toLowerCase().contains(ql))
          .toList();
    });
  }

  Future<void> _openEditor({Note? note}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditScreen(note: note),
    ));
    // reload
    _load();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Hủy')),
              TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('OK')),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Note - Nguyễn Phúc Nguyên - 2251162091'),
        actions: [
          if (_uid == null)
            IconButton(
              tooltip: 'Đăng nhập bằng Google',
              icon: const Icon(Icons.login),
              onPressed: () async {
                try {
                  final cred = await AuthService.signInWithGoogle();
                  if (cred == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập bị huỷ bởi người dùng')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công')));
                    setState(() {
                      _uid = cred.user?.uid;
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập: $e')));
                }
              },
            )
          else
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'signout') await AuthService.signOut();
                if (v == 'upload') {
                  // upload all notes
                  for (final n in _notes) {
                    await FirestoreService.uploadNote(n, _uid!);
                  }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'upload', child: Text('Đồng bộ lên Firebase')),
                const PopupMenuItem(value: 'signout', child: Text('Đăng xuất')),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Builder(builder: (context) {
              final cs = Theme.of(context).colorScheme;
              return TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Tìm kiếm theo tiêu đề...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  filled: true,
                  fillColor: cs.surfaceVariant,
                ),
              );
            }),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note, size: 120, color: cs.onSurface.withOpacity(0.2)),
                        const SizedBox(height: 12),
                        const Text('Bạn chưa có ghi chú nào, hãy tạo mới nhé!'),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final note = _filtered[index];
                        return Dismissible(
                          key: ValueKey(note.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _confirmDelete(context),
                          onDismissed: (_) async {
                            setState(() {
                              _notes.removeWhere((n) => n.id == note.id);
                              _filtered.removeAt(index);
                            });
                            await _saveAll();
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            color: cs.error,
                            child: Icon(Icons.delete, color: cs.onError),
                          ),
                          child: GestureDetector(
                            onTap: () => _openEditor(note: note),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                if (note.imagePaths.isNotEmpty) ...[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.file(File(note.imagePaths.first), height: 120, width: double.infinity, fit: BoxFit.cover),
                                  ),
                                ],
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title.isEmpty ? '(Không có tiêu đề)' : note.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        note.content,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          dateFmt.format(note.updatedAt),
                                          style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = Note.createNew();
          _notes.add(newNote);
          await StorageService.saveNotes(_notes);
          await _openEditor(note: newNote);
          _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
