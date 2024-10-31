import 'package:flutter/material.dart';

class GetImageDialog extends StatefulWidget {
   GetImageDialog({
    required this.imageFromCameraOnPress,
    required this.imageFromDeviceOnPress,
    super.key
  });

  void Function()? imageFromDeviceOnPress;
  void Function()? imageFromCameraOnPress;

  @override
  State<GetImageDialog> createState() => _GetImageDialogState();
}

class _GetImageDialogState extends State<GetImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery
            .of(context)
            .size
            .height * 0.15,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: widget.imageFromDeviceOnPress, child: const Text('Upload From Device')),
            const SizedBox(width: 20,),
            ElevatedButton(onPressed: widget.imageFromCameraOnPress, child: const Text('Capture Image'))
          ],
        ),
      ),
    );
  }
}
