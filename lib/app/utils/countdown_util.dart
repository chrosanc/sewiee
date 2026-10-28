Stream<String> countdownStream(DateTime target) async* {
  while (true) {
    final diff = target.difference(DateTime.now());

    if (diff.isNegative) {
      yield "Expired";
      break;
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    yield "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";

    await Future.delayed(const Duration(seconds: 1));
  }
}