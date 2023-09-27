class HistouricImageInfo {
  final String url;
  final double width;
  final double height;

  HistouricImageInfo({
    required this.url,
    required this.width,
    required this.height,
  });

  factory HistouricImageInfo.fromList(List<dynamic> list) {
    return HistouricImageInfo(
      url: list[0].toString(),
      width: double.parse(list[1].toString()),
      height: double.parse(list[2].toString()),
    );
  }
}
