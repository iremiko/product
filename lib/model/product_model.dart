
class Product {
  int id;
  String code;
  String name;
  String photo;
  int price;
  String lastUpdated;


  Product(
  {this.id, this.code, this.name, this.photo, this.price, this.lastUpdated});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    name = json['Name'];
    photo = json['Photo'];
    price = json['Price'];
    lastUpdated = json['LastUpdated'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['Photo'] = this.photo;
    data['Price'] = this.price;
    data['LastUpdated'] = this.lastUpdated;


    return data;
  }
}
