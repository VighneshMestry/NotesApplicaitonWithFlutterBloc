import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();


// Generics is required to produce dufferent values. Generic function that can, based on what is provided is able to return the value.
Future<T?> showGenericDialog<T> ({
  // The context used in the showDialog refers to this BuilderContext. Try changing the name of the following BuildContext.
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  // Below the whole statement returns the number of button which is required by the user in the dialogBox along with the text and the required datatype according to output
  // So the whole statement converts the value received from the map which is given by the user to the UI dialog box's buttons.
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if(value != null){
                Navigator.of(context).pop(value);
              }else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle));
        }).toList(),
      );
    },
  );
   
}