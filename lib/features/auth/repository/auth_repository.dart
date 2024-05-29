import 'dart:io';
import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ca_mobile/common/utils/utils.dart';
import 'package:ca_mobile/common/repositories/common_firebase_storage_repository.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);
final userStateProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<bool> userExist(String email) async {
    var userData = await firestore.collection('users').get();
    for (var doc in userData.docs) {
      var user = UserModel.fromMap(doc.data());
      if (email == user.email) {
        return true;
      }
    }
    return false;
  }

  Future<bool> signUpEmail(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        userCredential.user!.sendEmailVerification();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loginType', 'email');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message!);
      }
      return false;
    }
  }

  Future<bool> signUpGoogle(BuildContext context) async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

      final userCredential = await auth.signInWithProvider(_googleAuthProvider);
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          userCredential.user!.sendEmailVerification();
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loginType', 'google');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message!);
      }
      return false;
    }
  }

  Future<UserCredential> signUpFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userCredential =
          await auth.signInWithCredential(facebookAuthCredential);
      return auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message!);
      }
      rethrow;
    }
  }

  Future<bool> signUpGithub(BuildContext context) async {
    try {
      GithubAuthProvider _githubAuthProvider = GithubAuthProvider();
      final userCredential = await auth.signInWithProvider(_githubAuthProvider);
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          userCredential.user!.sendEmailVerification();
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loginType', 'github');
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message!);
      }
      return false;
    }
  }

  Future<bool> signInUser(BuildContext context,
      {required String password, required String email}) async {
    try {
      var ban = false;
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          ban = true;
        }
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loginType', 'email');
      return ban;
    } on FirebaseAuthException catch (e) {
      e.message!;
      return false;
    }
  }

  Future<bool> isEmailVerified() async {
    final user = auth.currentUser;
    if (user != null) {
      user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<void> sendVerificationMail() async {
    final user = auth.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        if (e.toString().contains('too-many-requests')) {
          throw Exception('Demasiadas solicitudes. Intenta más tarde.');
        } else {
          throw Exception('Error al enviar el correo de verificación: $e');
        }
      }
    }
  }

  Future<void> deleteUserAccount() async {
    final user = auth.currentUser;
    // if (user != null) {
    //   try {
    //     await user.delete();
    //     await user.reload();
    //     print("Cuenta eliminada con éxito.");
    //     return true;
    //   } on FirebaseAuthException catch (e) {
    //     print("Error al eliminar la cuenta: ${e.message}");
    //   }
    // } else {
    //   print("No hay usuario autenticado.");
    //   return false;
    // }
    // return false;
    if (user != null) {
      try {
        await user.delete();
        await user.reload();
      } on FirebaseAuthException catch (e) {
        print("Error al eliminar la cuenta: ${e.message}");
      }
    }
  }

  void updateUserData({
    required String name,
    required String lastName,
    required String birthDay,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    String uid = auth.currentUser!.uid;
    String photoURL =
        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
    if (profilePic != null) {
      photoURL = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'profilePic/$uid',
            profilePic,
          );
    }
    FirebaseAuth.instance.currentUser!.updatePhotoURL(photoURL);
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    FirebaseAuth.instance.userChanges();
    var user = UserModel(
        name: name,
        lastName: lastName,
        uid: uid,
        birthDay: birthDay,
        profilePic: photoURL,
        email: auth.currentUser!.email!,
        classIDs: [],
        isPremium: false);
    await firestore.collection('users').doc(uid).update(user.toMap()).then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigation(),
            ),
            (route) => false,
          ),
        );
  }

  void updateUserNoIMGData({
    required String name,
    required String lastName,
    required String birthDay,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    String uid = auth.currentUser!.uid;
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    FirebaseAuth.instance.userChanges();
    var user = UserModel(
        name: name,
        lastName: lastName,
        uid: uid,
        birthDay: birthDay,
        profilePic: '',
        email: auth.currentUser!.email!,
        classIDs: [],
        isPremium: false);
    await firestore.collection('users').doc(uid).update(user.toMapNoIMG()).then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigation(),
            ),
            (route) => false,
          ),
        );
  }

  void saveUserData({
    required String name,
    required String lastName,
    required String birthDay,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoURL =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        photoURL = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      FirebaseAuth.instance.currentUser!.updatePhotoURL(photoURL);
      FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      var user = UserModel(
          name: name,
          lastName: lastName,
          uid: uid,
          birthDay: birthDay,
          profilePic: photoURL,
          email: auth.currentUser!.email!,
          classIDs: [],
          isPremium: false);
      FirebaseAuth.instance.userChanges();
      await firestore.collection('users').doc(uid).set(user.toMap()).then(
            (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigation(),
              ),
              (route) => false,
            ),
          );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  Future<void> signOut() async {
    //Primero pasamos no estar en linea
    /*
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        'isOnline': false,
      },
    );
    */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    // Cerrar sesión de Google
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      print("Error al cerrar sesión de Google: $e");
    }

    // Cerrar sesión de Facebook
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("Error al cerrar sesión de Facebook: $e");
    }
    await auth.signOut();
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  Future<bool> checkIsPremium(String uid) async {
    var userData = await firestore.collection('users').doc(uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    bool isPremium = userData['isPremium'] ?? false;
    return isPremium;
  }

  void setPremium() async {
    String uid = auth.currentUser!.uid;
    await firestore.collection('users').doc(uid).update({'isPremium': true});
  }

  Future<bool> resetPassword(String email) async {
    try {
      if (await userExist(email)) {
        await auth.sendPasswordResetEmail(email: email);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      e.code;
      return false;
    }
  }
}
