import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog (BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Delete', 
    content: 'Are you sure you want to delete this item', 
    optionsBuilder: () => {
      'Cancel' : false,
      'Yes' : true,
    },
  ).then(
    (value) => value ?? false
  );
}