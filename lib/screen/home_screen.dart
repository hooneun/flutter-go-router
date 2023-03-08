import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_actual/layout/default_layout.dart';
import 'package:go_router_actual/provider/auth_provider.dart';
import 'package:go_router_actual/screen/3_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => context.go('/one'),
            child: Text('Screen One (GO)'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/one/two'),
            child: Text('Screen Two (GO)'),
          ),
          ElevatedButton(
            // onPressed: () => context.go('/one/two/three'),
            onPressed: () => context.goNamed(ThreeScreen.routerName),
            child: Text('Screen Three (GO)'),
          ),
          ElevatedButton(
            // onPressed: () => context.go('/one/two/three'),
            onPressed: () => context.go('/error'),
            child: Text('Error Screen (GO)'),
          ),
          ElevatedButton(
            // onPressed: () => context.go('/one/two/three'),
            onPressed: () => context.go('/login'),
            child: Text('Login Screen (GO)'),
          ),
          ElevatedButton(
            // onPressed: () => context.go('/one/two/three'),
            onPressed: () {
              ref.read(userProvider.notifier).logout();
            },
            child: Text('Logout Screen (GO)'),
          ),
        ],
      ),
    );
  }
}
