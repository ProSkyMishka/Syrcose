execute_watering(Plant) :-
    should_water(Plant),
    command_allowed(controller_1, water(Plant)),
    select_watering_agent(Plant, Agent),
    format("~w is watering ~w.~n", [Agent, Plant]),
    update_moisture_after_watering(Plant).

execute_watering(Plant) :-
    \+ command_allowed(controller_1, water(Plant)),
    format("Watering of ~w is denied: risk of overwatering.~n", [Plant]).

next_moisture_level(low, medium).
next_moisture_level(medium, high).
next_moisture_level(high, high). 

update_moisture_after_watering(Plant) :-
    soil_moisture(Plant, Current),
    next_moisture_level(Current, Next),
    retract(soil_moisture(Plant, Current)),
    assert(soil_moisture(Plant, Next)),
    format("Soil moisture of ~w updated: ~w → ~w~n", [Plant, Current, Next]).
