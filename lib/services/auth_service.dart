import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 기존 로그인 상태 확인 및 로그아웃
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }

      // 구글 로그인 시도
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn().catchError((error) {
        print('GoogleSignIn Error: $error');
        return null;
      });

      if (googleUser == null) {
        print('Google Sign In cancelled by user');
        return null;
      }

      try {
        // 인증 정보 가져오기
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Firebase 인증 정보 생성
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase 로그인
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        print(
            'Successfully signed in with Google: ${userCredential.user?.email}');
        return userCredential;
      } catch (e) {
        print('Authentication Error: $e');
        await signOut();
        return null;
      }
    } catch (e) {
      print('Google Sign In Error: $e');
      await signOut();
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
      print('Successfully signed out');
    } catch (e) {
      print('Sign out error: $e');
    }
  }
}
