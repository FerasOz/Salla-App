part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

class ShopLoginInitialState extends LoginState{}

class ShopLoginLoadingState extends LoginState{}

class ShopLoginChangePasswordVisibilityState extends LoginState{}

class ShopLoginSuccessState extends LoginState{
  final ShopLoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState extends LoginState{
  final error;

  ShopLoginErrorState(this.error);
}
