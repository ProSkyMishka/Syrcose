:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_unix_daemon)).
:- use_module(library(http/http_json)).
:- use_module(library(debug)).
:- use_module(library(signal)).

:- debug(server).

:- consult('plants.pl').
:- consult('sensors.pl').
:- consult('agents.pl').
:- consult('thresholds.pl').
:- consult('watering_logic.pl').
:- consult('controller.pl').
:- consult('execution.pl').
:- consult('simulation.pl').

:- discontiguous agent/1.
:- dynamic soil_moisture/2.

:- http_handler(root(command), handle_command, []).

handle_command(Request) :-
    http_read_json_dict(Request, Dict),
    (   get_dict(code, Dict, Code) ->
        term_to_atom(Term, Code),
        (   catch(execute_with_output(Term, Output), _, fail) ->
            reply_json(json([status=success, result=Output]))
        ;   reply_json(json([status=error, message="Execution failed"]))
        )
    ;   reply_json(json([status=error, message="Missing key 'code'"]))
    ).

execute_with_output(Term, FinalOutput) :-
    (   with_output_to(string(Output), (call(Term) -> true ; Output = "false"))
    ->  true
    ;   Output = "false"
    ),
    (Output = "" -> FinalOutput = "true" ; FinalOutput = Output).

start_server :-
    debug(server, 'Starting server on port 8080', []),
    catch(
        http_server(http_dispatch, [port(8080), workers(2)]),
        Error,
        (debug(server, 'Server failed to start: ~w', [Error]), fail)
    ),
    debug(server, 'Server started successfully', []),
    wait_forever.

wait_forever :-
    repeat,
    sleep(1).

:- initialization((
    debug(server, 'Initializing server...', []),
    catch(start_server, Error, (debug(server, 'Initialization failed: ~w', [Error]), halt(1)))
)).