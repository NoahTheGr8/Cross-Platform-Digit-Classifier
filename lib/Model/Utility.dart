import 'dart:convert';
import "dart:io";
import 'dart:typed_data';
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'BaseModel.dart';

Directory docsDir = new Directory('');

Future selectDate(BuildContext inContext, BaseModel inModel, String inDateString) async {
  DateTime initialDate = DateTime.now();
  if (inDateString != null) {
    List dateParts = inDateString.split(",");
    initialDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
  }

  // Now request the date.
  DateTime picked = await showDatePicker(
    context : inContext,
    initialDate : initialDate,
    firstDate : DateTime(1900),
    lastDate : DateTime(2100)
  );

  // If they didn't cancel, update it in the model so it shows on the screen and return the string form.
  if (picked != null) {
    inModel.setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
    return "${picked.year},${picked.month},${picked.day}";
  }

} /* End _selectDate(). */


class Utility {

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}