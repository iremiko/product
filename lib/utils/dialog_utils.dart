import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:product_app/utils/error_utils.dart';
import 'package:product_app/utils/status_error.dart';

class DialogUtils {
  static final log = Logger('DialogUtils');

  static void showErrorDialog(BuildContext context, dynamic error,
      {Function onTryAgainTap}) {
    log.info(error.toString());
    String message;
    if (error is StatusError) {
      message = error.exception;
    } else {
      message = ErrorUtils.getFriendlyErrorMessage(context, error);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
            actions: [
              FlatButton.icon(
                color: Theme.of(context).errorColor,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.clear),
                  label: Text('Close')),
              if(onTryAgainTap!= null)
              FlatButton.icon(
                color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    onTryAgainTap.call();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Try Again'))
            ],
          );
        });
  }
}
