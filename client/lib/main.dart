import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_view_model.dart';
import 'package:client/features/home/view/upload_song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      1024 * 1024 * 128; // 128MB
  final container = ProviderContainer();
  dynamic userModel;
  try {
    await container.read(authViewModelProvider.notifier).getData();
    //print("KAYA" + userModel);
  } catch (e) {
    print("Error getting user data: $e");
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(userModel: userModel),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final dynamic userModel;
  const MyApp({super.key, required this.userModel});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const UploadSongPage(),
    );
  }
}
