### Overview

evCfg (this app) is for configuring an Event
associated JSON payload, which is
intended to radically customize the UI of 
the Scoretrader app, based on the current event
selected by the user

#### Structure and Design
Questions are nested into a hierarchy as follows:

    Event Config -- (basic ?? about event setup;  Event level)
    App Screen (any UI that domniates the viewport )  Screen (app section) level
        Section/Area (top widget in an App Screen)
            Area-Slot -- specific sub-widget inside the area (ie row inside tableview)
                Rule applying to an Area or Area-Slot
                    Visual Rules
                    Behavioral Rules

#### CLI Usage
    open terminal
    "cd" into project folder
    run these cmds:
        dart pub get
        dart lib/evCdg.dart

### General flow of app
App Feeds question to user
User response to question, has one of 4 effects
 * Capture some value(s) and store as part of config
 * Produce more future (immanent) questions
 <!-- * Eliminate some future questions -->
 * Create a "rule" for some part (screen & area combination)
    of the Scoretrader app

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

rebuild JSON models:  
    cd projectRoot (above lib/)
    flutter pub run build_runner build


###### Examples:
Questions:
enter event name

do you want to customize MarketView -- y or n
on MarketView, do you wish to customize: