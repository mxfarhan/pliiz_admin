import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/controllers/choices.controller.dart';
import 'package:pliiz_web/helpers/routes.dart';
import 'package:pliiz_web/main.dart';
import 'package:pliiz_web/model/employees_model.dart';
import 'package:pliiz_web/model/enums/viewstate.dart';
import 'package:pliiz_web/model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loginAsEmployee = false;
  final db = FirebaseFirestore.instance;
  User? user;
  bool userStatus = false;
  ViewState viewState = ViewState.idle;
  RxBool isLoginView = true.obs;
  bool showPassword = false;
  EmployeesModel? employees;
  void initAuth() {
    /*if(auth.currentUser!=null){
      user = auth.currentUser;
      update();
    } else {
      Get.offAllNamed(keys.loginPage);
    }*/
  }
  void changeView({required state}) {
    isLoginView(state);
    update();
  }

  Future setDomain(domain) async {
    await box.write("domain", domain);
  }

  void changeShowPasswordState() {
    showPassword = !showPassword;
    update();
  }

  void handleLogin({required email, required password}) async {
    print('this is login handler');
    viewState = ViewState.busy;
    update();

    if (!loginAsEmployee) {
      print('this is login as admin');
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        DocumentSnapshot sn =
            await db.collection(appDataCollection).doc(industeriesKey).get();
        if (sn.exists) {
          Map<String, dynamic> data = sn.data() as Map<String, dynamic>;
          String url = data["domain"];
          await setDomain(url);
        }
        print('this is curent uid ${auth.currentUser!.uid}');
        await db
            .collection(usersCollection)
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) {
          Map<String, dynamic> json = value.data() as Map<String, dynamic>;
          print('this is value ${UserModel.fromSnapshot(json)}');
          UserModel user = UserModel.fromSnapshot(json);
          userStatus = user.isActive;
          notifyChildrens();
          print('this is user name ${user.contactName}  ${user.email}');
        });
        if (userStatus) {
          Get.offAllNamed(keys.homePage);
        } else {
          toast("Wait for admin approval");
        }
      } catch (e) {
        print(e);
        toast("Check you email/password");
      }
      viewState = ViewState.idle;
      update();
    } else {
      print('this is login as employee');
      viewState = ViewState.busy;
      update();
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        String userId = auth.currentUser!.uid;
        var snapshot = await db
            .collection(collectionEmployees)
            .where("id", isEqualTo: userId)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> json = snapshot.docs[0].data();
          employees = EmployeesModel.fromMap(json, snapshot.docs[0].id);
          await box.write("loyee", jsonEncode(json));
          update();
          await db
              .collection(usersCollection)
              .doc(auth.currentUser!.uid)
              .get()
              .then((value) {
            Map<String, dynamic> json = value.data() as Map<String, dynamic>;
            UserModel user = UserModel.fromSnapshot(json);
            userStatus = user.isActive;
            notifyChildrens();
            print('this is user name ${user.contactName}  ${user.email}');
          });
          if (userStatus) {
            Get.offAllNamed(keys.employeePage);
          } else {
            toast("Wait for admin approval");
          }
        } else {
          toast("You are not employee");
        }
      } catch (e) {
        toast("Check you email/password");
      }
      viewState = ViewState.idle;
      update();
    }
  }

  void handleSignUp({required UserModel user, required String password}) async {
    print('this is signup handler ');
    viewState = ViewState.busy;
    update();
    try {
      print('this is  some one click on me ');
      await auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      User? me = auth.currentUser;
      if (me != null) {
        print('user is not null and user name is ${user.contactName} ');
        me.updateDisplayName(user.contactName);
        await me.sendEmailVerification();
        await db
            .collection("users")
            .doc(me.uid)
            .set(user.toMap(user))
            .then((value) async {
          // await db.collection("users").doc(me.uid).update({"userid": me.uid});
        });
        Get.offAllNamed(RoutKeys().verificationPage);
        await me.sendEmailVerification();
      }
    } catch (_) {}
    viewState = ViewState.idle;
    update();
  }

  void saveData() {}
  void handleGoogleSignUp() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      DocumentSnapshot sn =
          await db.collection(appDataCollection).doc(industeriesKey).get();
      if (sn.exists) {
        Map<String, dynamic> data = sn.data() as Map<String, dynamic>;
        String url = data["domain"];
        await setDomain(url);
      }
      Get.offAllNamed(keys.homePage);
    } catch (e) {
      print(e);
    }
  }

  void changeType(type) {
    loginAsEmployee = !loginAsEmployee;
    update();
  }
}
