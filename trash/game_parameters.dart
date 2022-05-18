import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:mafiya/const.dart';

//на сервере задаются параметры игры

class GameParameters extends StatefulWidget {
  const GameParameters({Key? key}): super(key: key);

  @override
  State<GameParameters> createState() => _GameParameters();
}

class _GameParameters extends State<GameParameters> {

  bool _doctorExists = false;

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

              Text(
                'Параметры игры',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),

              Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(labelText: "число мафий"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              Container(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(labelText: "число горожан"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              Container(
                width: 300,
                child: CheckboxListTile(
                    title: Text('наличие доктора'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _doctorExists,
                    onChanged: (value){
                      setState(() {
                        _doctorExists = !_doctorExists;
                      });
                    }
                ),
              ),

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
                          Navigator.pushNamedAndRemoveUntil(context, '/server_start', (route) => true, arguments: ServerStartArguments("PICK1", "PICK1"));
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
            ],
          ),
        )
    );
  }
}