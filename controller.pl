command_allowed(controller_1, water(Plant)) :-
    soil_moisture(Plant, Current),
    max_allowed_moisture(Plant, Max),
    watering_safe(Current, Max).

watering_safe(low, _).
watering_safe(medium, high).
