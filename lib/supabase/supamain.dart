import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qezsypwsnhijyicgrkoi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFlenN5cHdzbmhpanlpY2dya29pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkwOTk0ODAsImV4cCI6MjAyNDY3NTQ4MH0.u8NFgTpsldxghhoDlRVhGpK4b3n5kcAIfo56foJ2ZTo',
  );
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    defaultTransition: Transition.fade,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var displayName = ''.obs;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello supabase'),
      ),
      body: Center(
        child: Obx(() => Text(displayName.value)),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          var list = await supabase.from('profiles').select('*');
          var jsonEncode2 = jsonEncode(list);
          displayName.value = jsonEncode2;

          //注册
          // final AuthResponse res = await supabase.auth.signUp(
          //   email: 'etcxyf@gmail.com',
          //   password: 'example-password',
          //   data: {'username': 'myusername'},
          // );


        },
        child: const Text('Sign in with Google'),
      ),
    );
  }
}
