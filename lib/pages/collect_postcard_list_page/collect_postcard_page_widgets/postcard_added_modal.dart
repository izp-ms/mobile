import 'package:flutter/material.dart';

class PostcardAddedModal extends StatelessWidget {
  const PostcardAddedModal({
    super.key,
  });

  final double padding = 16.0;
  final double avatarRadius = 66.0;

  @override
  Widget build(BuildContext context) {
    dialogContent(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: avatarRadius + padding,
              bottom: padding,
              left: padding,
              right: padding,
            ),
            margin: EdgeInsets.only(top: avatarRadius),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Congratulations!",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "New postcard has been added to your inventory. You can share this moment by sending it to someone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Nice",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: padding,
            right: padding,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              radius: avatarRadius,
              child: Icon(
                Icons.emoji_events_outlined,
                size: avatarRadius,
              ),
            ),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
