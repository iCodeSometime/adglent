-module(adglent_ffi).

-export([get_line/1, toml_get/2, toml_parse/1]).

-spec get_line(io:prompt()) -> {ok, unicode:unicode_binary()} | {error, eof | no_data}.
get_line(Prompt) ->
    case io:get_line(Prompt) of
        eof -> {error, eof};
        {error, _} -> {error, no_data};
        Data when is_binary(Data) -> {ok, Data};
        Data when is_list(Data) -> {ok, unicode:characters_to_binary(Data)}
    end.

toml_get(Toml, KeyPath) ->
    gleam@result:nil_error(tomerl:get(Toml, KeyPath)).

toml_parse(Content) ->
    gleam@result:nil_error(tomerl:parse(Content)).
