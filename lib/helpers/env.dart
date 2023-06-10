import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static int get dbVersion {
    return int.parse(dotenv.env['DB_VERSION']!);
  }
}
