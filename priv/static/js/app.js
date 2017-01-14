$(document).ready(function(){
	var vm = new Vue({
		el: '#app',
		data: {
			nodes: []
		}
	})

	$.get("/vmq_dashboard/get_nodes",
		function(data) {
			vm.nodes = data.nodes
		}
	)

	METRICS = ["/subscriptions/total", "/clients/total", "/clients/active",
		"/clients/inactive", "/memory/system", "/memory/total", '/cpuinfo/toal'
	]

	function sub_metrics(client, node) {
		for (metric in METRICS) {
			topic = '$SYS/' + node + METRICS[metric]
			client.subscribe(topic)
		}
	}
	//client = new Paho.MQTT.Client("192.168.3.236", 8888, "fuck")
	//// set callback handlers
	//client.onConnectionLost = onConnectionLost;
	//client.onMessageArrived = onMessageArrived;

	//// connect the client
	//client.connect({onSuccess:onConnect});


	// called when the client connects
	function onConnect() {
		// Once a connection has been made, make a subscription and send a message.
		console.log("onConnect");

		sub_metrics(client, 'VerneMQ@127.0.0.1')
		//message = new Paho.MQTT.Message("Hello");
		//message.destinationName = "/World";
		//client.send(message);
	}

	// called when the client loses its connection
	function onConnectionLost(responseObject) {
		if (responseObject.errorCode !== 0) {
			console.log("onConnectionLost:"+responseObject.errorMessage);
		}
	}

	// called when a message arrives
	function onMessageArrived(message) {
		console.log("Message topic ", message.destinationName)
		console.log("onMessageArrived:"+message.payloadString)
	}

	

})
