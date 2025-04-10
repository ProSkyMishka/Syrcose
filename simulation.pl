generated_command(water(ficus)).

execute_generated_command :-
    generated_command(water(Plant)),
    command_allowed(controller_1, water(Plant)),
    select_watering_agent(Plant, Agent),
    format("LLM generated: ~w is watering ~w.~n", [Agent, Plant]),
    update_moisture_after_watering(Plant).

execute_generated_command :-
    generated_command(water(Plant)),
    \+ command_allowed(controller_1, water(Plant)),
    format("LLM generated: Watering of ~w is denied: risk of overwatering.~n", [Plant]).
