import 'package:mobile_app/features/friends/data/friend_model.dart';
import 'package:mobile_app/features/friends/data/friend_request_model.dart';

class FriendState {}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<Friend> friends;
  final List<FriendRequest> pendingRequests;

  FriendLoaded({required this.friends, required this.pendingRequests});
}

class FriendError extends FriendState {
  final String message;
  FriendError(this.message);
}
