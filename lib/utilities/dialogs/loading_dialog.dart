import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}){
  final dialog = AlertDialog(
    content: Column(
      // Generally a column takes as much space as it needs from the screen but we want to do the job 
      // by using as less space as we can use that's why we set the mainAxisSize by using the widget 
      // mainAxisSize.
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10.0),
        Text(text),
      ],
    ),
  );
  showDialog(
    context : context,
    //barrierDismissible is used to allow or block user to cancel a dialog displayed by clicking outside
    //the dialog or not, false means the dialog cannot be canceled by clicking outside the dialogBox.
    barrierDismissible: false,
    builder :(context) => dialog,
  );
  return () => Navigator.of(context).pop();
}