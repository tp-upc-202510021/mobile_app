class FriendRequest {
  final int friendshipId;
  final String requesterName;

  FriendRequest({required this.friendshipId, required this.requesterName});

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      friendshipId: json['friendship_id'],
      requesterName: json['requester_name'],
    );
  }
}
