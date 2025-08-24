import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db/notes_database.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;

  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _contentController = TextEditingController(text: widget.note?.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);

    final note = Note(
      id: widget.note?.id,
      title: title,
      content: content,
      createdTime: widget.note?.createdTime ?? DateTime.now(),
    );

    if (widget.note != null) {
      await NotesDatabase.instance.update(note);
    } else {
      await NotesDatabase.instance.create(note);
    }

    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> deleteNote() async {
    setState(() => _isLoading = true);
    await NotesDatabase.instance.delete(widget.note!.id!);
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: deleteNote,
            ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: saveNote,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[100],
                    ),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[100],
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.yellow[200],
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.yellow[100],
                        ),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
