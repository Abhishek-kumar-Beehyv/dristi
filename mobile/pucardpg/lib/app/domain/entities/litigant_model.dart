import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class UserModel{

  int? id;
  String? uuid;
  String? authToken;
  String? username;

  String? enteredUserName;
  String? firstName;
  String? middleName;
  String? lastName;

  String? mobileNumber;
  String? identifierType;
  String? identifierId = "";
  String? idFilename = "";
  String? idFileStore = "";
  Uint8List? idBytes = Uint8List.fromList([]);
  String? idDocumentType = "";

  String? type;
  String? userType;

  String? stateRegnNumber;
  String? barRegistrationNumber;
  String? fileStore;
  String? documentFilename = "";
  String? documentType;
  Uint8List? documentBytes = Uint8List.fromList([]);

  String? individualId;

  AddressModel addressModel = AddressModel();

  UserModel({
    this.firstName,
    this.middleName,
    this.lastName,
    this.mobileNumber,
    this.identifierType,
    this.identifierId,
    this.type,
    this.userType
  });

}

class AddressModel{

  String? doorNo;
  double? latitude;
  double? longitude;
  double? locationAccuracy ;
  String? city;
  String? pincode;
  String? street;
  String? district;
  String? state;

  AddressModel({
    this.doorNo,
    this.latitude,
    this.longitude,
    this.locationAccuracy,
    this.city,
    this.pincode,
    this.street,
    this.district,
    this.state
  });

}

class FileStoreModel {
  String? documentType;
  Uint8List? bytes;

  FileStoreModel({
    required this.documentType,
    required this.bytes
  });
}
