import 'package:shared_preferences/shared_preferences.dart';

class Sessions {
  Future<String?> LoginSession() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    String? value = session.getString('login');
    if (value != null) {
      return value;
    } else {
      return null;
    }
  }
}
