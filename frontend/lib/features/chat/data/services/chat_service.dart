import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/chat/data/models/message_model.dart';

class ChatService {
  final ApiService _apiService = ApiService();
  IO.Socket? _socket;
  Function(MessageModel)? _onMessageReceived;
  Function(MessageModel)? _onMessageUpdated;
  Function(String)? _onMessageDeleted;
  Function(String)? _onTypingStarted;
  Function(String)? _onTypingStopped;

  // Conectar ao chat
  Future<void> connect(String consultationId) async {
    try {
      _socket = IO.io(AppConstants.socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {
          'consultationId': consultationId,
          // TODO: Adicionar token de autenticação
        },
      });

      _setupSocketListeners();

      _socket!.connect();
    } catch (e) {
      throw Exception('Erro ao conectar ao chat: $e');
    }
  }

  // Configurar listeners do socket
  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      print('Conectado ao chat');
    });

    _socket!.onDisconnect((_) {
      print('Desconectado do chat');
    });

    _socket!.onConnectError((error) {
      print('Erro de conexão: $error');
    });

    _socket!.on('message', (data) {
      final message = MessageModel.fromJson(data);
      _onMessageReceived?.call(message);
    });

    _socket!.on('message_updated', (data) {
      final message = MessageModel.fromJson(data);
      _onMessageUpdated?.call(message);
    });

    _socket!.on('message_deleted', (data) {
      final messageId = data['messageId'];
      _onMessageDeleted?.call(messageId);
    });

    _socket!.on('typing_started', (data) {
      final userId = data['userId'];
      _onTypingStarted?.call(userId);
    });

    _socket!.on('typing_stopped', (data) {
      final userId = data['userId'];
      _onTypingStopped?.call(userId);
    });
  }

  // Desconectar do chat
  Future<void> disconnect() async {
    try {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    } catch (e) {
      throw Exception('Erro ao desconectar do chat: $e');
    }
  }

  // Enviar mensagem
  Future<MessageModel> sendMessage({
    required String consultationId,
    required String content,
    String? attachmentPath,
  }) async {
    try {
      final response = await _apiService.post('/chat/messages', data: {
        'consultationId': consultationId,
        'content': content,
        'messageType': attachmentPath != null
            ? AppConstants.fileMessage
            : AppConstants.textMessage,
        'attachmentPath': attachmentPath,
      });

      final message = MessageModel.fromJson(response.data);

      // Emitir evento para outros usuários
      _socket?.emit('send_message', {
        'consultationId': consultationId,
        'message': response.data,
      });

      return message;
    } catch (e) {
      throw Exception('Erro ao enviar mensagem: $e');
    }
  }

  // Buscar mensagens
  Future<List<MessageModel>> getMessages(String consultationId) async {
    try {
      final response = await _apiService.get('/chat/messages/$consultationId');

      final List<dynamic> messagesData = response.data['messages'];
      return messagesData.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar mensagens: $e');
    }
  }

  // Marcar mensagem como lida
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _apiService.put('/chat/messages/$messageId/read');
    } catch (e) {
      throw Exception('Erro ao marcar mensagem como lida: $e');
    }
  }

  // Marcar todas as mensagens como lidas
  Future<void> markAllMessagesAsRead(String consultationId) async {
    try {
      await _apiService.put('/chat/messages/$consultationId/read-all');
    } catch (e) {
      throw Exception('Erro ao marcar mensagens como lidas: $e');
    }
  }

  // Editar mensagem
  Future<MessageModel> editMessage(String messageId, String newContent) async {
    try {
      final response =
          await _apiService.put('/chat/messages/$messageId', data: {
        'content': newContent,
      });

      final message = MessageModel.fromJson(response.data);

      // Emitir evento para outros usuários
      _socket?.emit('edit_message', {
        'messageId': messageId,
        'message': response.data,
      });

      return message;
    } catch (e) {
      throw Exception('Erro ao editar mensagem: $e');
    }
  }

  // Deletar mensagem
  Future<void> deleteMessage(String messageId) async {
    try {
      await _apiService.delete('/chat/messages/$messageId');

      // Emitir evento para outros usuários
      _socket?.emit('delete_message', {
        'messageId': messageId,
      });
    } catch (e) {
      throw Exception('Erro ao deletar mensagem: $e');
    }
  }

  // Enviar indicador de digitação
  void sendTypingIndicator(String consultationId, bool isTyping) {
    _socket?.emit('typing', {
      'consultationId': consultationId,
      'isTyping': isTyping,
    });
  }

  // Setters para callbacks
  void setOnMessageReceived(Function(MessageModel) callback) {
    _onMessageReceived = callback;
  }

  void setOnMessageUpdated(Function(MessageModel) callback) {
    _onMessageUpdated = callback;
  }

  void setOnMessageDeleted(Function(String) callback) {
    _onMessageDeleted = callback;
  }

  void setOnTypingStarted(Function(String) callback) {
    _onTypingStarted = callback;
  }

  void setOnTypingStopped(Function(String) callback) {
    _onTypingStopped = callback;
  }

  // Verificar se está conectado
  bool get isConnected => _socket?.connected ?? false;
}
