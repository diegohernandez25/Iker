import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:suberui/models/user.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();


  User _userFromGoogle(FirebaseUser user){
    return user != null ? new User(uid: user.uid,name: user.displayName, email:user.email, imageUrl: user.photoUrl) : null;
  }

  //aut change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromGoogle);
  }


  //Future<FirebaseUser> signInGoogle() async{
  Future<User> signInGoogle() async{
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      final AuthResult t_auth= (await _auth.signInWithCredential(credential));
      final FirebaseUser user = t_auth.user;
      //return user;
      print(t_auth.additionalUserInfo.isNewUser);
      return _userFromGoogle(user);
    }
    catch(e){
      return null;
    }
  }

  Future signOutGoogle() async{

    try{

      await _googleSignIn.signOut();

      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}