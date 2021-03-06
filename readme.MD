### Overview

this is a "Configurator" app in which a user
can answer questions to create rules that define
the per-event UI in Scoretrader

the final output of this dialog is a
JSON configuration payload that
describes how the App UI should behave
for a given ST Event

these created rules are
intended to radically customize the UI of 
the Scoretrader app, based on the current event
selected by the user

#### Understanding organization of logic
1. understand a generic app UI hierarchy:
    screen
    screen-area (eg ListView;   filter bar with slots (eg search field and drop-menu)
    area-slot   (the specific field or drop menu in the area)
2.  recognize that UI-factory rules can be attached to either of b) area or c) slot
    example: row style config-rule might go with listView  and  selected-filter-field might go with the drop list
3.  run the CLI configurator & study the JSON output
4.  then run the demo client (to see the factory switch out the row-style dynamically based on different JSON payloads)

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
App Feeds question to user
User response to each question, has one of 4 possible effects
 * Capture some value(s) and store as part of config
 * Produce more future (immanent) questions
 <!-- * Eliminate some future questions -->
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


The Logic for some questions can be described
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
cause new questions to be created
there are currently TWO code-pathways to creating new questions
1)  NewQuestionCollector()
2)  QuestMatcher()

Both are working fine but I may want to clean this up in the future

to rebuild JSON models:  
    cd projectRoot (above lib/)
    flutter pub run build_runner build --delete-conflicting-outputs


###### Examples:
Questions:
enter event name

do you want to customize MarketView -- y or n
on MarketView, do you wish to customize:


###### Specs for Web UI:

You MUST NOT break the CLI ... we need it to keep running
This means you should not change internal code or logic

OTHER THAN class:   WebQuestionPresenter

you can customize WebQuestionPresenter as much as you like

I've left nice hook-points for you to use my logic
without changing my code.

These Web hook-points live at:

lib/main.dart -- line 18
lib/services/web_question_presenter.dart -- WebQuestionPresenter

and I've made the UI presenter injectible into the dialog runner

  final questPresenter = WebQuestionPresenter();
  final dialoger = DialogRunner(questPresenter);
  final succeeded = dialoger.loopUntilComplete();


  my suggestion is that you implement a STREAM
  inside of WebQuestionPresenter
  it can send questions to your Flutter UI code
  and you can implement a REVERSE stream to send answers
  back from the Web UI

  please work on your own branch
  send PR to dewey to merge your code to "master" branch
  NEVER merge your code to the "prod" branch

  In the next few weeks, this package will become a 
  dependency of ScoreTrader


defer this until after 1st build:
  How do I feed Competition updates
  into the rows hidden inside GroupedTableDataMgr

  I could pass a stream in and allow it to update
  those rows ...

  or update them on the outside