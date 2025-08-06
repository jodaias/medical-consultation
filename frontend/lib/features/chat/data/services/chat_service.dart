import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:medical_consultation_app/core/custom_dio/rest.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/chat/data/models/message_model.dart';

class ChatService {
  final Rest rest;
  ChatService(this.rest);
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
  Future<RestResult<MessageModel>> sendMessage({
    required String consultationId,
    required String content,
    String? attachmentPath,
  }) async {
    final result = await rest.postModel<MessageModel>(
      'messages',
      {
        'consultationId': consultationId,
        'content': content,
        'messageType': attachmentPath != null
            ? AppConstants.fileMessage
            : AppConstants.textMessage,
        'attachmentPath': attachmentPath,
      },
      parse: (data) => MessageModel.fromJson(data['data']),
    );
    if (result.success) {
      _socket?.emit('send_message', {
        'consultationId': consultationId,
        'message': result.data.toJson(),
      });
    }
    return result;
  }

  // Buscar mensagens (novo padrão)
  Future<RestResult<List<MessageModel>>> getMessages(
      String consultationId) async {
    return await rest.getList<MessageModel>(
      'messages/consultation/$consultationId',
      (json) => MessageModel.fromJson(json!),
    );
  }

  // Marcar mensagem como lida (novo padrão)
  Future<RestResult> markMessageAsRead(String messageId) async {
    return await rest.postModel(
      'messages/mark-read',
      {'messageId': messageId},
    );
  }

  // Marcar todas as mensagens como lidas (novo padrão)
  Future<RestResult> markAllMessagesAsRead(String consultationId) async {
    return await rest.postModel(
      'messages/consultation/$consultationId/mark-all-read',
      (_) => null,
    );
  }

  // Editar mensagem (novo padrão)
  Future<RestResult<MessageModel>> editMessage(
      String messageId, String newContent) async {
    final result = await rest.putModel<MessageModel>(
      'messages/$messageId',
      body: {'content': newContent},
      parse: (data) => MessageModel.fromJson(data['data']),
    );
    if (result.success) {
      _socket?.emit('edit_message', {
        'messageId': messageId,
        'message': result.data.toJson(),
      });
    }
    return result;
  }

  // Deletar mensagem (novo padrão)
  Future<RestResult> deleteMessage(String messageId) async {
    final result = await rest.deleteModel(
      'messages/$messageId',
      (_) => null,
    );
    if (result.success) {
      _socket?.emit('delete_message', {
        'messageId': messageId,
      });
    }
    return result;
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
