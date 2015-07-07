-module(txt_log).

-compile([export_all]).

init(_Type, Req, _Opts) ->
    {ok, Req, no_state}.

handle(Req, State) ->
    {ok, F} = file:open(code:priv_dir(xctf_missle) ++ "/missles.log", read),
    {ok, Data} = case file:pread(F, {eof, -102400}, 102400) of
               XX1 = {ok, _} -> 
                         XX1;
               {error, einval} ->
                         file:read_file(code:priv_dir(xctf_missle) ++ "/missles.log")
                 end,
    file:close(F),
    {ok, Req2} = cowboy_req:reply(200, [
                                        {<<"content-type">>, <<"text/plain">>}
                                       ], Data, Req),
    {ok, Req2, State}.

terminate(_, _, _) -> ok.
