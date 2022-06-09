part of EvCfgProviders;

final questDispatcherProvider = Provider<StreamController<RegionTargetQuest>>(
  // this is used to send Quest2s to the UI
  (ref) => StreamController<RegionTargetQuest>(),
);

final Quest2StreamProvier = StreamProvider<RegionTargetQuest>((ref) async* {
  // the UI listends to this stream and renders
  // new Quest2s when they are received
  final sc = ref.watch(questDispatcherProvider);

  ref.onDispose(() {
    sc.close();
  });
  await for (final RegionTargetQuest quest in sc.stream) {
    yield quest;
  }
});

final answerDispatcherProvider = Provider<StreamController<String>>(
  // this is used to send answers to the DialogRunner
  (ref) => StreamController<String>(),
);

final answerStreamProvier = StreamProvider<String>((ref) async* {
  // the DialogRunner listends to this stream and stores the
  // answers on the respective Quest2
  // and then sends the UI a new Quest2 on the stream above
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
