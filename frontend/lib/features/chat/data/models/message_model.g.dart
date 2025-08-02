// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String,
      consultationId: json['consultationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] as String? ?? AppConstants.textMessage,
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentName: json['attachmentName'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'consultationId': instance.consultationId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'content': instance.content,
      'messageType': instance.messageType,
      'attachmentUrl': instance.attachmentUrl,
      'attachmentName': instance.attachmentName,
      'timestamp': instance.timestamp.toIso8601String(),
      'isRead': instance.isRead,
      'isEdited': instance.isEdited,
      'isDeleted': instance.isDeleted,
    };
