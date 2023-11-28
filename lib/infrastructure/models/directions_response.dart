class DirectionsResponse {
  String encodedPath;

  DirectionsResponse({
    required this.encodedPath,
  });

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) {
    return DirectionsResponse(
      encodedPath: json["encodedPath"],
    );
  }
}
