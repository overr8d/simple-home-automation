%Startup
main:-
    home_automation.

home_automation:-
    init_facts,
    write("Welcome to Prolog Home Automation System:)"),nl,nl,
    command_loop.

command_loop:-
    repeat,
    write("Please specify what would you like to do,like quit/activate/deactivate:"),nl,
    read(X),
    do(X),
    X = quit.


%Indicates actions to be taken.
do(quit):-quit,!.
do(activate):-activate,!.
do(deactivate):-deactivate,!.

%Activator.
activator(System):-
    System == air_condition,
    retract(turned_off(air_condition)),
    assert(turned_on(air_condition)),
    set_degree,!.
activator(System):-
    retract(turned_off(System)),
    assert(turned_on(System)),!.

%Deactivator.
deactivator(System):-
    retract(turned_on(System)),
    assert(turned_off(System)),!.


activate:-
    write("What system do you want to activate, please see the deactivated systems below: "),nl,
    list_deactivated,
    read(System),
    activator(System).

deactivate:-
    write("What system do you want to deactivate, please see the active systems below: "),nl,
    list_activated,
    read(System),
    deactivator(System).


init_facts:-
    retractall(turned_off(_)),
    retractall(turned_on(_)),
    assert(turned_off(air_condition)),
    assert(turned_off(water_heater)),
    assert(turned_off(blinds)),
    assert(turned_off(lights)),
    assert(turned_off(music)),
    assert(turned_off(cameras)),
    assert(turned_off(alarm)),
    assert(turned_off(wireless)).


%Displays what systems are activated now.
list_activated:-
    write("Below systems are active"),nl,write("------------------------------"),nl,
    turned_on(X),
    write(X),nl,fail.

list_activated.

%Displays what systems are deactivated now.
list_deactivated:-
    write("Below systems are deactivated"),nl,write("------------------------------"),nl,
    turned_off(X),
    write(X),nl,fail.

list_deactivated.

%Puts the system into sleep mode.
quit:-
    write("Leaving? Ohh, OK, I am putting the system into sleep mode, until next time:)"),nl,
    retractall(turned_off(_)),
    retractall(turned_on(_)),
    assert(turned_on(cameras)),
    assert(turned_on(alarm)),
    assert(turned_on(wireless)),
    list_deactivated,
    list_activated.

% Defines how to change the temperature.
set_degree:-
write("\nEnter a temperature in degrees Celcius: "),
read(C),
process(C).

%Defines how to handle temperature magnitude.
process(C):-
number(C),
convert(C,F),
write("The temperature is "), write(F), write(" Degrees Fahrenheit"),
nl,
warning(F,W),
write(W),
nl.

%Temperature notification.
warning(T, "It is really hot out."):- T>90,!.
warning(T, "It is freezing cold."):- T<30,!.
warning(_,"").

%Celcius to Fahrenheit conversion.
convert(Cel, Fahr):-
Fahr is 9.0/5.0 * Cel + 32.

