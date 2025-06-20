class GameInvitationResponse {
  final String response;
  final int sessionId;

  GameInvitationResponse({required this.response, required this.sessionId});

  factory GameInvitationResponse.fromJson(Map<String, dynamic> json) {
    return GameInvitationResponse(
      response: json['response'] ?? 'rejected', // o cualquier valor por defecto
      sessionId: json['session_id'] ?? -1,
    );
  }
}
