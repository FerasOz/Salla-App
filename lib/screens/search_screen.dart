import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/search_cubit/cubit/search_cubit.dart';
import 'package:shop_app/shared/components/components.dart';
    
class SearchScreen extends StatelessWidget {
var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      validate: (String value){
                        if(value.isEmpty){
                          return 'Enter Value to Search';
                        }
                        return null;
                      },
                      onSubmit: (String text){
                        SearchCubit.get(context).search(text);
                      },
                      label: 'Search',
                      prefix: Icons.search_outlined
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  if(state is SearchLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  if(state is SearchSuccessState)
                  Expanded(
                      child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildListItem(SearchCubit.get(context).searchModel!.data!.data![index], context, isOldPrice: false),
                    separatorBuilder: (context, index) => divider(),
                    itemCount: SearchCubit.get(context).searchModel!.data!.data!.length,
                  ))
                ],
              ),
            ),

          );
        },
      ),
    );
  }
}