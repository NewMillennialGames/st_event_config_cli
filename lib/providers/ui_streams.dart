part of EvCfgProviders;

final questDispatcherProvider = Provider<StreamController<Question>>(
  // this is used to send questions to the UI
  (ref) => StreamController<Question>(),
);

final questionStreamProvier = StreamProvider<Question>((ref) async* {
  // the UI listends to this stream and renders
  // new questions when they are received
  final sc = ref.watch(questDispatcherProvider);

  ref.onDispose(() {
    sc.close();
  });
  await for (final Question quest in sc.stream) {
    yield quest;
  }
});

final answerDispatcherProvider = Provider<StreamController<String>>(
  // this is used to send answers to the DialogRunner
  (ref) => StreamController<String>(),
);

final answerStreamProvier = StreamProvider<String>((ref) async* {
  // the DialogRunner listends to this stream and stores the
  // answers on the respective question
  // and then sends the UI a new question on the stream above
  final sc = ref.watch(answerDispatcherProvider);

  ref.onDispose(() {
    sc.close();
  });
  await for (final String answer in sc.stream) {
    yield answer;
  }
});

// void _test() {
//   var pc = ProviderContainer();
//   var xx = pc.read(answerStreamProvier.stream);

//   print(xx.isBroadcast);

//   var yy = xx.asBroadcastStream();

//   print(yy.isBroadcast);
// }
