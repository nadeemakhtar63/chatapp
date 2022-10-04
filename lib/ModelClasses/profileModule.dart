class ProfileModule
{
  String? username;
  String? email;
  String? password;
  String? image;
  ProfileModule({this.username, this.email, this.password, this.image});
  ProfileModule.fromJson(Map<String, dynamic> json)
  {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
  }
  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    return data;
  }
}