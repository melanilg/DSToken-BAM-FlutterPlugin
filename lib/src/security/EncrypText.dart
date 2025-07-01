import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'EncryptionUtil.dart';

String encryptText(String plainText) {
  final parser = RSAKeyParser();
  final publicKey = parser.parse(EncryptionUtil.PUBLIC_KEY) as RSAPublicKey;

  final encrypter = Encrypter(RSA(
    publicKey: publicKey,
    encoding: RSAEncoding.PKCS1,
  ));

  final encrypted = encrypter.encrypt(plainText);
  return encrypted.base64;
}
