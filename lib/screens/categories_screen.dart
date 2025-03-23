import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/cubit/shop_cubit.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components/components.dart';
    
class CategoriesScreen extends StatelessWidget {

  const CategoriesScreen({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildCatItems(ShopCubit.get(context).categoriesModel!.data!.data![index]),
            separatorBuilder: (context, index) => divider(),
            itemCount: ShopCubit.get(context).categoriesModel!.data!.data!.length
        );
      },
    );
  }

  Widget buildCatItems(DataModel model){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image(
              image: NetworkImage('${model.image}'),
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
              '${model.name}',
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_outlined),
        ],
      ),
    );
  }

}