import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/bloc/state.dart' show UserSuccess, UserFailure, UserState, UserInitial, UserLoading;
import 'package:earning_app/login/bloc/userevent.dart';
import 'package:earning_app/model/usermodel.dart' show UserModel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUserEvent>(_loadUser);
    on<RefreshUserEvent>(_loadUser);
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _loadUser(
      UserEvent event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());

    try {
      final uid = _auth.currentUser!.uid;
      final email = _auth.currentUser!.email ?? '';

      final ref = _firestore.collection("users").doc(uid);
      final doc = await ref.get();

      UserModel user;

      if (!doc.exists) {
        user = UserModel(
          id: uid,
          name: '',
          password: '',
          phone: '',
          email: email,
          lastLogin: DateTime.now().toIso8601String(),
          lastCheckIn: DateTime.now().toIso8601String(),
          gamesPlayed: [],
          balance: 0,
          walletBalance: 0,
          withdrawalBalance: 0,
          level: '1',
          totalTaps: 0,
          totalAdsSeen: 0,
          lastSpin: '',
          lastSpin2: '',
          lastUse1: '',
          lastUse2: '',
        );

        await ref.set(user.toMap());
      } else {
        user = UserModel.fromMap(doc.data()!);
      }

      GlobalUser.user = user;
      emit(UserSuccess(user));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

}

class GlobalUser {
  static late UserModel user ;
}
