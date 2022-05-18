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

enum DeviceType { advertiser, browser }