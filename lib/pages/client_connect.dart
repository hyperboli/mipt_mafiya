import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

//подключение клиента

class ClientConnect extends StatefulWidget {
  const ClientConnect({Key? key}): super(key: key);

  @override
  State<ClientConnect> createState() => _ClientConnect();
}

class _ClientConnect extends State<ClientConnect> {

  List<Device> devices = []; //скисок всех девайсов

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Мафиозник'),
        ),
        //Column - отображает виджеты в столбике
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text('Подключение клиента'),

              //кнопки навигации внизу
              Container(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    //кнопка назад
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 80,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                        child: Text(
                          'Назад',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    //кнопка далее
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 80,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                        child: Text(
                          'Далее',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )

            ]
          )
        )
    );
  }
}