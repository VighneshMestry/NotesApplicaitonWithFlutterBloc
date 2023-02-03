import 'package:bloc/bloc.dart';
import 'package:learningdart/services/auth/auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';
// The latest update of our application is that now the authBloc will be responsible for all the authentication in the application
// AuthBLoc will be responsible for initializing the firebase authentication and all the logout and login functions.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //Here the authbloc will require a provider to function but 
  //the super constructor when called doesnot accept a provider istead it accepts a state 
  //so that's why a super keyword is used with a 'state' as an argument.
  AuthBloc(AuthProvider provider) : super(const AuthStateUnInitialize(isLoading: true)){
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      }else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user:user, isLoading: false));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try{
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch(e){
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    // on<AuthEventShouldRegister>((event, emit) {
    //   emit(const AuthStateRegistering(
    //     // exception: null,
    //     // isLoading: false,
    //   ));
    // });

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true, loadingText: 'Please wait while I log you In'));

      // await Future.delayed(const Duration(seconds: 3));
      final email = event.email;
      final password = event.password;
      try{
        final user = await provider.logIn(email: email, password: password);

        if(!user.isEmailVerified){
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(isLoading : false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading : false));
        }
      } on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch(e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

  }
}