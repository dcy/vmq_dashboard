-module(vmq_handler).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	Body = case cowboy_req:binding(what, Req) of
			   {undefined, Req} ->
				   jsx:encode(#{hello=>hello});
			   {<<"get_nodes">>, Req} ->
				   NodeStatus = vmq_cluster:status(),
				   NodeInfos = [get_node_info(Node, IsRunning) || {Node, IsRunning} <- NodeStatus],
				   jsx:encode(#{nodes => NodeInfos})
		   end,
	{ok, Req2} = cowboy_req:reply(200,
		[{<<"content-type">>, <<"application/json">>}],
		Body, Req),
	{ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
	ok.



%%todo: only remote node call rpc
get_node_info(NodeName, IsRunning) ->
	case IsRunning of
		true ->
			Listeners = rpc:call(NodeName, vmq_ranch_config, listeners, []),
			format_node(Listeners, #{name=>NodeName, is_running=>IsRunning});
		false ->
			#{name=>NodeName, is_running=>IsRunning, vmq_ip=>"", vmq_port=>"",
			  mqtt_ip=>"", mqtt_port=>"", max_conns=>0}
	end.

format_node(Listeners, Node) ->
	Fun = fun({Type, Ip, Port, _, _, MaxConns}, TempNode) ->
				  IpKey = list_to_atom(lists:concat([Type, '_ip'])),
				  PortKey = list_to_atom(lists:concat([Type, '_port'])),
				  MaxConnsKey = list_to_atom(lists:concat([Type, '_max_conns'])),
				  TempNode#{IpKey=>list_to_binary(Ip), PortKey=>list_to_binary(Port),
							MaxConnsKey=>MaxConns}
		  end,
	lists:foldl(Fun, Node, Listeners).


	
