part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

class SearchInitialState extends SearchState{}
class SearchLoadingState extends SearchState{}
class SearchSuccessState extends SearchState{}
class SearchErrorState extends SearchState{}
