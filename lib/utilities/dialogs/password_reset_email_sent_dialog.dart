import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog(
    context: context, 
    title: 'Password Reset', 
    content: 'We have sent you the password reset link. Please check your email for more information',
    optionsBuilder: () => {
      'OK' : null,
    }
    );
}