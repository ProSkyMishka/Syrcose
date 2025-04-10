:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_unix_daemon)).
:- use_module(library(http/http_json)).

:- consult('plants.pl').
:- consult('sensors.pl').
:- consult('agents.pl').
:- consult('thresholds.pl').
:- consult('watering_logic.pl').
:- consult('controller.pl').
:- consult('execution.pl').
:- consult('simulation.pl').

:- http_handler(root(command), handle_command, []).

handle_command(Request) :-
    http_read_json_dict(Request, Dict),
    (   get_dict(code, Dict, Code) ->
        term_to_atom(Term, Code),
        (   catch(execute_with_output(Term, Output), Error, fail) ->
            reply_json(json([status=success, result=Output]))
        ;   reply_json(json([status=error, message=Error]))
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
    http_server(http_dispatch, [port(8080)]),
    wait_forever.

wait_forever :-
    repeat,
    sleep(60).