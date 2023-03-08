import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_actual/model/user_model.dart';
import 'package:go_router_actual/screen/1_screen.dart';
import 'package:go_router_actual/screen/2_screen.dart';
import 'package:go_router_actual/screen/3_screen.dart';
import 'package:go_router_actual/screen/error_screen.dart';
import 'package:go_router_actual/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router_actual/screen/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStateProvider = AuthNotifier(ref: ref);

  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error.toString());
    },
    // redirect - 라우트 이동 시에 실행
    redirect: authStateProvider._redirectLogic,
    // refresh - authStateProvider 가 변경 할 때마다 실행
    refreshListenable: authStateProvider,
    routes: authStateProvider._routes,
  );
});

// ChangeNotifier
class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    ref.listen<UserModel?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners(); // state 변경
      }
    });
  }

  // Navi 이동 할 때마다 실행
  String? _redirectLogic(_, GoRouterState state) {
    // UserModel or Null
    final user = ref.read(userProvider);

    // 로그인을 하려는 상태
    final loggingIn = state.location == '/login';

    // 로그인 하지 않은 상태
    // 유저 정보가 없고
    // 로그인 하려는 중이 아니려면
    // 로그인 페이지로 이동한다.
    // null 이면 원래 가려던 페이지로 이동
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    // 유저정보가 있는데 로그인 페이지라면
    // 홈으로 이동
    if (loggingIn) {
      return '/';
    }
    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'one',
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                  path: 'two',
                  builder: (_, state) => TwoScreen(),
                  routes: [
                    GoRoute(
                      path: 'three',
                      // name: 'three',
                      name: ThreeScreen.routerName,
                      builder: (_, state) => ThreeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(path: '/login', builder: (_, sate) => LoginScreen()),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

// 로그인한 상태면 UserModel 인스턴스 상태로
// 로그아웃 상태면 null ,
class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  login({required String name}) {
    state = UserModel(name: name);
  }

  logout() {
    state = null;
  }
}
