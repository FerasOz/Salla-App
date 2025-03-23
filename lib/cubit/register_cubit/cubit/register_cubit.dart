import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/helper/dio_helper.dart';
import 'package:shop_app/shared/helper/end_points.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<ShopRegisterState> {
  RegisterCubit() : super(ShopRegisterInitialState());

  
  static RegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? registerModel;

  void userRegister({
  required String name,
  required String email,
  required String password,
  required String phone,
}){

    emit(ShopRegisterLoadingState());

    DioHelper.postData(url: REGISTER, data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      print(value.data);
      registerModel = ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(registerModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopRegisterErrorState(error));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());

  }
}