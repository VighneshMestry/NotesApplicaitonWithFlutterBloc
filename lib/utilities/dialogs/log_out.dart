import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog (BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Log out', 
    content: 'Are you sure you want to logout', 
    optionsBuilder: () => {
      'Cancel' : false,
      'Logout' : true,
    },
  ).then(
    (value) => value ?? false
  );
}