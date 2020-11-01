import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jp_flashcard/models/user.dart' as custom;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  custom.User convertUser(User user) {
    return user != null
        ? custom.User(
            uid: user.uid ?? "",
            isAnon: user.isAnonymous ?? "",
            displayName: user.displayName ?? "登入",
            email: user.email ?? "",
            photoURL: user.photoURL ?? "",
          )
        : null;
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');
      return convertUser(user);
    }

    return null;
  }

  Stream<custom.User> get user {
    return _auth.authStateChanges().map((user) => convertUser(user));
  }

  custom.User get currentUser {
    return convertUser(_auth.currentUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return convertUser(user);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      print("User Signed Out");
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
    }
  }
}
