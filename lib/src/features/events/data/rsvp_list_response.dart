import '../domain/rsvp_model.dart';

/// Response model for GET /rsvp/:eventId which returns both data and stats.
class RsvpListResponse {
  List<RSVPModel>? data;
  RSVPStats? stats;

  RsvpListResponse({
    this.data,
    this.stats,
  });

  factory RsvpListResponse.fromJson(Map<String, dynamic> json) =>
      RsvpListResponse(
        data: json["data"] == null
            ? []
            : List<RSVPModel>.from(
                (json["data"] as List).map((x) => RSVPModel.fromJson(x)),
              ),
        stats: json["stats"] == null
            ? null
            : RSVPStats.fromJson(json["stats"]),
      );
}
