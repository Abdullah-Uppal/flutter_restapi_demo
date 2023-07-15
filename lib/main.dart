import 'package:flutter/material.dart';
import 'package:mad_assignment_3/pages/new_service.dart';
import 'package:mad_assignment_3/pages/service_update.dart';
import 'models/service.dart';
import 'pages/services_list.dart';
import 'controllers/services_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        var args = settings.arguments;
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) {
                return MyHomePage(title: 'Services');
              },
            );
          case '/new':
            return MaterialPageRoute(builder:(context) {
              return CreateService(refresh: args as VoidCallback,); 
            },);
          case '/update':
            var service = (args as List)[0] as Service;
            return MaterialPageRoute(
              builder: (context) {
                return UpdateService(refresh: (args as List)[1] as VoidCallback, service: service);
              },
            );
          default:
            return MaterialPageRoute(
              builder: (context) {
                return Center(
                  child: Text("No Such Page"),
                );
              },
            );
        }
      },
      home: MyHomePage(title: 'Services'),
    );
  }
}
