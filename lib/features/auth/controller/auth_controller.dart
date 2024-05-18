import 'dart:io';
import 'package:ca_mobile/features/auth/repository/auth_repository.dart';
import 'package:ca_mobile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Future<bool> signUpWithEmail(
      BuildContext context, String email, String password) {
    String encodedPassword = _hashPassword(password);
    return authRepository.signUpEmail(context, email, encodedPassword);
  }

  Future<bool> signUpWithGoogle(BuildContext context) {
    return authRepository.signUpGoogle(context);
  }

  Future<bool> singUpWithFacebook(BuildContext context) {
    return authRepository.signUpFacebook(context);
  }

  Future<bool> singUpWithGithub(BuildContext context) {
    return authRepository.signUpGithub(context);
  }

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) {
    String encodedPassword = _hashPassword(password);
    return authRepository.signInUser(context,
        password: encodedPassword, email: email);
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convierte la contraseña a bytes
    var hash = sha256.convert(bytes); // Calcula el hash SHA-256
    return hash.toString(); // Retorna el hash como String
  }

  Future<bool> userVerifiedEmail() {
    return authRepository.isEmailVerified();
  }

  Future<void> sendVerificationMail() async {
    authRepository.sendVerificationMail();
  }

  Future<void> deleteUser() async {
    await authRepository.deleteUserAccount();
  }

  void saveUserDataToFirebase(BuildContext context, String name,
      File? profilePic, String lastName, String birthDay) {
    authRepository.saveUserData(
        name: name,
        profilePic: profilePic,
        lastName: lastName,
        birthDay: birthDay,
        ref: ref,
        context: context);
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  Future<bool> resetPassword(String email) {
    return authRepository.resetPassword(email);
  }
}
