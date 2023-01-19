import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_provider.dart';
import 'package:learningdart/services/auth/auth_user.dart';
import 'package:test/test.dart';
void main(){
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    // All the tests to be performed in the unit testing
    //These test are done to avoid confusion when more than one coders are working on a project when a change is done then the change is not reflected in the test due to which we can know wheather a code is changed or not
    // In short test makes sure that the code is working in the same way as it was intended.
    test('Should not be initilaized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('cannot logout if not initialized', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to Initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be initilized with in 2 seconds', 
    () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    },
     timeout: const Timeout(Duration(seconds : 2)));

    test('Create user should delegate with the login Function', () async {
      final badEmailUser = provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(email: 'fooo', password: 'foobar');
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      
      expect(user.isEmailVerified, false);
    });

    test('LoggedIn user should be able to get verified', (){
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to login and logout again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });

  });
}

class NotInitializedException implements Exception{}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  
  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    if(!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password
    );
  }
  
  @override
  AuthUser? get currentUser => _user;
  
  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }
  
  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if(!isInitialized) throw NotInitializedException();
    if(email == 'foo@bar.com') throw UserNotFoundAuthException();
    if(password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(_user); //Here the returning value of the user is by the private _user
  }
  
  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }
  
  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  

}