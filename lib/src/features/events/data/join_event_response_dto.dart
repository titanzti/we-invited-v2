/// DTO for join event API response (transport layer)
class JoinEventResponseDto {
  final String status;
  final String? message;

  const JoinEventResponseDto({
    required this.status,
    this.message,
  });

  factory JoinEventResponseDto.fromJson(Map<String, dynamic> json) {
    return JoinEventResponseDto(
      status: json['status'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (message != null) 'message': message,
    };
  }
}
