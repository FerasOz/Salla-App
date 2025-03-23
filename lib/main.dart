import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/login_cubit/cubit/login_cubit.dart';
import 'package:shop_app/cubit/register_cubit/cubit/register_cubit.dart';
import 'package:shop_app/cubit/search_cubit/cubit/search_cubit.dart';
import 'package:shop_app/cubit/shop_cubit/cubit/shop_cubit.dart';
import 'package:shop_app/screens/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/helper/cache_helper.dart';
import 'package:shop_app/shared/helper/dio_helper.dart';
import 'package:shop_app/shop_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget? widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  if (onBoarding != null) {
    widget = ShopLayout();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  const MyApp({super.key, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData(),
        ),
        BlocProvider(create:(context) => ShopCubit()..getUserData()),
        BlocProvider(create:(context) => ShopCubit()..getCategoData()),
        BlocProvider(create:(context) => ShopCubit()..getFavorites()),
        BlocProvider(create:(context) => RegisterCubit()),
        BlocProvider(create:(context) => LoginCubit()),
        BlocProvider(create:(context) => SearchCubit()),
      ],
      child: BlocConsumer<ShopCubit, ShopState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Salla',
            debugShowCheckedModeBanner: false,
            home: OnBoardingScreen(),
          );
        },
      ),
    );
  }
}
