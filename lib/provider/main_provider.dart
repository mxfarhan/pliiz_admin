import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pliiz_web/provider/base_provider.dart';

class MainProvider extends BaseProvider {
  CollectionReference ownedQrReference =
      FirebaseFirestore.instance.collection('owned_qr');

  Future<void> generateQrCode() async {
    Map<String, dynamic> data = {
      'title': '',
      'assignTo': '',
    };
    await ownedQrReference.doc().set(data);
  }
}
