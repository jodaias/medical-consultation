import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';

@injectable
class FileUploadService {
  final ApiService _apiService;
  final StorageService _storageService;
  final ImagePicker _imagePicker = ImagePicker();

  FileUploadService(this._apiService, this._storageService);

  // Tipos de arquivo suportados
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> supportedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt'
  ];
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Selecionar imagem da galeria
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        if (await _validateFile(file)) {
          return file;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
      return null;
    }
  }

  // Capturar imagem da câmera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        if (await _validateFile(file)) {
          return file;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao capturar imagem: $e');
      return null;
    }
  }

  // Selecionar documento
  Future<File?> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedDocumentTypes,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        if (await _validateFile(file)) {
          return file;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao selecionar documento: $e');
      return null;
    }
  }

  // Selecionar múltiplos arquivos
  Future<List<File>> pickMultipleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<File> validFiles = [];
        for (var file in result.files) {
          if (file.path != null) {
            final fileObj = File(file.path!);
            if (await _validateFile(fileObj)) {
              validFiles.add(fileObj);
            }
          }
        }
        return validFiles;
      }
      return [];
    } catch (e) {
      print('Erro ao selecionar múltiplos arquivos: $e');
      return [];
    }
  }

  // Validar arquivo
  Future<bool> _validateFile(File file) async {
    try {
      // Verificar se o arquivo existe
      if (!await file.exists()) {
        print('Arquivo não existe');
        return false;
      }

      // Verificar tamanho do arquivo
      final fileSize = await file.length();
      if (fileSize > maxFileSize) {
        print('Arquivo muito grande: $fileSize bytes');
        return false;
      }

      // Verificar extensão
      final extension = file.path.split('.').last.toLowerCase();
      final supportedTypes = [
        ...supportedImageTypes,
        ...supportedDocumentTypes
      ];
      if (!supportedTypes.contains(extension)) {
        print('Tipo de arquivo não suportado: $extension');
        return false;
      }

      return true;
    } catch (e) {
      print('Erro ao validar arquivo: $e');
      return false;
    }
  }

  // Upload de arquivo para o servidor
  Future<String?> uploadFile(File file, String consultationId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      // Preparar dados do formulário
      final formData = {
        'consultationId': consultationId,
        'file': await file.readAsBytes(),
        'fileName': file.path.split('/').last,
        'fileType': _getFileType(file.path),
      };

      final response = await _apiService.post(
        '/upload/file',
        data: formData,
      );

      return response.data['fileUrl'];
    } catch (e) {
      print('Erro no upload: $e');
      return null;
    }
  }

  // Upload de múltiplos arquivos
  Future<List<String>> uploadMultipleFiles(
      List<File> files, String consultationId) async {
    List<String> uploadedUrls = [];

    for (var file in files) {
      final url = await uploadFile(file, consultationId);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    return uploadedUrls;
  }

  // Obter tipo de arquivo
  String _getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    if (supportedImageTypes.contains(extension)) {
      return 'image';
    } else if (supportedDocumentTypes.contains(extension)) {
      return 'document';
    } else {
      return 'other';
    }
  }

  // Comprimir imagem
  Future<File?> compressImage(File imageFile) async {
    try {
      // Implementar compressão de imagem se necessário
      // Por enquanto, retorna o arquivo original
      return imageFile;
    } catch (e) {
      print('Erro ao comprimir imagem: $e');
      return null;
    }
  }

  // Gerar thumbnail
  Future<File?> generateThumbnail(File imageFile) async {
    try {
      // Implementar geração de thumbnail se necessário
      // Por enquanto, retorna o arquivo original
      return imageFile;
    } catch (e) {
      print('Erro ao gerar thumbnail: $e');
      return null;
    }
  }

  // Verificar espaço disponível
  Future<bool> checkStorageSpace() async {
    try {
      // Implementar verificação de espaço disponível
      // Por enquanto, retorna true
      return true;
    } catch (e) {
      print('Erro ao verificar espaço: $e');
      return false;
    }
  }

  // Limpar cache de arquivos
  Future<void> clearCache() async {
    try {
      // Implementar limpeza de cache se necessário
      print('Cache limpo');
    } catch (e) {
      print('Erro ao limpar cache: $e');
    }
  }

  // Obter informações do arquivo
  Future<Map<String, dynamic>> getFileInfo(File file) async {
    try {
      final stat = await file.stat();
      final extension = file.path.split('.').last.toLowerCase();

      return {
        'name': file.path.split('/').last,
        'size': stat.size,
        'extension': extension,
        'type': _getFileType(file.path),
        'lastModified': stat.modified,
      };
    } catch (e) {
      print('Erro ao obter informações do arquivo: $e');
      return {};
    }
  }
}
