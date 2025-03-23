import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/cubit/shop_cubit.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';
    
class ProductScreen extends StatelessWidget {

  const ProductScreen({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
        listener: (context, state) {
          if(state is ShopSuccessChangeFavoritesState){
            if(!state.model.status!){
              showToast(text: state.model.message!, state: ToastStates.ERROR);            }
          }
        },
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.homeModel != null && cubit.categoriesModel != null,
              builder: (context) => productsBuilder(cubit.homeModel!, cubit.categoriesModel!, context),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()));
        });
  }

  Widget productsBuilder(HomeModel model, CategoriesModel categoriesModel,context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                  height: 250.0,
                  initialPage: 0,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CATEGORIES',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildCategoryItem(categoriesModel.data!.data![index]),
                        separatorBuilder: (context, index) => const SizedBox(width: 10.0,),
                        itemCount: categoriesModel.data!.data!.length,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'PRODUCTS',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1.0 / 1.53,
                children: List.generate(model.data!.products.length,
                    (index) => buildGridProduct(model.data!.products[index], context)),
              ),
            )
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${model.image}'),
                  width: double.infinity,
                  height: 200,
                ),
                if (model.discount != 0)
                  Container(
                    padding: const EdgeInsetsDirectional.only(start: 5.0),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, height: 1.4),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price} \$',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 14.0),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.old_price}',
                          style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13.0),
                        ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id!);
                          print(model.id!);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: ShopCubit.get(context).favorites[model.id]! ? primaryColor : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children:  [
       Image(
        image: NetworkImage('${model.image}'),
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.8),
        width: 100.0,
        child: Text(
          '${model.name}',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}
