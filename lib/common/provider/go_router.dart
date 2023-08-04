import 'package:flutter_lv2/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth_provider = ref.read(authProvider);
  // watch : 값 변경될떄마다 다시 빌드
  // read : 한번만 읽고 값이 변경되도 다시 빌드 안함 -> 항상 똑같은 인스턴스 반환해야해서 read

  return GoRouter(
    routes: auth_provider.routes,
    initialLocation: '/splash',
    refreshListenable: auth_provider,
    redirect: auth_provider.redirectLogic,
  );
});
