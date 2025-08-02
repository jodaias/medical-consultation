import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String consultationId;
  final String senderId;
  final String senderName;
  final String content;
  final String messageType;
  final String? attachmentUrl;
  final String? attachmentName;
  final DateTime timestamp;
  final bool isRead;
  final bool isEdited;
  final bool isDeleted;

  MessageModel({
    required this.id,
    required this.consultationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.messageType = AppConstants.textMessage,
    this.attachmentUrl,
    this.attachmentName,
    required this.timestamp,
    this.isRead = false,
    this.isEdited = false,
    this.isDeleted = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  MessageModel copyWith({
    String? id,
    String? consultationId,
    String? senderId,
    String? senderName,
    String? content,
    String? messageType,
    String? attachmentUrl,
    String? attachmentName,
    DateTime? timestamp,
    bool? isRead,
    bool? isEdited,
    bool? isDeleted,
  }) {
    return MessageModel(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentName: attachmentName ?? this.attachmentName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MessageModel(id: $id, senderName: $senderName, content: $content, timestamp: $timestamp)';
  }
}
