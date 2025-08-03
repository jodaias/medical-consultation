import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/chat/domain/stores/chat_store.dart';
import 'package:medical_consultation_app/features/chat/data/models/message_model.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/chat/presentation/widgets/file_picker_widget.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';

class ChatPage extends StatefulWidget {
  final String consultationId;

  const ChatPage({super.key, required this.consultationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatStore _chatStore = getIt<ChatStore>();
  final AuthStore _authStore = getIt<AuthStore>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _connectToChat();
    _setupChatListeners();
  }

  @override
  void dispose() {
    _chatStore.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  Future<void> _connectToChat() async {
    await _chatStore.connectToChat(widget.consultationId);
  }

  void _setupChatListeners() {
    _chatStore.setOnMessageReceived((message) {
      _scrollToBottom();
    });

    _chatStore.setOnTypingStarted((userId) {
      _chatStore.onTypingStarted(userId);
    });

    _chatStore.setOnTypingStopped((userId) {
      _chatStore.onTypingStopped(userId);
    });

    // Adicionar listener para digitação
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Cancelar timer anterior
    _typingTimer?.cancel();

    // Enviar evento de digitação iniciada
    _chatStore.sendTypingIndicator(widget.consultationId, true);

    // Configurar timer para parar digitação após 2 segundos
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _chatStore.sendTypingIndicator(widget.consultationId, false);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    await _chatStore.sendMessage(message);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _chatStore.sendMessage(
          'Imagem enviada',
          attachmentPath: image.path,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao selecionar imagem');
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        await _chatStore.sendMessage(
          'Arquivo enviado: ${file.name}',
          attachmentPath: file.path,
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao selecionar arquivo');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consulta Médica',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Observer(
              builder: (_) => Text(
                _chatStore.isConnected ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  color: _chatStore.isConnected
                      ? AppTheme.successColor
                      : AppTheme.textSecondaryColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Mostrar menu de opções
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status de conexão
          Observer(
            builder: (_) => _chatStore.errorMessage != null
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    child: Text(
                      _chatStore.errorMessage!,
                      style: TextStyle(color: AppTheme.errorColor),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Lista de mensagens
          Expanded(
            child: Observer(
              builder: (_) {
                if (_chatStore.isLoading && _chatStore.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_chatStore.messages.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma mensagem ainda',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Inicie a conversa enviando uma mensagem',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding:
                            const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: _chatStore.messages.length,
                        itemBuilder: (context, index) {
                          final message = _chatStore.messages[index];
                          final isMyMessage =
                              message.senderId == _authStore.userId;

                          return _buildMessageBubble(message, isMyMessage);
                        },
                      ),
                    ),
                    // Indicador de digitação
                    Observer(
                      builder: (_) => _chatStore.typingUsers.isNotEmpty
                          ? _buildTypingIndicator()
                          : const SizedBox.shrink(),
                    ),
                  ],
                );
              },
            ),
          ),

          // Campo de entrada de mensagem
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isMyMessage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                message.senderName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: isMyMessage
                    ? AppTheme.primaryColor
                    : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: isMyMessage
                    ? null
                    : Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMyMessage) ...[
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (message.messageType == AppConstants.imageMessage)
                    _buildImageMessage(message)
                  else if (message.messageType == AppConstants.fileMessage)
                    _buildFileMessage(message)
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isMyMessage
                            ? Colors.white
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMyMessage
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppTheme.textSecondaryColor,
                        ),
                      ),
                      if (isMyMessage) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 12,
                          color: message.isRead
                              ? Colors.blue
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(MessageModel message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          child: Image.network(
            message.attachmentUrl!,
            width: 200,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200,
                height: 150,
                color: AppTheme.errorColor.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.broken_image,
                  color: AppTheme.errorColor,
                ),
              );
            },
          ),
        ),
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(message.content),
        ],
      ],
    );
  }

  Widget _buildFileMessage(MessageModel message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.attach_file,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.attachmentName ?? 'Arquivo',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(message.content),
        ],
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Row(
        children: [
          // Botão de anexo
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions();
            },
            color: AppTheme.primaryColor,
          ),

          // Botão de anexar
          IconButton(
            onPressed: () => _showFilePicker(),
            icon: Icon(
              Icons.attach_file,
              color: AppTheme.primaryColor,
            ),
          ),

          // Campo de texto
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Digite sua mensagem...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding,
                  vertical: AppConstants.smallPadding,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),

          // Botão de enviar
          Observer(
            builder: (_) => IconButton(
              icon: const Icon(Icons.send),
              onPressed: _messageController.text.trim().isNotEmpty
                  ? _sendMessage
                  : null,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Enviar imagem'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Enviar arquivo'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      margin: const EdgeInsets.only(
        left: AppConstants.defaultPadding,
        right: AppConstants.defaultPadding,
        bottom: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            'Alguém está digitando',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          _buildTypingAnimation(),
        ],
      ),
    );
  }

  Widget _buildTypingAnimation() {
    return Row(
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 600 + (index * 200)),
          margin: const EdgeInsets.only(right: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 200)),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            onEnd: () {
              // Reiniciar animação
              if (mounted) {
                setState(() {});
              }
            },
          ),
        );
      }),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month}';
    } else if (difference.inHours > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return time.minute.toString().padLeft(2, '0');
    }
  }

  void _showFilePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FilePickerWidget(
          consultationId: widget.consultationId,
          onFileSelected: (fileUrl) {
            // Enviar mensagem com arquivo
            _sendFileMessage(fileUrl);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _sendFileMessage(String fileUrl) {
    // Criar mensagem com arquivo
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      consultationId: widget.consultationId,
      senderId: _authStore.userId!,
      senderName: _authStore.userName ?? 'Usuário',
      content: 'Arquivo anexado',
      messageType: _getMessageTypeFromUrl(fileUrl),
      attachmentUrl: fileUrl,
      attachmentName: fileUrl.split('/').last,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Adicionar mensagem à lista
    _chatStore.addMessage(message);
  }

  String _getMessageTypeFromUrl(String url) {
    final extension = url.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return 'IMAGE';
    } else if (['pdf', 'doc', 'docx', 'txt'].contains(extension)) {
      return 'FILE';
    } else {
      return 'TEXT';
    }
  }
}
