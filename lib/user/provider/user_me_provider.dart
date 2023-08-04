import 'package:flutter_lv2/common/const/data.dart';
import 'package:flutter_lv2/common/secure_storage/secure_storage.dart';
import 'package:flutter_lv2/user/model/user_model.dart';
import 'package:flutter_lv2/user/repository/auth_repository.dart';
import 'package:flutter_lv2/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userMeRepository = ref.watch(userMeRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return UserMeStateNotifier(
      authRepository: authRepository,
      userMeRepository: userMeRepository,
      storage: storage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository userMeRepository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.userMeRepository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe(); //내 정보 가져오기
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    try {
      final resp = await userMeRepository.getMe();
      state = resp;
    } catch (e, stack) {
      print(e);
      print(stack);
      state = null;
    }
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      //서버에서 내 정보를 잘 가져오면 유효한 토큰.
      final userResp = await userMeRepository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      //TODO::상세 에러 처리
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await storage.deleteAll();

    // await Future.wait(
    //   [
    //     storage.delete(key: REFRESH_TOKEN_KEY),
    //     storage.delete(key: ACCESS_TOKEN_KEY),
    //   ],
    // );
  }
}
