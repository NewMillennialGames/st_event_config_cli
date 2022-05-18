import 'package:test/test.dart';
//
import 'package:st_ev_cfg/st_ev_cfg.dart';

/*
  
  I feel a bit nervous having something that pricy
  sitting alone outside ...
  I'll plan to come at exactly 10am to minimize any risk
  please send me your address & the EXACT location
*/

void main() {
  test(
    'creates Question w several prompts & verifies count + access',
    () {
      final qq = QTargetIntent.areaLevelRules(
        AppScreen.marketView,
        ScreenWidgetArea.tableview,
        VisualRuleType.groupCfg,
        responseAddsRuleDetailQuests: true,
      );

      List<QuestPromptPayload> prompts = [
        QuestPromptPayload(
          'how many Grouping positions would you like to configure?',
          ['0', '1', '2', '3'],
          VisRuleQuestType.dialogStruct,
          (String selCount) => int.tryParse(selCount) ?? 0,
        ),
        QuestPromptPayload(
          'how many Grouping positions would you like to configure?',
          ['0', '1', '2', '3'],
          VisRuleQuestType.dialogStruct,
          (String selCount) => int.tryParse(selCount) ?? 0,
        ),
      ];

      QuestBase twoPromptQuest = QuestBase.multiPrompt(qq, prompts);
      expect(twoPromptQuest.promptCount, 2);
      QuestPromptInstance? usrPrompt1 =
          twoPromptQuest.getNextUserPromptIfExists();
      QuestPromptInstance? usrPrompt2 =
          twoPromptQuest.getNextUserPromptIfExists();
      QuestPromptInstance? usrPrompt3 =
          twoPromptQuest.getNextUserPromptIfExists();
      expect(usrPrompt1, isNotNull);
      expect(usrPrompt2, isNotNull);
      expect(usrPrompt3, isNull);
    },
  );
}
