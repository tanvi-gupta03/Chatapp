class MessageModel {
  final String type;
  final String message;
  final String time;

  MessageModel({
    required this.type,
    required this.message,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'time': time,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      type: json['type'],
      message: json['message'],
      time: json['time'],
    );
  }
}
