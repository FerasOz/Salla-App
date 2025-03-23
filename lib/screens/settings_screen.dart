import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/constants/constants.dart';
import 'package:shop_app/cubit/shop_cubit/cubit/shop_cubit.dart';
import 'package:shop_app/shared/components/components.dart';
    
class SettingsScreen extends StatelessWidget {

  const SettingsScreen({ super.key });
  
  @override
  Widget build(BuildContext context) {

    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<ShopCubit, ShopState>(
        builder: (context, state) {

          var model = ShopCubit.get(context).userModel;

          nameController.text = model!.data!.name!;
          emailController.text = model.data!.email!;
          phoneController.text = model.data!.phone!;

            print(model.data!.name);

          return ConditionalBuilder(
              condition: ShopCubit.get(context).userModel != null,
              builder: (context) => Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          if(state is ShopLoadingUpdateUserDataState)
                             const LinearProgressIndicator(),

                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  print('Name must not be empty');
                                }
                              },
                              label: 'Name',
                              prefix: Icons.person),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  print('Email must not be empty');
                                }
                              },
                              label: 'Email',
                              prefix: Icons.email),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  print('Phone must not be empty');
                                }
                              },
                              label: 'Phone',
                              prefix: Icons.phone),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultButton(
                              text: 'Update',
                              function: () {
                                if(formKey.currentState!.validate()){
                                  ShopCubit.get(context).updateUserData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text);
                                }
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultButton(
                              text: 'logout',
                              function: () {
                                SIGNOUT(context);
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              fallback: (context) => const Center(
                  child: CircularProgressIndicator())
          );
        },
        listener: (context, state) {

        }
    );
  }
}