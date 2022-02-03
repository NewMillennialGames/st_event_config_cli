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
    super.initState();
    //
    _startServingQuestions();
  }

  void _startServingQuestions() {
    // DIEGO  this starts the question stream
    // need to delay it??
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
        title: Text('ST Event Configurator'),
        centerTitle: true,
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
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return QuestionUi(
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

class QuestionUi extends StatelessWidget {
  /*  show the question here
    this widget will rebuild every time the question changes
    I've added a button to send answer back to the dialog runner

  this is where Deigo should start working
  */
  final StreamController<String> answerDispatcher;
  final Question quest;
  //
  const QuestionUi(
    this.answerDispatcher,
    this.quest, {
    Key? key,
  }) : super(key: key);

  Widget listAnswerChoices(dynamic size) {
    //
    List<String> listAnswerChoice = [];
    int temp = 0;

    quest.answerChoicesList == null
        ? temp = 0
        : temp = quest.answerChoicesList!.length;
    if (temp > 0) {
      for (var i = 0; i < temp; i++) {
        //

        listAnswerChoice.add('$i)${quest.answerChoicesList![i]}');
      }

      return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: size.height * 0.04,
        ),
        itemCount: temp,
        itemBuilder: (context, index) {
          //

          return Center(child: Text(listAnswerChoice[index]));
        },
      );
    } else {
      //

      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    //

    final TextEditingController questController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.blueAccent.shade100),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.15,
            width: size.width * 0.9,
            child: Center(
              child: Text(
                  '#${quest.questionId == 12 ? '' : quest.questionId} -- ${quest.questStr} ${quest.questionId < 3 ? "wont generate any new questions" : ''}'),
            ),
          ),
          SizedBox(
            width: size.width * 0.85,
            child: Divider(),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SizedBox(
            height: size.height * 0.4,
            width: size.width * 0.5,
            child: listAnswerChoices(size),
          ),
          SizedBox(
            width: size.width * 0.85,
            child: Divider(),
          ),
          SizedBox(
            width: size.width * 0.5,
            height: size.height * 0.13,
            child: Center(
              child: TextFormField(
                  controller: questController,
                  decoration: InputDecoration(
                    hintText: 'Enter',
                  )),
            ),
          ),
          SizedBox(
            height: size.height * 0.15,
            child: Center(
              child: Container(
                child: ElevatedButton(
                  child: Text(
                    'Submit answer as string',
                  ),
                  onPressed: () {
                    if (questController.text.isEmpty) {
                      //
                      final SnackBar snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('the field is empty'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (quest.questionId > 2 &&
                            questController.text
                                .contains(new RegExp(r"[a-z]")) ||
                        quest.questionId > 2 &&
                            int.parse(questController.text) >
                                quest.answerChoicesList!.length - 1) {
                      //
                      final SnackBar snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('value out of range'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      //
                      answerDispatcher.add(questController.text);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
