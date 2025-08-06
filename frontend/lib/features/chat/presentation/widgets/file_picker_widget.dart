import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/services/file_upload_service.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';

class FilePickerWidget extends StatelessWidget {
  final Function(String) onFileSelected;
  final String consultationId;

  const FilePickerWidget({
    super.key,
    required this.onFileSelected,
    required this.consultationId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título
          Row(
            children: [
              Icon(
                Icons.attach_file,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Anexar arquivo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Opções de arquivo
          Row(
            children: [
              Expanded(
                child: _buildFileOption(
                  context,
                  icon: Icons.photo_library,
                  title: 'Galeria',
                  subtitle: 'Selecionar imagem',
                  onTap: () => _pickImageFromGallery(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFileOption(
                  context,
                  icon: Icons.camera_alt,
                  title: 'Câmera',
                  subtitle: 'Tirar foto',
                  onTap: () => _pickImageFromCamera(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildFileOption(
                  context,
                  icon: Icons.description,
                  title: 'Documento',
                  subtitle: 'Selecionar arquivo',
                  onTap: () => _pickDocument(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFileOption(
                  context,
                  icon: Icons.folder_open,
                  title: 'Múltiplos',
                  subtitle: 'Vários arquivos',
                  onTap: () => _pickMultipleFiles(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    try {
      final fileUploadService = getIt<FileUploadService>();
      final file = await fileUploadService.pickImageFromGallery();

      if (file != null) {
        await _uploadFile(context, file);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Erro ao selecionar imagem: $e');
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    try {
      final fileUploadService = getIt<FileUploadService>();
      final file = await fileUploadService.pickImageFromCamera();

      if (file != null) {
        await _uploadFile(context, file);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Erro ao capturar imagem: $e');
    }
  }

  Future<void> _pickDocument(BuildContext context) async {
    try {
      final fileUploadService = getIt<FileUploadService>();
      final file = await fileUploadService.pickDocument();

      if (file != null) {
        await _uploadFile(context, file);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Erro ao selecionar documento: $e');
    }
  }

  Future<void> _pickMultipleFiles(BuildContext context) async {
    try {
      final fileUploadService = getIt<FileUploadService>();
      final files = await fileUploadService.pickMultipleFiles();

      if (files.isNotEmpty) {
        await _uploadMultipleFiles(context, files);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Erro ao selecionar arquivos: $e');
    }
  }

  Future<void> _uploadFile(BuildContext context, dynamic file) async {
    try {
      final fileUploadService = getIt<FileUploadService>();

      // Mostrar indicador de progresso
      _showProgressDialog(context, 'Enviando arquivo...');

      final result = await fileUploadService.uploadFile(file, consultationId);

      // Fechar diálogo de progresso
      // ignore: use_build_context_synchronously
      context.pop();

      if (result.success) {
        onFileSelected(result.data['fileUrl']);
        // ignore: use_build_context_synchronously
        _showSuccessSnackBar(context, 'Arquivo enviado com sucesso!');
      } else {
        // ignore: use_build_context_synchronously
        _showErrorSnackBar(context, 'Erro ao enviar arquivo');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      context.pop(); // Fechar diálogo de progresso
      // ignore: use_build_context_synchronously
      _showErrorSnackBar(context, 'Erro ao enviar arquivo: $e');
    }
  }

  Future<void> _uploadMultipleFiles(
      BuildContext context, List<File> files) async {
    try {
      final fileUploadService = getIt<FileUploadService>();

      // Mostrar indicador de progresso
      _showProgressDialog(context, 'Enviando arquivos...');

      final fileUrls =
          await fileUploadService.uploadMultipleFiles(files, consultationId);

      // Fechar diálogo de progresso
      // ignore: use_build_context_synchronously
      context.pop();

      if (fileUrls.isNotEmpty) {
        for (final url in fileUrls) {
          onFileSelected(url);
        }
        _showSuccessSnackBar(
            // ignore: use_build_context_synchronously
            context,
            '${fileUrls.length} arquivos enviados com sucesso!');
      } else {
        // ignore: use_build_context_synchronously
        _showErrorSnackBar(context, 'Erro ao enviar arquivos');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      context.pop(); // Fechar diálogo de progresso
      // ignore: use_build_context_synchronously
      _showErrorSnackBar(context, 'Erro ao enviar arquivos: $e');
    }
  }

  void _showProgressDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ToastUtils.showSuccessToast(message);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ToastUtils.showErrorToast(message);
  }
}
