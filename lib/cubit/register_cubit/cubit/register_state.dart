part of 'register_cubit.dart';

@immutable
sealed class ShopRegisterState {}


class ShopRegisterInitialState extends ShopRegisterState{}

class ShopRegisterLoadingState extends ShopRegisterState{}

class ShopRegisterChangePasswordVisibilityState extends ShopRegisterState{}

class ShopRegisterSuccessState extends ShopRegisterState{
  final ShopLoginModel registerModel;

  ShopRegisterSuccessState(this.registerModel);
}

class ShopRegisterErrorState extends ShopRegisterState{
  final error;

  ShopRegisterErrorState(this.error);
}
