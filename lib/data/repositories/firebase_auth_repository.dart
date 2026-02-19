import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_user_datasource.dart';
import '../utils/data_error_mapper.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final RemoteUserDataSource remoteDataSource;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth, 
    GoogleSignIn? googleSignIn,
    required this.remoteDataSource,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();
      }
      
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await _googleSignIn.attemptLightweightAuthentication() 
          ?? await _googleSignIn.authenticate();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final authorization = await googleUser.authorizationClient.authorizeScopes([]);
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      await signOut();
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
