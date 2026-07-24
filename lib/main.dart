import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'app.dart';
import 'services/supabase_service.dart';
import 'services/notification_service.dart';
import 'data/datasources/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (for Auth, Analytics, Messaging only)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase (for Database + Storage)
  await SupabaseService.initialize();

  // Initialize Hive
  await Hive.initFlutter();
  await HiveService.init();

  // Initialize Notifications
  await NotificationService.init();

  runApp(const MarketplaceApp());
}
