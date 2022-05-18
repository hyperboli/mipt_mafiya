import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

//атака мафии

class MafiyaAttack extends StatefulWidget {
  const MafiyaAttack({Key? key}): super(key: key);

  @override
  State<MafiyaAttack> createState() => _MafiyaAttack();
}

class _MafiyaAttack extends State<MafiyaAttack> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Мафиозник'),
        ),
        //Column - отображает виджеты в столбике
        body: Center(
          child: Text('Мафия атакует!'),
        )
    );
  }
}