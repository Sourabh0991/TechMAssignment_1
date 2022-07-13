class User {
  String id;
  final String name;
  final int age;
  final String email_id;
  final String phone;
  final String password;

  User(
      {this.id = '',
      required this.name,
      required this.age,
      required this.email_id,
      required this.phone,
      required this.password});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'email_id': email_id,
        'phone': phone,
        'password': password
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      age: int.parse(json['age'].toString()),
      email_id: json['email_id'],
      phone: json['phone'],
      password: json['password']);
}
