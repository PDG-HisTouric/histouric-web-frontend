class HistouricVideoInfo {
  final String url;
  final double width;
  final double height;

  HistouricVideoInfo({
    required this.url,
    required this.width,
    required this.height,
  });

  factory HistouricVideoInfo.fromListOfGooglePicker(List<dynamic> list) {
    return HistouricVideoInfo(
      url:
          'https://drive.google.com/uc?export=download&id=${list[0].toString()}',
      width: double.parse(list[1].toString()),
      height: double.parse(list[2].toString()),
    );
  }
}
