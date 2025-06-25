import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/friends/data/friend_repository.dart';
import 'package:mobile_app/features/friends/friend_profile_state.dart';

import 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final FriendRepository repository;

  FriendCubit(this.repository) : super(FriendInitial());

  Future<void> loadFriendsAndRequests() async {
    emit(FriendLoading());
    try {
      final friends = await repository.getFriends();
      final pending = await repository.getPendingRequests();
      emit(FriendLoaded(friends: friends, pendingRequests: pending));
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> loadFriends() async {
    emit(FriendLoading());
    try {
      final friends = await repository.getFriends();
      emit(FriendOnlyLoaded(friends: friends));
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> sendRequest(int receiverId) async {
    try {
      await repository.sendFriendRequest(receiverId);
      await loadFriendsAndRequests();
    } catch (e) {
      emit(FriendError('Error sending request: $e'));
    }
  }

  Future<void> respondRequest(int requestId, String action) async {
    try {
      await repository.respondRequest(requestId, action);
      await loadFriendsAndRequests();
    } catch (e) {
      emit(FriendError('Error responding to request: $e'));
    }
  }

  Future<void> loadFriendProfile(int id) async {
    emit(FriendProfileLoading());
    try {
      final profile = await repository.getFriendProfile(id);
      emit(FriendProfileLoaded(profile));
    } catch (e) {
      emit(FriendProfileError('No se pudo cargar el perfil del amigo'));
    }
  }
}
