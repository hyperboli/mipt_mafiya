import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'package:mafiya/const.dart';

//==========================================================================
//----Тут выбираются параметры игры, игрок выбирает сервер он или клиент----
//==========================================================================

class InitialParameters extends StatefulWidget {
  const InitialParameters({Key? key}): super(key: key);

  @override
  State<InitialParameters> createState() => _InitialParameters();
}

class _InitialParameters extends State<InitialParameters> {

  bool _doctorExists = false; //параметр наличия доктора

  var _controllerNumberOfMafias = TextEditingController();
  var _controllerNumberOfPeaceful = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Мафия'),
        ),
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

              //Ввод числа мафий
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerNumberOfMafias,
                  decoration: InputDecoration(labelText: "число мафий"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              //Ввод числа мирных
              Container(
                width: 300,
                child: TextField(
                  controller: _controllerNumberOfPeaceful,
                  decoration: InputDecoration(labelText: "число мирных"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              //Галочка наличия доктора
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

              Text(
                'Роль устройства:',
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
                    //==============================ОТПРАВКА ПАРАМЕТРОВ ИГРЫ НА СЕРВЕР ===================================
                    Navigator.pushNamedAndRemoveUntil(context, '/server', (route) => false, arguments: GameParameters(
                      DeviceType.browser,
                      int.parse(_controllerNumberOfMafias.text),
                      int.parse(_controllerNumberOfPeaceful.text),
                      _doctorExists,
                    ));
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
                    Navigator.pushNamedAndRemoveUntil(context, '/server', (route) => false, arguments: GameParameters(
                      DeviceType.advertiser,
                      int.parse(_controllerNumberOfMafias.text),
                      int.parse(_controllerNumberOfPeaceful.text),
                      _doctorExists,
                    ));
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