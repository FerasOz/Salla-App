import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/cubit/login_cubit/cubit/login_cubit.dart';
import 'package:shop_app/screens/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/helper/cache_helper.dart';
import 'package:shop_app/shop_layout.dart';
    
class LoginScreen extends StatelessWidget {
 var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status){

              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {
                token = state.loginModel.data!.token!;
                navigateAndFinish(context, const ShopLayout());
              });
            }else{
              print(state.loginModel.message);
              showToast(
                  text: '${state.loginModel.message}',
                  state: ToastStates.ERROR
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text('Login now to browse our hot offers ...',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.grey)),
                        const SizedBox(
                          height: 25.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Email must not be empty';
                              }
                            },
                            label: 'Email',
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'password is too shot';
                              }
                            },
                            label: 'Password',
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            isPassword: LoginCubit.get(context).isPassword,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            prefix: Icons.lock_outline),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            text: 'Login',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            radius: 5.0,
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: const Text(
                                  'REGISTER',
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}