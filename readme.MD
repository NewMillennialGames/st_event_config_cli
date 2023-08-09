### Overview

this is a "Configurator" app in which a user
can answer Questions to create rules that define
the per-event UI in Scoretrader

the final output of this dialog is a
JSON configuration payload that
describes how the App UI should behave
for a given specific ST Event

a parent project "st_ui_builder" interprets this JSON
and these created rules can radically customize the UI of 
the Scoretrader app, based on the current event
selected by the user

#### Glossary of terms

-- target -> an area or slot (of a screen) to which rules will be attached
-- 


#### Hard problems that must be solved for this to work well

Division between Questions that exist ONLY to structure an efficient dialog
and those that actually produce rule-output data (ui or behavioral config)
for a specific screen, screen-area, or area-slot regions of the app

Questions that receive SINGLE answer user-input
And those that are multi-part  (sort on this field, plus descending vs ascending)

Questions with a multi-prompt question (sort field #1, #2, #3)

Variable output data-types (enum, class-instance, string, etc) across all possible prompt answers

Answers that generate either:
 1. more new Questions
 2. cascading implicit answers to new or pending Questions

Casting answers to and from a JSON data structure

To solve the above, we need:
1. capture all user-responses as string
2. cast strings to some generic type
3. 

Once I know what rule I'm applying to a given (area or slot), then I have all the info
I need to generate those follow-up questions



#### Understanding organization of logic
1. understand a generic app UI hierarchy:
    screen
    screen-area (eg ListView;   filter bar with slots (eg search field and drop-menu)
    area-slot   (the specific field or drop menu in the area)
2.  recognize that UI-factory rules can be attached to either of b) area or c) slot
    example: row style config-rule might go with listView  and  selected-filter-field might go with the drop list
3.  run the CLI configurator & study the JSON output
4.  then run the demo client (to see the factory switch out the row-style dynamically based on different JSON payloads)

#### Building blocks of every Question
1. user-prompt(s)
2. answer-choices
3. specify output data-type (generic)
4. cast user-answer (string) into output data-type
5. targetting user-answer to some specific screen region
6. 


#### Structure and Design
Questions (and rules created from answers) are nested into a hierarchy as follows:

    Event Config -- (basic ?? about event setup;  Event level)
    App Screen (any UI that domniates the viewport )  App Screen level
        Section/Area (container widget in an App Screen)
            Area-Slot -- specific sub-widget inside the area (ie row inside tableview)
                Rule applying to an Area or Area-Slot
                    Visual Rules
                    Behavioral Rules

#### CLI Usage
    open terminal
    "cd" into this project folder
    run these cmds:
        dart pub get
        dart evCfg.dart

### General flow of app
App Feeds Questions to user
User response to each Question, has one of 4 possible effects
 * Capture some value(s) and store as part of config
 * Produce more future (immanent) Questions
 <!-- * Eliminate some future Questions -->
 * Create a "rule" for some part of the Scoretrader app

Rules live (and apply to) one of two "levels" in the UI hierarchy
 1 Screen-Area
 2 Area-Slot

Examples of a Screen-Area:
    1. List or Table View  (repeating rows)
    2. Filter-bar  (with 2-3 different "slots")

Examples of a Area-Slot:
    1. Menu #1 in Filter-Bar
    2. Menu #2 in Filter-Bar
    3. Title Widget inside of Header or Footer area


The Logic for some Questions can be described
by current/prior (response/answer) state

Rules can either be:
 * visual (eg Table-Row-Style or hidden element)
or (Future) they can be 
 * behavioral (eg navigate or skip-some-step)

###### Dev instructions

This whole system is governed by Enum definitions
and the relationship between these Enums

if you wish to add features, you must understand the Enum hierarchy

Control what is configurable by editing the lists returned in:
    lib/app_entity_enums/ui_screen.dart

also, it's important to understand that some answers
cause new Questions to be created
there are currently TWO code-pathways to creating new Questions
1)  NewQuestionCollector()
2)  QuestMatcher()

Both are working fine but I may want to clean this up in the future

to rebuild Freezed models in CLI:  
    cd projectRoot (above lib/)
    dart run build_runner build --delete-conflicting-outputs


to rebuild JSON models:  
    cd projRoot/st_ui_builder (above uib lib/)
    dart run build_runner build --delete-conflicting-outputs

###### Examples:
Questions:
enter event name

do you want to customize MarketView -- y or n
on MarketView, do you wish to customize:


####  Cascade logic

CLI serves up 5 types of question:

 1. event level config & behavior -- manually pre-defined in config/questions.dart
 2. targeting questions -- to define area/slot of the app  (defined in st_response_matchers)
 3. rule-selection questions -- to indicate what you want to DO with the target area/slot  (defined in st_response_matchers)
 4. rule-prep questions -- eg  how many sort-fields or filter-menu's do you want to specify / define
 5. rule-detail questions -- actual answers required to fully specify the rule (not all details ?'s require prep-questions)

Creating a Question requires specification for each category below:

1. intent  (what does this Question do in the overall scheme; includes cast to desired output type)
2. prompt & answer details  (what to display for configurator  (CLI or web) user)
3. target area (which screen-area (or scr-area-slot) of the app will answer apply to)
4. response handling  (how to cast or convert the user-answer)

##### How does response handling work?

Dialog manager has a QuestionPresenter
Presenter is responsible for rendering all prompts (QuestPromptInstance) under each QuestBase instance
Each QuestBase has 1->n QuestPromptInstance recs
Presenter show's each QuestPromptInstance and stores user response inside each QuestPromptInstance
Once all parts have been asked and answered, QuestBase is commplete
you can call the "cast()" function to get user answers converted into expected output type

#### Testing requirements

  Things we need to test in the:

  CLI

    add 1 question; verify it's next served
    verify question has correct # of prompts
  1) user answers produce new QuestBase & add to pending Queue
  2) answers produce IMPLICIT answers (create new Question and AUTO-SET answers)
  3) answers make some pending Questions IRRELEVANT  (take them out of pending queue)
  4) all relevant answers written to JSON file

  ui_builder_factory

  1) multiple different JSON config files can be loaded
  2) row-builder-function matches the app-screen for which it applies  (eg grouped or ungrouped)
  3) filtering logic also fits app-screen & config requirements
  4) sorting & grouping output matches json config

  to run tests with PRINT stmts active, run this:
    dart run test -r expanded

###### Specs for Web UI:

You MUST NOT break the CLI ... we need it to keep running
This means you should not change internal code or logic

OTHER THAN class:   WebQuestionPresenter

you can customize WebQuestionPresenter as much as you like

I've left nice hook-points for you to use my logic
without changing my code.

These Web hook-points live at:

lib/main.dart -- line 18
lib/services/web_Question_presenter.dart -- WebQuestionPresenter

and I've made the UI presenter injectible into the dialog runner

  final questPresenter = WebQuestionPresenter();
  final dialoger = DialogRunner(questPresenter);
  final succeeded = dialoger.loopUntilComplete();


  my suggestion is that you implement a STREAM
  inside of WebQuestionPresenter
  it can send Questions to your Flutter UI code
  and you can implement a REVERSE stream to send answers
  back from the Web UI

  please work on your own branch
  send PR to dewey to merge your code to "master" branch
  NEVER merge your code to the "prod" branch

  After several months, this package MAY become a 
  dependency of ScoreTrader


defer this until after 1st build:
  How do I feed Competition updates
  into the rows hidden inside GroupedTableDataMgr

  I could pass a stream in and allow it to update
  those rows ...

  or update them on the outside


#### For future
1. id love to convert this into a DSL  (target this area of app with this type of rule governed by these cfg-args)
2. 



#####  Test pattern

use permutations loop to create all possible
    1. targetting questions
    2. rule-select questions
    3. rule-prep questions

with PRE-CANNED answers (needed by the generators)

and for each above generated set
    use matchers to confirm that the
    proper derived questions were created
    by the default cascade dispatcher


regarding PRE-CANNED answers, we may need a top-level
structure that defines the rule for selecting
the answer for THIS TEST RUN
that will allow us to 