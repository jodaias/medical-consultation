// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  Computed<bool>? _$hasMessagesComputed;

  @override
  bool get hasMessages =>
      (_$hasMessagesComputed ??= Computed<bool>(() => super.hasMessages,
              name: '_ChatStore.hasMessages'))
          .value;
  Computed<int>? _$unreadCountComputed;

  @override
  int get unreadCount =>
      (_$unreadCountComputed ??= Computed<int>(() => super.unreadCount,
              name: '_ChatStore.unreadCount'))
          .value;

  late final _$messagesAtom =
      Atom(name: '_ChatStore.messages', context: context);

  @override
  ObservableList<MessageModel> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<MessageModel> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ChatStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isConnectedAtom =
      Atom(name: '_ChatStore.isConnected', context: context);

  @override
  bool get isConnected {
    _$isConnectedAtom.reportRead();
    return super.isConnected;
  }

  @override
  set isConnected(bool value) {
    _$isConnectedAtom.reportWrite(value, super.isConnected, () {
      super.isConnected = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ChatStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$currentConsultationIdAtom =
      Atom(name: '_ChatStore.currentConsultationId', context: context);

  @override
  String get currentConsultationId {
    _$currentConsultationIdAtom.reportRead();
    return super.currentConsultationId;
  }

  @override
  set currentConsultationId(String value) {
    _$currentConsultationIdAtom.reportWrite(value, super.currentConsultationId,
        () {
      super.currentConsultationId = value;
    });
  }

  late final _$typingUsersAtom =
      Atom(name: '_ChatStore.typingUsers', context: context);

  @override
  ObservableSet<String> get typingUsers {
    _$typingUsersAtom.reportRead();
    return super.typingUsers;
  }

  @override
  set typingUsers(ObservableSet<String> value) {
    _$typingUsersAtom.reportWrite(value, super.typingUsers, () {
      super.typingUsers = value;
    });
  }

  late final _$connectToChatAsyncAction =
      AsyncAction('_ChatStore.connectToChat', context: context);

  @override
  Future<void> connectToChat(String consultationId) {
    return _$connectToChatAsyncAction
        .run(() => super.connectToChat(consultationId));
  }

  late final _$disconnectAsyncAction =
      AsyncAction('_ChatStore.disconnect', context: context);

  @override
  Future<void> disconnect() {
    return _$disconnectAsyncAction.run(() => super.disconnect());
  }

  late final _$loadMessagesAsyncAction =
      AsyncAction('_ChatStore.loadMessages', context: context);

  @override
  Future<void> loadMessages(String consultationId) {
    return _$loadMessagesAsyncAction
        .run(() => super.loadMessages(consultationId));
  }

  late final _$sendMessageAsyncAction =
      AsyncAction('_ChatStore.sendMessage', context: context);

  @override
  Future<void> sendMessage(String content, {String? attachmentPath}) {
    return _$sendMessageAsyncAction
        .run(() => super.sendMessage(content, attachmentPath: attachmentPath));
  }

  late final _$_ChatStoreActionController =
      ActionController(name: '_ChatStore', context: context);

  @override
  void addMessage(MessageModel message) {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.addMessage');
    try {
      return super.addMessage(message);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markMessageAsRead(String messageId) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.markMessageAsRead');
    try {
      return super.markMessageAsRead(messageId);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllAsRead() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.markAllAsRead');
    try {
      return super.markAllAsRead();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateConnectionStatus(bool connected) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.updateConnectionStatus');
    try {
      return super.updateConnectionStatus(connected);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendTypingIndicator(String consultationId, bool isTyping) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.sendTypingIndicator');
    try {
      return super.sendTypingIndicator(consultationId, isTyping);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
isLoading: ${isLoading},
isConnected: ${isConnected},
errorMessage: ${errorMessage},
currentConsultationId: ${currentConsultationId},
typingUsers: ${typingUsers},
hasMessages: ${hasMessages},
unreadCount: ${unreadCount}
    ''';
  }
}
