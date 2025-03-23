part of 'shop_cubit.dart';

@immutable
sealed class ShopState {}

class ShopInitialState extends ShopState{}

class ShopChangeBottomNavState extends ShopState{}

class ShopLoadingDataState extends ShopState{}

class ShopSuccessHomeDataState extends ShopState{}

class ShopErrorHomeDataState extends ShopState{}

class ShopSuccessCategoriesState extends ShopState{}

class ShopErrorCategoriesState extends ShopState{}

class ShopSuccessChangeFavoritesState extends ShopState{

  final ChangeFavoritesModel  model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopState{}

class ShopChangeFavoritesState extends ShopState{}

class ShopSuccessGetFavoritesState extends ShopState{}

class ShopLoadingGetFavoritesState extends ShopState{}


class ShopErrorGetFavoritesState extends ShopState{}

class ShopSuccessGetUserDataState extends ShopState{

  final ShopLoginModel loginModel;

  ShopSuccessGetUserDataState(this.loginModel);

}

class ShopLoadingGetUserDataState extends ShopState{}


class ShopErrorGetUserDataState extends ShopState{}


class ShopSuccessUpdateUserDataState extends ShopState{

  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserDataState(this.loginModel);

}

class ShopLoadingUpdateUserDataState extends ShopState{}


class ShopErrorUpdateUserDataState extends ShopState{}
