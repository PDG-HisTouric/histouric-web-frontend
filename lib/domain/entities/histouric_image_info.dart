class HistouricImageInfo {
  final String id;
  final double width;
  final double height;
  final bool isFromDrive;

  HistouricImageInfo({
    required this.id,
    required this.width,
    required this.height,
    this.isFromDrive = true,
  });

  factory HistouricImageInfo.fromList(List<dynamic> list) {
    return HistouricImageInfo(
      id: list[0].toString(),
      width: double.parse(list[1].toString()),
      height: double.parse(list[2].toString()),
    );
  }
}
