import 'package:mobile_app/features/friends/data/friend_profile_model.dart';
import 'package:mobile_app/features/friends/friend_state.dart';

abstract class FriendProfileState {}

class FriendProfileInitial extends FriendState {}

class FriendProfileLoading extends FriendState {}

class FriendProfileLoaded extends FriendState {
  final FriendProfile profile;

  FriendProfileLoaded(this.profile);
}

class FriendProfileError extends FriendState {
  final String message;

  FriendProfileError(this.message);
}
