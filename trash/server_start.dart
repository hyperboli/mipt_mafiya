import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:mafiya/const.dart';

//сервер подключает клиентов

class ServerStart extends StatefulWidget {
  late String text;
  late ServerStartArguments args;


  //const ServerStart({Key? key}): super(key: key);
  ServerStart({Key? key, required this.args}) : super(key: key);

  //Обозначаем - что это сервер (в примере по nearbyService клиент и сервер были в одном файле и различались по этой переменной)
  final DeviceType deviceType = DeviceType.browser;

  @override
  State<ServerStart> createState() => _ServerStart(args);
}

enum DeviceType { advertiser, browser }

class _ServerStart extends State<ServerStart> {
  late ServerStartArguments args;
  late String text;

  String messageFromClient = "From Client Message";


  _ServerStart(ServerStartArguments argsp){
    args = argsp;
    text = args.message;
  }

  //Вырезка из ptp
  List<Device> devices = []; //скисок вроде всех девайсов
  List<Device> connectedDevices = []; //список подключённых девайсов
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  //хз зачем
  bool isInit = false;

  //что-то для обновления виджетов
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Мафия'),
        ),
        body: Column(
            children: [
              Text(text),
              Text(messageFromClient),
              ListView.builder(
                  shrinkWrap: true,
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
                              //GestureDetector - обработка нажатия на любой виджет
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
                          Navigator.pushNamedAndRemoveUntil(context, '/server_start', (route) => true);
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

            ])
    );
  }

  //виджет окна диалога для сообщения
  _onTabItemListener(Device device) {
    if (device.state == SessionState.connected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final myController = TextEditingController();
            //диалог сообщения
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
                    //ОТПРАВКА СООБЩЕНИЯ !!!
                    nearbyService.sendMessage(
                        device.deviceId, myController.text.toString());
                    myController.text = '';
                  },
                )
              ],
            );
          });
    }
  }

  //Подключение девайса
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

  //получить к-во девайсов
  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  //получаем полпись в карточке об подключении
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

  //получаем подпись к кнопочке об подключении
  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }

  //получаем цвет, согласно подключению
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

  //получаем цвет кнопочки согласно подключеию
  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  //Постоянное параллельное считывание (напримаер - приём данных)
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
            //Печатает в консоль список обнаруженных девайсов и их характеристики
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

    //постоянно принимает данные json !!!-----------------------------------------------
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          print("dataReceivedSubscription: ${(data)}");
          //final Map<String, dynamic> json_result = jsonDecode(data['message'].toString());
          print("&&**&&JFJFJFJ: ${data['message']}");
          showToast(jsonEncode(data),
              context: context,
              axis: Axis.horizontal,
              alignment: Alignment.center,
              position: StyledToastPosition.bottom);
        });
  }

}