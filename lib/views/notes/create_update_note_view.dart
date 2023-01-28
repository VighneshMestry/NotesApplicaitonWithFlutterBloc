import 'package:flutter/material.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/utilities/generics/get_arguments.dart';
import '../../services/crud/notes_service.dart';

class CreateOrUpdateNoteView extends StatefulWidget {
  const CreateOrUpdateNoteView({super.key});

  @override
  State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
}

class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {

  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {

    final widgetNote = context.getArgument<DatabaseNote>();
    if(widgetNote != null){
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final exisitingNote = _note;
    if(exisitingNote != null) {
      return exisitingNote;
    }
    // Here while entering into the notes view a same user must be created like the Authservice while registering so that the data is stored under the same user.
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);
    final newNote =  await _notesService.createNote(owner : owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if(_textController.text.isEmpty && note != null){
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty () async {
    final note = _note;
    final text = _textController.text;
    if(note != null && text.isNotEmpty){
      await _notesService.updateNote(note: note, text: text);
    }
  }


  /// UPdates and sync the notes in real time.
  void _textControllerListener () async {
    final note = _note;
    if(note == null){
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text); 
  }

  void _setupTextControllerListener ()  {
    //removes the previous note and adds the updated note.'
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState (){
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : const Text('New Note')),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){ 
            case ConnectionState.done:
              _setupTextControllerListener();
              //Take input from user
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText : 'Start typing your note...',
                  ), 
                );
            default:
              return const CircularProgressIndicator();
          }
        },
        
      ),
    );
  }
}