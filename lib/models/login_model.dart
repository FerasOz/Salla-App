class ShopLoginModel{
  bool status = false;
  String? message;
  UserData? data;

  ShopLoginModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null ;
  }
}

class UserData{
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  int? points;
  int? credit;
  String? token;

  UserData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];

  }
}