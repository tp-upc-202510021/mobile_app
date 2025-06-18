import 'package:mobile_app/features/friends/data/friend_model.dart';
import 'package:mobile_app/features/friends/data/friend_request_model.dart';
import 'package:mobile_app/features/friends/data/friend_service.dart';

class FriendRepository {
  final FriendService service;

  FriendRepository(this.service);

  Future<List<Friend>> getFriends() async {
    final data = await service.getFriends();
    return data.map((json) => Friend.fromJson(json)).toList();
  }

  Future<List<FriendRequest>> getPendingRequests() async {
    final data = await service.getPendingRequests();
    return data.map((json) => FriendRequest.fromJson(json)).toList();
  }

  Future<void> sendFriendRequest(int receiverId) async {
    await service.sendFriendRequest(receiverId);
  }

  Future<void> respondRequest(int requestId, String action) async {
    await service.respondRequest(requestId, action);
  }
}
