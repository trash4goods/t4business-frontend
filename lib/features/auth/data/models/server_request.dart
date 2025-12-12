class ServerRequest {
  int statusCode;

  // Response from the Server. It can come as a Map<String, dynamic>
  // or as a List<dynamic>. You should treat it according to the
  // request you made and the values you are expecting.
  dynamic response;

  ServerRequest({required this.statusCode, required this.response});
}
