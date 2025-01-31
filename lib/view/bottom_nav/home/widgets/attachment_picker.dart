import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qadria/res/utils/size_box_extension.dart';
import 'dart:io';
import '../../../../res/colors.dart';
import '../../../../res/constants.dart';

typedef OnFileSelected = Function(XFile? data);

class AttachmentPicker extends StatefulWidget {
  String hintText = "";
  OnFileSelected onFileSelected;
  XFile? selectedFile;

  AttachmentPicker(this.hintText,
      {super.key, required this.onFileSelected, this.selectedFile});

  @override
  State<AttachmentPicker> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<AttachmentPicker> {
  TextEditingController textEditingController = TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ) // changes position of shadow
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(widget.hintText)),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.camera),
                                title: const Text('Open Camera'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  XFile? file = await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                  );
                                  if (file != null) {
                                    widget.onFileSelected(file);
                                    setState(() {
                                      widget.selectedFile = file;
                                    });
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text('Choose from Gallery'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  XFile? file = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (file != null) {
                                    widget.onFileSelected(file);
                                    setState(() {
                                      widget.selectedFile = file;
                                    });
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.attachment, color: MyColors.color),
                  ),
                  widget.selectedFile == null ? const SizedBox.shrink() : 10.kW,
                  widget.selectedFile == null
                      ? const SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            widget.onFileSelected(null);
                            setState(() {
                              widget.selectedFile = null;
                            });
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        )
                ],
              )
            ],
          ),
          widget.selectedFile == null ? const SizedBox.shrink() : 10.kH,
          widget.selectedFile == null
              ? const SizedBox.shrink()
              : Image.file(
                  File(widget.selectedFile!.path),
                  width: 100,
                  height: 100,
                ),
        ],
      ),
    );
  }
}
