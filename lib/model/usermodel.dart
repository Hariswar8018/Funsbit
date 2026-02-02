class UserModel {
  final String id;
  final String name;
  final String password;
  final String phone;
  final String email;

  final String lastLogin;
  final String lastCheckIn;

  final List<String> gamesPlayed;

  final int balance;
  final int walletBalance;
  final int withdrawalBalance;

  final int level;
  final int totalTaps;
  final int totalAdsSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.phone,
    required this.email,
    required this.lastLogin,
    required this.lastCheckIn,
    required this.gamesPlayed,
    required this.balance,
    required this.walletBalance,
    required this.withdrawalBalance,
    required this.level,
    required this.totalTaps,
    required this.totalAdsSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'phone': phone,
      'email': email,
      'lastLogin': lastLogin,
      'lastCheckIn': lastCheckIn,
      'gamesPlayed': gamesPlayed,
      'balance': balance,
      'walletBalance': walletBalance,
      'withdrawalBalance': withdrawalBalance,
      'level': level,
      'totalTaps': totalTaps,
      'totalAdsSeen': totalAdsSeen,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      lastLogin: map['lastLogin'] ?? '',
      lastCheckIn: map['lastCheckIn'] ?? '',
      gamesPlayed: List<String>.from(map['gamesPlayed'] ?? []),
      balance: int.tryParse(map['balance'].toString()) ?? 0,
      walletBalance: int.tryParse(map['walletBalance'].toString()) ?? 0,
      withdrawalBalance:
      int.tryParse(map['withdrawalBalance'].toString()) ?? 0,
      level: int.tryParse(map['level'].toString()) ?? 0,
      totalTaps: int.tryParse(map['totalTaps'].toString()) ?? 0,
      totalAdsSeen: int.tryParse(map['totalAdsSeen'].toString()) ?? 0,
    );
  }
}
