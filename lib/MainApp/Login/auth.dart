import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

DocumentSnapshot? currentUserSnapshot;
//-----------------------------------------------
Future<String> uploadingImage(image, filename, foldername) async {
  try {
    Reference ref =
        FirebaseStorage.instance.ref().child(foldername).child(filename);
    await ref.putFile(image);
    String downloadURL = await ref.getDownloadURL();

    return downloadURL;
  } on FirebaseException catch (e) {
    return "";
  }
}

class AuthService {
  String? email, password;

  late String? name;
  late String? imageUrl;

  ///decalare the instances of  [google],[firestore],[firebaseauth]
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  GoogleSignInAccount? googleUser;

  // It has current user data, from users collection on(Userverify screen).

  // Shared State for Widgets
  late Stream<User?> user; // firebase user
  late Stream<Map<String, dynamic>>
      profile; // custom user data in FirebaseFirestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = (_auth.authStateChanges());
  }
  Future<User?> googleSignIn() async {
    loading.add(true);
    googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = await _auth.signInWithCredential(credential);

    // updateUserData(user);

    loading.add(false);
    return user.user;
  }

//check user exist in db or not
  Future<bool> userExist(User? user) async {
    DocumentReference ref = _db.collection('employees').doc(user?.uid);
    DocumentSnapshot snapshot = await ref.get();

    if (snapshot.data() == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> guestExist(User? user) async {
    DocumentReference ref = _db.collection('guests').doc(user!.uid);
    DocumentSnapshot snapshot = await ref.get();

    if (snapshot.data() == null) {
      return true;
    } else {
      return false;
    }
  }

  firstTimeEmpLogin(User? user) async {
    dynamic gender;
    await FirebaseFirestore.instance
        .collection("employees")
        .doc(user!.uid)
        .get()
        .then((onValue) {
      final Map<String, dynamic>? documents = onValue.data();
      gender = documents!["gender"];
    });
    if (gender == null) {
      return true;
    } else {
      return false;
    }
  }

//check user exist in db or not
  firstTimeLogin(User? user) async {
    dynamic gender;
    await FirebaseFirestore.instance
        .collection("guests")
        .doc(user!.uid)
        .get()
        .then((onValue) {
      final Map<String, dynamic>? documents = onValue.data();
      gender = documents!["gender"];
    });
    if (gender == null) {
      return true;
    } else {
      return false;
    }
  }

// checking for guest profie

//check user is loggedin or not
  Future<bool> isLogin() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> domainExist(User user) async {
    List domainList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("company").get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    for (var doc in documents) {
      domainList.addAll(doc["domain"]);
    }

    String? userEmail = user.email;
    var domainPart = userEmail!.split('@');

    if (domainList.contains(domainPart[1])) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> handleSignInEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return result.user;
  }

  //signup
  Future<User?> handleSignUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<String> signup(String email, String passsword) async {
    String exceptiion = "";
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: passsword);
      User? user = _auth.currentUser;
      user!.sendEmailVerification();
      // user!.reload();

      print(user.email);
    } on FirebaseException catch (e) {
      if (e.code == "email-already-in-use") {
        print('Email alredy in use');
        exceptiion = "Email is already is use";
      } else {
        print(e.code + "..........");
        exceptiion = e.code;
      }
    }
    return exceptiion;
  }

  Future<String> forgetPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "no exception";
    } on FirebaseException catch (e) {
      return e.code;
    }
  }

//logout
  void signOut(BuildContext context) async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}

final AuthService authService = AuthService();
