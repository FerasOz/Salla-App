import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/cubit/shop_cubit/cubit/shop_cubit.dart';
import '../styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 10.0,
  bool isUpper = true,
  required String text,
  required Function function,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required Function? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool? isClickable,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      enabled: isClickable,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        return onSubmit!(value);
      },
      onChanged: (value) {
        return onChange!(value);
      },
      validator: (value) {
        return validate!(value);
      },
      onTap: () {
        return onTap!();
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: () {
            suffixPressed!();
          },
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget divider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey,
  ),
);


void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );

void showToast({
  required String text,
  required ToastStates state
}) => Fluttertoast.showToast(
msg: text,
toastLength: Toast.LENGTH_SHORT,
gravity: ToastGravity.BOTTOM,
timeInSecForIosWeb: 1,
backgroundColor: chooseToastState(state),
textColor: Colors.white,
fontSize: 16.0
);

enum ToastStates{SUCCESS, ERROR, WARNING}

Color chooseToastState(ToastStates state){

  Color color;

  switch(state){
    case ToastStates.SUCCESS:
    color = Colors.green;
    break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;

}


Widget buildListItem(
    model,
    context,
    {bool isOldPrice = true}) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: SizedBox(
    height: 120.0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage('${model.image}'),
              width: 120.0,
              height: 120.0,
            ),
            if (model.discount != 0 && isOldPrice)
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
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontWeight: FontWeight.w600, height: 2),
              ),
              const Spacer(),
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
                  if (model.discount != 0 && isOldPrice)
                    Text(
                      '${model.oldPrice}',
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
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor:
                      ShopCubit.get(context).favorites[model.id]!
                          ? primaryColor
                          : Colors.grey,
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
  ),
);
