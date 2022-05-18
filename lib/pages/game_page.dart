import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'package:mafiya/const.dart';

//============================================================================
//---Здесь идёт игра по начальным параметрам (сдесь же подключаются игроки)---
//============================================================================

class GamePage extends StatefulWidget {
  late GameParameters args; //Параметры игры описанные в const.dart

  //переменная, обозначающая - сервер или клиент
  //Пример: widget.deviceType == DeviceType.advertiser
  late final DeviceType deviceType;

  //Конструктор - требуем параметры игры
  GamePage({Key? key, required this.args}) : super(key: key){
    //сразу получаем информацию о роли устройства (сервер/клиент)
    deviceType = args.deviceType;
  }

  //Вызываем дочерний статический класс
  @override
  _GamePage createState() => _GamePage(args);
}

class _GamePage extends State<GamePage> {
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  late GameParameters args;

  bool isInit = false;

  //Конструктор - требуем аргументов (параметры игры)
  _GamePage(this.args);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //widget.deviceType.toString().substring(11).toUpperCase()
            title: Column(
              children: [
                //проверка для заголовка (много лишнего - осталось от примера)
                if (widget.deviceType.toString().substring(11).toUpperCase().compareTo('BROWSER')==0) Text("Мафия (сервер)")
                else Text("Мафия (клиент)")
            ]
            ),
            backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Text("Сетевое подключение"),
            if(widget.deviceType == DeviceType.browser)Text("Число мафий: ${args.numberOfMafias}"),
            if(widget.deviceType == DeviceType.browser)Text("Число горожан: ${args.numberOfMafias}"),
            if(widget.deviceType == DeviceType.browser && args.doctorExists)Text("Доктор есть")else if(widget.deviceType == DeviceType.browser)Text("Доктора нет"),
            ListView.builder(
              shrinkWrap: true, //для того чтоб список можно было поместить в другой виджет
              itemCount: getItemCount(),
              itemBuilder: (context, index) {
                final device = widget.deviceType == DeviceType.advertiser
                    ? connectedDevices[index]
                    : devices[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                onTap: () => _onTabItemListener(device),
                                child: Column(
                                  children: [
                                    Text(device.deviceName),
                                    Text(
                                      getStateName(device.state),
                                      style: TextStyle(
                                          color: getStateColor(device.state)),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              )),
                          // Request connect
                          GestureDetector(
                            onTap: () => _onButtonClicked(device),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              padding: EdgeInsets.all(8.0),
                              height: 35,
                              width: 100,
                              color: getButtonColor(device.state),
                              child: Center(
                                child: Text(
                                  getButtonStateName(device.state),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      )
                    ],
                  ),
                );
            }),
            //кнопки навигации внизу
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  //кнопка отмена
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      child: Text(
                        'отмена',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  //кнопка далее
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => true);
                      },
                      child: Text(
                        'далее',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )

          ])
    );
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  _onTabItemListener(Device device) {
    if (device.state == SessionState.connected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final myController = TextEditingController();
            return AlertDialog(
              title: Text("Send message"),
              content: TextField(controller: myController),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Send"),
                  onPressed: () {
                    nearbyService.sendMessage(
                        device.deviceId, myController.text);
                    myController.text = '';
                  },
                )
              ],
            );
          });
    }
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    nearbyService = NearbyService();
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: devInfo,
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            if (widget.deviceType == DeviceType.browser) {

              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
          devicesList.forEach((element) {
            print(
                " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");

            if (Platform.isAndroid) {
              if (element.state == SessionState.connected) {
                nearbyService.stopBrowsingForPeers();
              } else {
                nearbyService.startBrowsingForPeers();
              }
            }
          });

          setState(() {
            devices.clear();
            devices.addAll(devicesList);
            connectedDevices.clear();
            connectedDevices.addAll(devicesList
                .where((d) => d.state == SessionState.connected)
                .toList());
          });
        });

    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          print("dataReceivedSubscription: ${jsonEncode(data)}");
          showToast(jsonEncode(data),
              context: context,
              axis: Axis.horizontal,
              alignment: Alignment.center,
              position: StyledToastPosition.bottom);
        });
  }
}