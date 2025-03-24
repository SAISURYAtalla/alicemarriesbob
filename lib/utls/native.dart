import 'dart:convert';

import 'package:flutter/services.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io' show Platform;


typedef NativeFunctionSignature = Int32 Function(Int32);
typedef DartFunctionSignature = int Function(int);

typedef Initialize = Int32 Function(Pointer<Void>);
typedef DartFunctionIntialize = int Function(Pointer<Void>);

typedef GetSlotList = Uint32 Function(Uint8, Pointer<Uint64>, Pointer<Uint64>);
typedef DartFunctionGetSlotList = int Function(
    int, Pointer<Uint64>, Pointer<Uint64>);

typedef OpenSession = Uint32 Function(
    Uint64, Uint32, Pointer<Void>, Pointer<Void>, Pointer<Uint64>);
typedef DartFunctionOpenSession = int Function(
    int, int, Pointer<Void>, Pointer<Void>, Pointer<Uint64>);

typedef Login = Int32 Function(Int32, Int32, Pointer<Uint8>, Int32);
typedef DartFunctionLogin = int Function(int, int, Pointer<Uint8>, int);

typedef FindObjectsInit = Uint32 Function(
    Uint64, Pointer<CK_ATTRIBUTE>, Uint32);
typedef DartFunctionFindObjectsInit = int Function(
    int, Pointer<CK_ATTRIBUTE>, int);

typedef FindObjects = Uint32 Function(
    Uint64, Pointer<Uint64>, Uint32, Pointer<Uint32>);
typedef DartFunctionFindObjects = int Function(
    int, Pointer<Uint64>, int, Pointer<Uint32>);

typedef GetAttributeValue = Uint32 Function(
    Uint64, Uint64, Pointer<CK_ATTRIBUTE>, Uint32);
typedef DartFunctionGetAttributeValue = int Function(
    int, int, Pointer<CK_ATTRIBUTE>, int);

typedef FindObjectsFinal = Uint32 Function(Uint64);
typedef DartFunctionFindObjectsFinal = int Function(int);

typedef SignInit = Uint32 Function(Uint64, Pointer<CK_MECHANISM>, Uint64);
typedef DartFunctionSignInit = int Function(int, Pointer<CK_MECHANISM>, int);

typedef Sign = Uint32 Function(
    Uint64, Pointer<Utf8>, Uint32, Pointer<Uint8>, Pointer<Uint32>);
typedef DartFunctionSign = int Function(
    int, Pointer<Utf8>, int, Pointer<Uint8>, Pointer<Uint32>);

typedef VerifyInit = Int32 Function(Int32, Pointer<CK_MECHANISM>, Int32);
typedef DartFunctionVerifyInit = int Function(int, Pointer<CK_MECHANISM>, int);

typedef Verify = Uint32 Function(
    Uint64, Pointer<Utf8>, Uint32, Pointer<Uint8>, Pointer<Uint32>);
typedef DartFunctionVerify = int Function(
    int, Pointer<Utf8>, int, Pointer<Uint8>, Pointer<Uint32>);


class NativeLibrary {
  late DynamicLibrary _library;

  NativeLibrary() {
    if (Platform.isAndroid) {
      _library = DynamicLibrary.open("liblsusbdemo.so");
    } else if (Platform.isIOS) {
      _library = DynamicLibrary.process();
    }
  }

  DartFunctionSignature get connectUSB => _library
      .lookup<NativeFunction<NativeFunctionSignature>>('Connect_usb')
      .asFunction<DartFunctionSignature>();

  DartFunctionIntialize get initialize => _library
      .lookup<NativeFunction<Initialize>>('C_Initialize')
      .asFunction<DartFunctionIntialize>();

  DartFunctionGetSlotList get getSlotList => _library
      .lookup<NativeFunction<GetSlotList>>('C_GetSlotList')
      .asFunction<DartFunctionGetSlotList>();

  DartFunctionOpenSession get openSession => _library
      .lookup<NativeFunction<OpenSession>>('C_OpenSession')
      .asFunction<DartFunctionOpenSession>();

  DartFunctionLogin get login => _library
      .lookup<NativeFunction<Login>>('C_Login')
      .asFunction<DartFunctionLogin>();

  DartFunctionFindObjectsInit get findObjectsInit => _library
      .lookup<NativeFunction<FindObjectsInit>>('C_FindObjectsInit')
      .asFunction<DartFunctionFindObjectsInit>();

  DartFunctionFindObjects get findObjects => _library
      .lookup<NativeFunction<FindObjects>>('C_FindObjects')
      .asFunction<DartFunctionFindObjects>();

  DartFunctionGetAttributeValue get getAttributeValue => _library
      .lookup<NativeFunction<GetAttributeValue>>('C_GetAttributeValue')
      .asFunction<DartFunctionGetAttributeValue>();

  DartFunctionFindObjectsFinal get findObjectsFinal => _library
      .lookup<NativeFunction<FindObjectsFinal>>('C_FindObjectsFinal')
      .asFunction<DartFunctionFindObjectsFinal>();

  DartFunctionSignInit get signInit => _library
      .lookup<NativeFunction<SignInit>>('C_SignInit')
      .asFunction<DartFunctionSignInit>();

  DartFunctionSign get sign => _library
      .lookup<NativeFunction<Sign>>('C_Sign')
      .asFunction<DartFunctionSign>();

  DartFunctionVerifyInit get verifyInit => _library
      .lookup<NativeFunction<VerifyInit>>('C_VerifyInit')
      .asFunction<DartFunctionVerifyInit>();

  DartFunctionVerify get verify => _library
      .lookup<NativeFunction<Verify>>('C_Verify')
      .asFunction<DartFunctionVerify>();
}

base class CK_ATTRIBUTE extends Struct {
  @Uint32()
  external int type;

  external Pointer<Uint64> pValue;

  @Uint64()
  external int ulValueLen;
}

base class CK_MECHANISM extends Struct {
  @Uint32()
  external int mechanism; // CK_MECHANISM_TYPE

  external Pointer<Void> parameter;

  @Uint64()
  external int parameter_len; // CK_ULONG
}

class NativeFunctionInvoke {
  final NativeLibrary nativeLibrary = NativeLibrary();
  final session = calloc<Uint64>();
  final privateKey = calloc<Uint64>();

  bool Login(String PIN) {
    try {
      var res = nativeLibrary.initialize(nullptr);
      if (res != 0) {
        print(res);
        print("Error in initializing");
        return false;
      }

      res = -1;

      final slotList = calloc<Uint64>(10);
      final noOfSlots = calloc<Uint64>();

      res = nativeLibrary.getSlotList(1, slotList, noOfSlots);
      if (res != 0) {


        print("Failed to get total slots");
        return false;
      }

      res = -1;

      res = nativeLibrary.openSession(
          slotList[0], 0x00000004 | 0x00000002, nullptr, nullptr, session);
      if (res != 0) {
        print(res);
        print("Failed to open session");
        return false;
      }
      res = -1;

      res = nativeLibrary.login(
          session[0], 1, PIN.toNativeUtf8().cast<Uint8>(), PIN.length);
      if (res != 0) {
        print(res);
        print("Failed to login");
        return false;
      }
      res = -1;
      return true;
      print("Login Successful");
    } catch (e) {
      print(e);
      return false;
    }
  }

  final CKR_OK = 0x00000000;
  final CKO_PRIVATE_KEY = 0x00000003;
  final CKA_CLASS = 0x00000000;
  final CKA_LABEL = 0x00000003;
  final CKM_SHA256_RSA_PKCS = 0x00000040;

// Define structs
  final hObject = calloc<Uint64>(1);
  final ulObjectCount = calloc<Uint32>(1);

  String SignData(String data) {
    final keyClassPriv = calloc<Uint64>();
    keyClassPriv.value = 3;

    final templPriv = calloc<CK_ATTRIBUTE>(1);
    templPriv[0]
      ..type = 0x00000000 // Example type, e.g., CKA_CLASS
      ..pValue = keyClassPriv
      ..ulValueLen = sizeOf<CK_ATTRIBUTE>();

    const int templPrivateSize = 1;

    var rv =
        nativeLibrary.findObjectsInit(session[0], templPriv, templPrivateSize);
    print('FindObjectsINit : $rv');
    if (rv != 0) {
      print("Failed to initiate find objects");
      return '';
    }

    hObject[0] = 0;
    ulObjectCount[0] = 0;
    rv = -1;
    rv = nativeLibrary.findObjects(session[0], hObject, 1, ulObjectCount);
    print('FindObject : $rv');
    if (rv != 0) {
      print("Failed to find objects");
      return '';
    }

    final label = calloc<Uint8>(32);
    final readtemplPrivate = calloc<CK_ATTRIBUTE>(1);
    templPriv[0]
      ..type = 0x00000003 // Example type, e.g., CKA_CLASS
      ..pValue = label.cast()
      ..ulValueLen = sizeOf<CK_ATTRIBUTE>();

    const int tempSize = 1;
    print('ulObject : ${ulObjectCount[0]}');
    rv = -1;
    for (int i = 0; i < ulObjectCount[0]; i++) {
      rv = nativeLibrary.getAttributeValue(
          session[0], hObject[0], readtemplPrivate, tempSize);
      print("get attribute : $i : $rv");
      if (rv == 0) {
        privateKey[0] = hObject[0];
      } else {
        print('Error in getting attribute value $i');
      }
    }
    rv = -1;
    rv = nativeLibrary.findObjectsFinal(session[0]);
    print('findobjectfinal : $rv');
    if (rv != 0) {
      print("Failed to finalize find objects");
      return '';
    }

    final mech = calloc<CK_MECHANISM>(1);
    mech[0].mechanism = CKM_SHA256_RSA_PKCS;

    rv = -1;
    rv = nativeLibrary.signInit(session[0], mech, hObject[0]);
    if (rv != 0) {
      print("Failed to initialize sign");
      return'';
    }
    print('Siginit : $rv');
    final signature = calloc<Uint8>(256);
    final signlen = calloc<Uint32>(1);
    signlen[0] = 256;

    rv = -1;
    rv = nativeLibrary.sign(
        session[0], data.toNativeUtf8(), data.length, signature, signlen);
    print('sign : $rv');
    if (rv != 0) {
      print('Failed to sign data');
      return '';
    }

    int length = signlen.value;
    var s = signature.asTypedList(length);
    String signatureString = base64Encode(s);

    print("successful signed");

    return signatureString;
    rv = -1;
  }

  String verifyData(String base64string, String ata) {
    Uint8List decodedSignature = base64Decode(base64string);

// Allocate memory for the decoded signature
    Pointer<Uint8> signaturePointer = calloc<Uint8>(decodedSignature.length);

// Copy the decoded signature into the allocated memory
    Uint8List signatureList =
        signaturePointer.asTypedList(decodedSignature.length);
    Pointer<Uint32> length = calloc<Uint32>(1);
    length[0] = decodedSignature.length;

    signatureList.setAll(0, decodedSignature);
    // calloc.free(signaturePointer);

    final mech = calloc<CK_MECHANISM>(1);
    mech[0].mechanism = CKM_SHA256_RSA_PKCS;

    var rv = -1;
    rv = nativeLibrary.verifyInit(session[0], mech, 5000);
    print('VerifyINIT : $rv');
    if (rv != 0) {
      print('Failed in verify init');
      return '';
    }

    rv = -1;
    rv = nativeLibrary.verify(
        session[0], ata.toNativeUtf8(), ata.length, signaturePointer, length);
    print("verify : $rv");
    if (rv != 0) {
      print('Error in verifying data');
      return '';
    }

    print("data verified");
    return 'data verified';
    calloc.free(signaturePointer);
  }


}

class UsbManager {
  static const platform = MethodChannel('com.example.temp/usb');

  Future<int> detectSmartCard() async {
    try {
      final int fileDescriptor = await platform.invokeMethod('getFileDescriptor');
      return fileDescriptor;
    } on PlatformException catch (e) {
      print("Failed to detect smart card: '${e.message}'.");
      return -1;
    }
  }

  Future<String> loginTrustToken(String pin) async {
    try {
      final fileDescriptor = await platform.invokeMethod('login', {'pin': pin});

      return fileDescriptor;
    } on PlatformException catch (e) {
      print("Failed to login to the trustToken: '${e.message}'.");
      return "-1";
    }
  }
}

