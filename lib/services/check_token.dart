import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

Future<void> checkToken(BuildContext context) async {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  if (token == null || isTokenExpired(token)) {
    await storage.delete(key: 'jwt_token');
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

bool isTokenExpired(String token) {
  if (token.isEmpty) return true;

  DateTime? expiryDate = Jwt.getExpiryDate(token);
  if (expiryDate == null) return true;

  return DateTime.now().isAfter(expiryDate);
}
