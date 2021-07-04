import 'package:firebase_auth/firebase_auth.dart';
import 'package:facto/util/globals.dart' as globals;

FirebaseAuth auth = FirebaseAuth.instance;
User user;

Future<User> signUpWithEmail(String email, String password) async {
  UserCredential sUser = await auth.createUserWithEmailAndPassword(
      email: email, password: password);
  user = sUser.user;
  return sUser.user;
}

Future<User> signInWithEmail(String email, String password) async {
  UserCredential result =
  await auth.signInWithEmailAndPassword(email: email, password: password);
  user = result.user;
  return result.user;
}

Future<User> signOutWithGoogle() async {
  await auth.signOut();
  return null;
}
