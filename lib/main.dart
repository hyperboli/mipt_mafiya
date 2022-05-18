import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'package:mafiya/pages/initial_parameters.dart';
import 'package:mafiya/pages/game_page.dart';
import 'package:mafiya/const.dart';

void main() {
  runApp(MyApp());
}

//маршрутизация
Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments;
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => InitialParameters());

    case '/server':
      if(arguments is GameParameters) {
        return MaterialPageRoute(
            builder: (_) => GamePage(args: arguments));
      }
      else{
        return MaterialPageRoute(builder: (_) => InitialParameters());
      }

  //Пока оставил как пример передачи аргументов
    //case '/server_start':
    //  if(arguments is ServerStartArguments) {
    //    return MaterialPageRoute(builder: (_) => ServerStart(args: arguments));
    //  }
    //  else{
    //    final arg1 = ServerStartArguments("LOL1", "LOL2");
    //    return MaterialPageRoute(builder: (_) => ServerStart(args: arg1));
    //  }
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

class MyApp extends StatelessWidget {
  @override
  //Изначально запускает стартовое окно
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRoute,
      initialRoute: '/',
    );
  }
}

