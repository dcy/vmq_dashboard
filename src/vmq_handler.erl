-module(vmq_handler).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	lager:info("****** 8==D vmq_handler"),
	Body = case cowboy_req:binding(what, Req) of
			   {undefined, Req} ->
				   <<"Fuck">>;
			   {What, Req} ->
				   lager:info("******* 8==D, What: ~p", [What]),
				   What
		   end,
	{ok, Req2} = cowboy_req:reply(200,
		[{<<"content-type">>, <<"text/html">>}],
		Body, Req),
	{ok, Req2, State}.



	%NewValue = integer_to_list(random:uniform(1000000)),
	%Req2 = cowboy_req:set_resp_cookie(
	%	<<"server">>, NewValue, [{path, <<"/">>}], Req),
	%{ClientCookie, Req3} = cowboy_req:cookie(<<"client">>, Req2),
	%{ServerCookie, Req4} = cowboy_req:cookie(<<"server">>, Req3),
	%{ok, Body} = toppage_dtl:render([
	%	{client, ClientCookie},
	%	{server, ServerCookie}
	%]),
	%{ok, Req5} = cowboy_req:reply(200,
	%	[{<<"content-type">>, <<"text/html">>}],
	%	Body, Req4),
	%{ok, Req5, State}.

terminate(_Reason, _Req, _State) ->
	ok.