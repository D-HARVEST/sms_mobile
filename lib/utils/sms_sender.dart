import 'package:telephony/telephony.dart';

class SmsSender {
  static final Telephony telephony = Telephony.instance;

  static Future<void> sendSMS(String number, String message) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      telephony.sendSms(to: number, message: message);
      print("SMS envoyé à $number: $message");
    } else {
      print("Permission SMS refusée !");
    }
  }
}
