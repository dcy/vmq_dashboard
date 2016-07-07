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
			[{_, MqttIp, MqttPort, _, _, MaxConns}, {_, VmqIp, VmqPort, _, _, _}] =
			rpc:call(NodeName, vmq_ranch_config, listeners, []),
			#{name=>NodeName, is_running=>IsRunning,
			  vmq_ip=>list_to_binary(VmqIp), vmq_port=>list_to_binary(VmqPort),
			  mqtt_ip=>list_to_binary(MqttIp), mqtt_port=>list_to_binary(MqttPort),
			  max_conns=>MaxConns};
		false ->
			#{name=>NodeName, is_running=>IsRunning, vmq_ip=>"", vmq_port=>"",
			  mqtt_ip=>"", mqtt_port=>"", max_conns=>0}
	end.
