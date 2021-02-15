class User {
  int userId;
  int username;
  String password;
  String firstName;
  String lastName;


  User.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    username = json['UserName'];
    password = json['Password'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['UserName'] = this.username;
    data['Password'] = this.password;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;

    return data;
  }

}