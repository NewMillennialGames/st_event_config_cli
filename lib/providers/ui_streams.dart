part of EvCfgProviders;

final questDispatcherProvider = Provider<StreamController<Question>>(
  (ref) => StreamController<Question>(),
);

final questionStreamProvier = StreamProvider<Question>((ref) async* {
  //
  final sc = ref.watch(questDispatcherProvider);

  ref.onDispose(() {
    sc.close();
  });
  await for (final Question quest in sc.stream) {
    yield quest;
  }
});

final answerDispatcherProvider = Provider<StreamController<String>>(
  (ref) => StreamController<String>(),
);

final answerStreamProvier = StreamProvider<String>((ref) async* {
  //
  final sc = ref.watch(answerDispatcherProvider);

  ref.onDispose(() {
    sc.close();
  });
  await for (final String answer in sc.stream) {
    yield answer;
  }
});
