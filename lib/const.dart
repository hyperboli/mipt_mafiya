
//Формат всех правил игры (пока простой для примера)
class GameParameters{
  final int numberOfMafias; //к-во мафий
  final int numberOfPeaceful; //к-во мирных
  final bool doctorExists; //галочка существования дктора
  final DeviceType deviceType; //сервер/клиент

  GameParameters(this.deviceType, this.numberOfMafias, this.numberOfPeaceful, this.doctorExists);
}

enum DeviceType { advertiser, browser }

//далее всё ненужное

//для примера))
class ServerStartArguments {
  final String title;
  final String message;

  ServerStartArguments(this.title, this.message);
}

//класс передачи параметров (пока примитивный - далее переделаем по Глебовому)
class PassingParameters{
  final int numberOfMafias;
  final int numberOfPeaceful;
  final bool doctorExists;

  PassingParameters(this.numberOfMafias, this.numberOfPeaceful, this.doctorExists);
}
