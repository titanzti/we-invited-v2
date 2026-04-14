class JoinEventResponseDto {
  final String status;
  final String? message;

  const JoinEventResponseDto({
    this.status = '',
    this.message,
  });

  factory JoinEventResponseDto.fromJson(Map<String, dynamic> json) =>
      JoinEventResponseDto(
        status: json["status"] ?? '',
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
