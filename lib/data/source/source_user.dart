import 'package:money_record/library/library.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    String url = '${Api.user}/login.php';
    Map? responseBody =
        await AppRequest.post(url, {'email': email, 'password': password});

    if (responseBody == null) return false;
    if (responseBody['success']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
    }

    return responseBody['success'];
  }

  static Future<bool> register(
      BuildContext ctx, String name, String email, String password) async {
    String url = '${Api.user}/register.php';
    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String()
    });

    if (responseBody == null) return false;
    if (responseBody['success']) {
      DInfo.dialogSuccess(ctx, 'Berhasil Register');
      DInfo.closeDialog(ctx);
    } else {
      if (responseBody['message'] == 'email') {
        DInfo.dialogError(ctx, 'Email sudah terdaftar');
      } else {
        DInfo.dialogError(ctx, 'Gagal Register');
      }
      DInfo.closeDialog(ctx);
    }

    return responseBody['success'];
  }
}
