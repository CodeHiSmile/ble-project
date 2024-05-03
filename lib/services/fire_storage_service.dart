import 'package:ble_project/models/log_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FireStorageService {
  final CollectionReference _phoneCollectionReference =
      FirebaseFirestore.instance.collection('logs');

  Future saveLog(LogDto logDto) async {
    try {
      await _phoneCollectionReference
          .doc("${logDto.id}")
          .set(logDto.toJson());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }
}
