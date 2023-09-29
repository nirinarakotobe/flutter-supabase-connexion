import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_key.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Buttons()),
    );
  }
}

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  String dynamicResult = 'Result';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => _testConnection(), child: const Text('Test connexion')),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => _showUserProfile(),
              child: const Text('Show user profile')),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => _listCategories(), child: const Text('List categories')),
          const SizedBox(height: 20),
          Text(dynamicResult, style: const TextStyle(fontSize: 20))
        ],
      ),
    );
  }

  Future<void> _showUserProfile() async {
    final supabase = Supabase.instance.client;
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: 'nirina@tutanota.io',
      password: '123456',
    );
    final Session? session = res.session;
    final User? user = res.user;
    final currentId = supabase.auth.currentUser!.id;

    //may be no result because the user doen't have an admin profile
    final profile = await supabase
        .from('admin_profile')
        .select('*')
        .eq('admin_id', currentId)
        .single();

    setState(() {
      dynamicResult = user!.email.toString();
    });
  }

  Future<void> _listCategories() async {
    final supabase = Supabase.instance.client;
    final res = await supabase.from('categories').select('*');
    setState(() {
      dynamicResult = res.toString();
    });
  }

  Future<void> _createUser() async {
    final supabase = Supabase.instance.client;
    final AuthResponse res = await supabase.auth.signUp(
      email: 'nirina@tutanota.io',
      password: '123456',
    );
    final Session? session = res.session;
    final User? user = res.user;
    setState(() {
      dynamicResult = session.toString() + ' \n\n ' + user.toString();
    });
  }

  Future<void> _testConnection() async {
    final supabase = Supabase.instance.client;
    setState(() {
      dynamicResult = supabase.toString();
    });
  }
}
