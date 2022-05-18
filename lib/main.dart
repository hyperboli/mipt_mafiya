import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:mafiya/pages/home.dart';
import 'package:mafiya/pages/game_parameters.dart';
import 'package:mafiya/pages/mafiya_attack.dart';
import 'package:mafiya/pages/citizen_voting.dart';
import 'package:mafiya/pages/client_connect.dart';
import 'package:mafiya/pages/server_start.dart';
import 'package:mafiya/const.dart';

void main() {
  runApp(MyApp());
}

//маршрутизация
Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments;
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => Home());
    case '/game_parameters':
      return MaterialPageRoute(builder: (_) => GameParameters());
    case '/mafiya_attack':
      return MaterialPageRoute(builder: (_) => MafiyaAttack());
    case '/citizen_voting':
      return MaterialPageRoute(builder: (_) => CitizenVoting());
    case '/client_connect':
      return MaterialPageRoute(builder: (_) => ClientConnect());
    case '/server_start':
      if(arguments is ServerStartArguments) {
        return MaterialPageRoute(builder: (_) => ServerStart(args: arguments));
      }
      else{
        final arg1 = ServerStartArguments("LOL1", "LOL2");
        return MaterialPageRoute(builder: (_) => ServerStart(args: arg1));
      }
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

