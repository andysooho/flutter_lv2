import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

final storage = FlutterSecureStorage();

//localhost:3000/users
const androidIp = '10.0.2.2:3000';
const iosIp = '127.0.0.1:3000';

final ip = Platform.isAndroid ? androidIp : iosIp;