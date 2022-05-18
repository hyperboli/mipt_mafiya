import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

//голосование горожан

class CitizenVoting extends StatefulWidget {
  const CitizenVoting({Key? key}): super(key: key);

  @override
  State<CitizenVoting> createState() => _CitizenVoting();
}

class _CitizenVoting extends State<CitizenVoting> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Мафия'),
        ),
        //Column - отображает виджеты в столбике
        body: Center(
          child: Text('Горожане голосуют!'),
        )
    );
  }
}