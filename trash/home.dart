import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

//выбор сервер-клиент

class Home extends StatelessWidget {

  //String debugJson = '{"name": "John Smith","email": "john@example.com"}';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Мафия'),
      ),
      //Column - отображает виджеты в столбике
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('We sent the verification link to ${debugJsonMap['email']}.'),
          Text(
            'Режим устройства:',
            style: TextStyle(
              fontSize: 22,
            ),
          ),

          //Кнопка сервер
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 180,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/game_parameters', (route) => false);
              },
              child: Text(
                'Сервер',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),

          //Кнопка клиент
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 180,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/client_connect', (route) => true);
                //скрываем меню
                //Navigator.pop(context);
                //Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text(
                'Клиент',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      )
    );
  }
}