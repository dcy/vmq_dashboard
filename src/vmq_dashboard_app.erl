%%%-------------------------------------------------------------------
%% @doc vmq_dashboard public API
%% @end
%%%-------------------------------------------------------------------

-module(vmq_dashboard_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	init(),
    vmq_dashboard_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
init() ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/admin/[:what]", vmq_handler, []},
			{"/", cowboy_static, {priv_file, vmq_dashboard, "templates/index.html"}},
			{"/static/[...]", cowboy_static, {priv_dir, vmq_dashboard, "static"}}
		]}
	]),
	{ok, _} = cowboy:start_http(vmq_dashboard, 100, [{port, 9080}], [
		{env, [{dispatch, Dispatch}]}
	]),


	ok.
