### Overview

Feed question to user
User response has one of 3 effects
 * Produce more future (immanent) questions
 * Eliminate some future questions
 * Create a "rule" for some part of the app

Logic for all 3 above is determined by
Current response/answer state

Rules can either be:
 * visual (eg Table-Row-Style or hidden element)
or they can be 
 * behavioral (eg navigate or skip-some-step)





Control what is configurable by editing the lists returned in enums/app_ui.dart

rebuild JSON models:  
    cd projectRoot (above lib/)
    flutter pub run build_runner build


Questions:
enter event name

do you want to customize MarketView -- y or n
on MarketView, do you wish to customize: