import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/shared/helper/dio_helper.dart';
import 'package:shop_app/shared/helper/end_points.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search(String text){

    emit(SearchLoadingState());

    DioHelper.postData(
        url: SEARCH,
        token: token,
        data: {
        'text' : text
        }).then((value) {
          searchModel = SearchModel.fromJson(value.data);
          emit(SearchSuccessState());
    }).catchError((error){
          print(error.toString());
          emit(SearchErrorState());
    });

  }
}
