$(document).ready(function(){
	var vm = new Vue({
		el: '#app',
		data: {
			nodes: []
		}
	})

	$.get("/admin/get_nodes",
		function(data) {
			vm.nodes = data.nodes
		}
	)

})
