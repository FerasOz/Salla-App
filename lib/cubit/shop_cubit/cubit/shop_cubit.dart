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
import 'package:shop_app/models/product_details_model.dart';
import 'package:shop_app/screens/categories_screen.dart';
import 'package:shop_app/screens/favorites_screen.dart';
import 'package:shop_app/screens/product_screen.dart';
import 'package:shop_app/screens/settings_screen.dart';
import 'package:shop_app/shared/helper/cache_helper.dart';
import 'package:shop_app/shared/helper/dio_helper.dart';
import 'package:shop_app/shared/helper/end_points.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingDataState());

    DioHelper.getData(url: HOME, token: token)
        .then((value) {
          homeModel = HomeModel.fromJson(value.data);

          homeModel!.data!.products.forEach((element) {
            favorites.addAll({element.id!: element.in_favorites!});
          });

          emit(ShopSuccessHomeDataState());
        })
        .catchError((error) {
          emit(ShopErrorHomeDataState());
        });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(url: GET_CATEGORIES)
        .then((value) {
          categoriesModel = CategoriesModel.fromJson(value.data);

          emit(ShopSuccessCategoriesState());
        })
        .catchError((error) {
          emit(ShopErrorCategoriesState());
        });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
          url: FAVORITES,
          data: {'product_id': productId},
          token: token,
        )
        .then((value) {
          changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
          if (!changeFavoritesModel!.status!) {
            favorites[productId] = !favorites[productId]!;
          } else {
            getFavorites();
          }

          emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
        })
        .catchError((error) {
          favorites[productId] = !favorites[productId]!;

          emit(ShopErrorChangeFavoritesState());
        });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(url: FAVORITES, token: token)
        .then((value) {
          favoritesModel = FavoritesModel.fromJson(value.data);
          emit(ShopSuccessGetFavoritesState());
        })
        .catchError((error) {
          print('#########################');
          print(error.toString());

          emit(ShopErrorGetFavoritesState());
        });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingGetUserDataState());

    DioHelper.getData(url: PROFILE, token: token)
        .then((value) {
          userModel = ShopLoginModel.fromJson(value.data);
          emit(ShopSuccessGetUserDataState(userModel!));
        })
        .catchError((error) {
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
          data: {'name': name, 'email': email, 'phone': phone},
        )
        .then((value) {
          userModel = ShopLoginModel.fromJson(value.data);
          emit(ShopSuccessUpdateUserDataState(userModel!));
        })
        .catchError((error) {
          emit(ShopErrorGetUserDataState());
        });
  }

  ProductDetailModel? productDetailsModel;

  void getProductDetails(int productID) {
    emit(ShopLoadingGetProductDetailsState());
    DioHelper.getData(url: 'products/$productID', token: token)
        .then((value) {
          productDetailsModel =
              ProductDetailsModel.fromJson(value.data) as ProductDetailModel?;
          emit(ShopSuccessGetProductDetailsState());
        })
        .catchError((error) {
          emit(ShopErrorGetProductDetailsState());
        });
  }
   bool isDark = false;

  void changeAppMode({bool? fromShared})
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}

class ProductDetailModel {}
