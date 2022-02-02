import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//
import 'input_models/all.dart';
import 'services/web_quest_presenter.dart';
import 'dialog/all.dart';
import 'providers/all.dart';

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
  late WebQuestionPresenter wqp;
  late DialogRunner dRunner;
  @override
  void initState() {
    StreamController<Question> questDispatcher = ref.read(
      questDispatcherProvider,
    );
    Stream<String> answerStream = ref.read(answerStreamProvier.stream);
    this.wqp = WebQuestionPresenter(questDispatcher, answerStream);
    this.dRunner = DialogRunner(wqp);
    _startServingQuestions();
    super.initState();
  }

  void _startServingQuestions() {
    // DIEGO  this starts the question stream
    // may need to delay it??
    // Future.delayed(
    //   Duration(milliseconds: 100),
    //   () {
    //     dRunner.serveNextQuestionToGui();
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
        title: Text('blah'),
      ),
      body: StreamBuilder<Question>(
        stream: ref.watch(questionStreamProvier.stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // no more questions
            // call logic to generate JSON file
            // and either exit or start over on a new event
            return Text('all done ... good work');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('waiting for first question');
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return QuestionUi(
                  ref.read(answerDispatcherProvider), snapshot.data!);
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

class QuestionUi extends StatelessWidget {
  /*  show the question here
    this widget will rebuild every time the question changes
    I've added a button to send answer back to the dialog runner

  this is where Deigo should start working
  */
  final StreamController<String> answerDispatcher;
  final Question quest;
  const QuestionUi(
    this.answerDispatcher,
    this.quest, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text(
          'Submit answer as string',
        ),
        onPressed: () {
          answerDispatcher.add('this is user answer to question');
        },
      ),
    );
  }
}
