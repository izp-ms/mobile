import 'package:mobile/helpers/date_extractor.dart';

class PostcardDto {
  final int id;
  final String? title;
  final String? content;
  final int? postcardDataId;
  final String? createdAt;
  late final int? userId;
  final bool isSent;

  PostcardDto({
    required this.id,
    required this.title,
    required this.content,
    required this.postcardDataId,
    required this.createdAt,
    required this.userId,
    required this.isSent,
  });

  factory PostcardDto.fromJson(Map<String, dynamic> json) {
    return PostcardDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      postcardDataId: json['postcardDataId'] ?? 0,
      createdAt: dateExtractor(json['createdAt']),
      userId: json['userId'] ?? 0,
      isSent: json['isSent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'postcardDataId': postcardDataId,
      'createdAt': dateExtractor(createdAt),
      'userId': userId,
      'isSent': isSent,
    };
  }
}

class PostcardTransferRequest {
  final PostcardDto postcardDto;
  final int newUserId;

  PostcardTransferRequest({
    required this.postcardDto,
    required this.newUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'postcardDto': postcardDto.toJson(),
      'newUserId': newUserId,
    };
  }

  factory PostcardTransferRequest.fromJson(Map<String, dynamic> json) {
    return PostcardTransferRequest(
      postcardDto: PostcardDto.fromJson(json['postcardDto'] ?? {}),
      newUserId: json['newUserId'] ?? 0,
    );
  }
}