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

  final String level;
  final int totalTaps;
  final int totalAdsSeen;

  final String lastSpin;
  final String lastSpin2;
  final String lastUse1;
  final String lastUse2;

  // 🔹 NEW FIELDS
  final int referral;
  final List<String> myReferral;
  final String myReferralCode;
  final int totalDone;

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
    required this.lastSpin,
    required this.lastSpin2,
    required this.lastUse1,
    required this.lastUse2,

    // 🔹 NEW
    required this.referral,
    required this.myReferral,
    required this.myReferralCode,
    required this.totalDone,
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
      'lastSpin': lastSpin,
      'lastSpin2': lastSpin2,
      'lastUse1': lastUse1,
      'lastUse2': lastUse2,

      // 🔹 NEW
      'referral': referral,
      'myReferral': myReferral,
      'myReferralCode': myReferralCode,
      'totalDone': totalDone,
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
      balance: int.tryParse(map['balance']?.toString() ?? '0') ?? 0,
      walletBalance:
      int.tryParse(map['walletBalance']?.toString() ?? '0') ?? 0,
      withdrawalBalance:
      int.tryParse(map['withdrawalBalance']?.toString() ?? '0') ?? 0,
      level: map['level'] ?? '1',
      totalTaps:
      int.tryParse(map['totalTaps']?.toString() ?? '0') ?? 0,
      totalAdsSeen:
      int.tryParse(map['totalAdsSeen']?.toString() ?? '0') ?? 0,
      lastSpin: map['lastSpin'] ?? '',
      lastSpin2: map['lastSpin2'] ?? '',
      lastUse1: map['lastUse1'] ?? '',
      lastUse2: map['lastUse2'] ?? '',

      // 🔹 NEW
      referral: int.tryParse(map['referral']?.toString() ?? '0') ?? 0,
      myReferral: List<String>.from(map['myReferral'] ?? []),
      myReferralCode: map['myReferralCode'] ?? '',
      totalDone: int.tryParse(map['totalDone']?.toString() ?? '0') ?? 0,
    );
  }
}
