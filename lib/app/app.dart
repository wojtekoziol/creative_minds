import 'package:creative_minds/data/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(authControllerProvider);
                if (user == null) return const Text('No data');
                return Text(user.toString());
              },
            ),
          ),
        ),
      ),
    );
  }
}
