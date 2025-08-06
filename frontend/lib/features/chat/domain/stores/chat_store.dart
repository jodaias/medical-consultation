import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/chat/data/models/message_model.dart';
import 'package:medical_consultation_app/features/chat/data/services/chat_service.dart';

part 'chat_store.g.dart';

@injectable
class ChatStore = ChatStoreBase with _$ChatStore;

abstract class ChatStoreBase with Store {
  final _chatService = getIt<ChatService>();

  @observable
  ObservableList<MessageModel> messages = ObservableList<MessageModel>();

  @observable
  bool isLoading = false;

  @observable
  bool isConnected = false;

  @observable
  String? errorMessage;

  @observable
  String currentConsultationId = '';

  @observable
  ObservableSet<String> typingUsers = ObservableSet<String>();

  @computed
  bool get hasMessages => messages.isNotEmpty;

  @computed
  int get unreadCount => messages.where((msg) => !msg.isRead).length;

  @action
  Future<void> connectToChat(String consultationId) async {
    isLoading = true;
    errorMessage = null;
    currentConsultationId = consultationId;

    try {
      await _chatService.connect(consultationId);
      isConnected = true;

      // Carregar mensagens existentes
      await loadMessages(consultationId);
    } catch (e) {
      errorMessage = e.toString();
      isConnected = false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> disconnect() async {
    try {
      await _chatService.disconnect();
      isConnected = false;
      messages.clear();
      currentConsultationId = '';
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> loadMessages(String consultationId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final result = await _chatService.getMessages(consultationId);

      if (result.success) {
        messages.clear();
        messages.addAll(result.data);
      } else {
        errorMessage = 'Nenhuma mensagem encontrada.';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> sendMessage(String content, {String? attachmentPath}) async {
    if (content.trim().isEmpty) return;

    try {
      final result = await _chatService.sendMessage(
        consultationId: currentConsultationId,
        content: content,
        attachmentPath: attachmentPath,
      );

      if (!result.success) {
        errorMessage = 'Erro ao enviar mensagem: ${result.error}';
        return;
      }
      messages.add(result.data);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  void addMessage(MessageModel message) {
    messages.add(message);
  }

  @action
  void markMessageAsRead(String messageId) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(isRead: true);
    }
  }

  @action
  void markAllAsRead() {
    for (int i = 0; i < messages.length; i++) {
      if (!messages[i].isRead) {
        messages[i] = messages[i].copyWith(isRead: true);
      }
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void updateConnectionStatus(bool connected) {
    isConnected = connected;
  }

  // Setters para callbacks do ChatService
  void setOnMessageReceived(Function(MessageModel) callback) {
    _chatService.setOnMessageReceived(callback);
  }

  void setOnMessageUpdated(Function(MessageModel) callback) {
    _chatService.setOnMessageUpdated(callback);
  }

  void setOnMessageDeleted(Function(String) callback) {
    _chatService.setOnMessageDeleted(callback);
  }

  void setOnTypingStarted(Function(String) callback) {
    _chatService.setOnTypingStarted(callback);
  }

  void setOnTypingStopped(Function(String) callback) {
    _chatService.setOnTypingStopped(callback);
  }

  // Listeners para eventos do Socket
  void onMessageReceived(MessageModel message) {
    addMessage(message);
  }

  void onMessageUpdated(MessageModel message) {
    final index = messages.indexWhere((msg) => msg.id == message.id);
    if (index != -1) {
      messages[index] = message;
    }
  }

  void onMessageDeleted(String messageId) {
    messages.removeWhere((msg) => msg.id == messageId);
  }

  void onTypingStarted(String userId) {
    typingUsers.add(userId);
  }

  void onTypingStopped(String userId) {
    typingUsers.remove(userId);
  }

  @action
  void sendTypingIndicator(String consultationId, bool isTyping) {
    _chatService.sendTypingIndicator(consultationId, isTyping);
  }
}
