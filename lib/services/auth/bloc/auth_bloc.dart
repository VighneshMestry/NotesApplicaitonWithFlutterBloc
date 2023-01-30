import 'package:bloc/bloc.dart';
import 'package:learningdart/services/auth/auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';
// The latest update of our application is that now the authBloc will be responsible for all the authentication in the application
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //Here the authbloc will require a provider to function but 
  //the super constructor when called doesnot accept a provider istead it accepts a state 
  //so that's why a super keyword is used with a 'state' as an argument.
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()){
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null) {
        emit(const AuthStateLoggedOut());
      }else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch(e){
        emit(AuthStateLoginFailure(e));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      try{
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch(e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}