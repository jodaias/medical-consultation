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

  // Obter token de autenticação
  Future<String> _getAuthToken() async {
    // TODO: Implementar obtenção do token de autenticação
    // Por enquanto, retornar token mock
    return 'mock_token';
  }

  // Conectar ao chat
  Future<void> connect(String consultationId) async {
    try {
      _socket = IO.io(AppConstants.socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {
          'consultationId': consultationId,
          'token': await _getAuthToken(),
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
      final response = await _apiService.post('messages', data: {
        'consultationId': consultationId,
        'content': content,
        'messageType': attachmentPath != null
            ? AppConstants.fileMessage
            : AppConstants.textMessage,
        'attachmentPath': attachmentPath,
      });

      if (response.data['success'] == true) {
        final message = MessageModel.fromJson(response.data['data']);

        // Emitir evento para outros usuários
        _socket?.emit('send_message', {
          'consultationId': consultationId,
          'message': response.data['data'],
        });

        return message;
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao enviar mensagem');
      }
    } catch (e) {
      throw Exception('Erro ao enviar mensagem: $e');
    }
  }

  // Buscar mensagens
  Future<List<MessageModel>> getMessages(String consultationId) async {
    try {
      final response =
          await _apiService.get('messages/consultation/$consultationId');

      if (response.data['success'] == true) {
        final List<dynamic> messagesData = response.data['data']['messages'];
        return messagesData.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao buscar mensagens');
      }
    } catch (e) {
      throw Exception('Erro ao buscar mensagens: $e');
    }
  }

  // Marcar mensagem como lida
  Future<void> markMessageAsRead(String messageId) async {
    try {
      final response = await _apiService.post('messages/mark-read', data: {
        'messageId': messageId,
      });

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Erro ao marcar mensagem como lida');
      }
    } catch (e) {
      throw Exception('Erro ao marcar mensagem como lida: $e');
    }
  }

  // Marcar todas as mensagens como lidas
  Future<void> markAllMessagesAsRead(String consultationId) async {
    try {
      final response = await _apiService
          .post('messages/consultation/$consultationId/mark-all-read');

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Erro ao marcar mensagens como lidas');
      }
    } catch (e) {
      throw Exception('Erro ao marcar mensagens como lidas: $e');
    }
  }

  // Editar mensagem
  Future<MessageModel> editMessage(String messageId, String newContent) async {
    try {
      final response = await _apiService.put('messages/$messageId', data: {
        'content': newContent,
      });

      if (response.data['success'] == true) {
        final message = MessageModel.fromJson(response.data['data']);

        // Emitir evento para outros usuários
        _socket?.emit('edit_message', {
          'messageId': messageId,
          'message': response.data['data'],
        });

        return message;
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao editar mensagem');
      }
    } catch (e) {
      throw Exception('Erro ao editar mensagem: $e');
    }
  }

  // Deletar mensagem
  Future<void> deleteMessage(String messageId) async {
    try {
      final response = await _apiService.delete('messages/$messageId');

      if (response.data['success'] == true) {
        // Emitir evento para outros usuários
        _socket?.emit('delete_message', {
          'messageId': messageId,
        });
      } else {
        throw Exception(response.data['message'] ?? 'Erro ao deletar mensagem');
      }
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
