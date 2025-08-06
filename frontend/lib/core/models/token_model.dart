import 'package:hive/hive.dart';
import 'package:medical_consultation_app/core/cache/cache_adapters_id.dart';

part 'token_model.g.dart';

@HiveType(typeId: CacheAdaptersId.tokenModelAdapter)
class TokenModel {
  @HiveField(0)
  String? accessToken;
  @HiveField(1)
  DateTime? dateExpirationToken;
  @HiveField(2)
  String? idToken;
  @HiveField(3)
  String? refreshToken;

  TokenModel({
    required this.accessToken,
    required this.dateExpirationToken,
    required this.idToken,
    required this.refreshToken,
  });
}
