import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog (
  BuildContext context, 
  String content
  ) {
  return showGenericDialog(context: context,
    title: 'An Error Occured', 
    content: content, 
    optionsBuilder: () => {
      'OK' : null,
    }
  );
}