import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/cubit/shop_cubit.dart';
import 'package:shop_app/shared/components/components.dart';
    
class FavoritesScreen extends StatelessWidget {

  const FavoritesScreen({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildListItem(ShopCubit.get(context).favoritesModel!.data!.data![index].product, context),
            separatorBuilder: (context, index) => divider(),
            itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}