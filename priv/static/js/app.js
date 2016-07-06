$(document).ready(function(){
	console.log("8==D")
	var vm = new Vue({
		el: '#app',
		data: {
			message: "8==D"
		}
	})


	$.get("/admin/get_nodes",
		function(data) {
			console.log("******", data)
		}
	)

})
