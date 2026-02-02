import 'package:earning_app/model/usermodel.dart';

abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final UserModel user;
  CreateUserEvent(this.user);
}

class LoadUserEvent extends UserEvent {}

class RefreshUserEvent extends UserEvent {}
