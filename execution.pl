execute_watering(Plant) :-
    should_water(Plant),
    command_allowed(controller_1, water(Plant)),
    select_watering_agent(Plant, Agent),
    format("~w is watering ~w.~n", [Agent, Plant]),
    update_moisture_async(Plant).

execute_watering(Plant) :-
    \+ command_allowed(controller_1, water(Plant)),
    format("Watering of ~w is denied: risk of overwatering.~n", [Plant]).

next_moisture_level(low, medium).
next_moisture_level(medium, high).
next_moisture_level(high, high). 

update_moisture_async(Plant) :-
    retract(soil_moisture(Plant, low)),
    assert(soil_moisture(Plant, medium)),
    format('Moisture is now medium for ~w.~n', [Plant]),
    % Отложим выполнение на 60 секунд в отдельном потоке
    thread_create(wait_and_update(Plant), _, [detached(true)]).

wait_and_update(Plant) :-
    sleep(15),
    retract(soil_moisture(Plant, medium)),
    assert(soil_moisture(Plant, low)),
    format('Moisture is now low for ~w again.~n', [Plant]).

check_soil_moisture(Plant) :-
    soil_moisture(Plant, Moisture),
    format('Current moisture level for ~w: ~w~n', [Plant, Moisture]).
