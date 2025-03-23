import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/screens/categories_screen.dart';
import 'package:shop_app/screens/favorites_screen.dart';
import 'package:shop_app/screens/product_screen.dart';
import 'package:shop_app/screens/settings_screen.dart';
import 'package:shop_app/shared/helper/dio_helper.dart';
import 'package:shop_app/shared/helper/end_points.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitialState());

  
  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  Map<int, bool> favorites = {};

  List<Widget> bottomScreens = [
    ProductScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingDataState());

    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      print(homeModel!.status);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id: element.in_favorites,
        });
      }

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoData() {
    DioHelper.getData(url: GET_CATEGORIES).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      print(categoriesModel!.status);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavouritesModel;

  void changeFavorites(int productID) {
    favorites[productID] = !favorites[productID]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
            url: FAVOURITES, data: {'product_id': productID}, token: token)
        .then((value) {
      changeFavouritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavouritesModel!.status!) {
        favorites[productID] = !favorites[productID]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavouritesModel!));
    }).catchError((error) {
      print(error.toString());
      favorites[productID] = !favorites[productID]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(url: GET_FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print(favoritesModel.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingGetUserDataState());

    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopSuccessGetUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserDataState());

    DioHelper.putData(
        url: UPDATE_PROFILE,
        token: token,
        data: {
          'name' : name,
          'email' : email,
          'phone' : phone,
        }
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopSuccessUpdateUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserDataState());
    });
  }
}