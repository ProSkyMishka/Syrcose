should_water(Plant) :-
    soil_moisture(Plant, low),
    temperature(Plant, Temp),
    min_temperature_for_watering(Plant, MinTemp),
    Temp >= MinTemp.

select_watering_agent(Plant, Agent) :-
    agent(Agent),
    can(Agent, water, Plant).
