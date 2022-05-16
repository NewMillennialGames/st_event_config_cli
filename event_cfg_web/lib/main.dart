import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';

/*


*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  runApp(
    ProviderScope(
      child: EvCfgApp(),
    ),
  );
}

class EvCfgApp extends ConsumerStatefulWidget {
  const EvCfgApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EvCfgAppState();
}

class _EvCfgAppState extends ConsumerState<EvCfgApp> {
  //
  late WebQuest2Presenter wqp;
  late DialogRunner dRunner;

  @override
  void initState() {
    StreamController<Quest1Prompt> questDispatcher = ref.read(
      questDispatcherProvider,
    );
    Stream<String> answerStream = ref.read(answerStreamProvier.stream);
    this.wqp = WebQuest2Presenter(questDispatcher, answerStream);
    this.dRunner = DialogRunner(wqp);
    super.initState();
    //
    _startServingQuest2s();
  }

  void _startServingQuest2s() {
    // DIEGO  this starts the Quest2 stream
    // need to delay it??
    // Future.delayed(
    //   Duration(milliseconds: 100),
    //   () {
    //     dRunner.serveNextQuest2ToGui();
    //   },
    // );

    dRunner.serveNextQuestionToGui();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConfigDialog(),
    );
  }
}

class ConfigDialog extends ConsumerWidget {
  const ConfigDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ST Event Configurator'),
        centerTitle: true,
      ),
      body: StreamBuilder<Quest1Prompt>(
        stream: ref.watch(Quest2StreamProvier.stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // no more Quest2s
            // call logic to generate JSON file
            // and either exit or start over on a new event
            return Text('all done ... good work');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('waiting for first Quest2');
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Quest2Ui(
                ref.read(answerDispatcherProvider),
                snapshot.data!,
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}

class Quest2Ui extends StatelessWidget {
  /*  show the Quest2 here
    this widget will rebuild every time the Quest2 changes
    I've added a button to send answer back to the dialog runner

  this is where Deigo should start working
  */
  final StreamController<String> answerDispatcher;
  final Quest1Prompt quest;
  //
  const Quest2Ui(
    this.answerDispatcher,
    this.quest, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Center(
            child: Text('Render Quest2 here!'),
          ),
          color: Colors.lightBlue[300],
          height: 500,
        ),
        Center(
          child: Container(
            child: ElevatedButton(
              child: Text(
                'Submit answer as string',
              ),
              onPressed: () {
                answerDispatcher.add('this is user answer to Quest2');
              },
            ),
          ),
        ),
      ],
    );
  }
}
