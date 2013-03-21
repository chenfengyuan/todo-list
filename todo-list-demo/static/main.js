function del(obj) {
	$.get("/db/delete_item",{id:$(obj).parent().parent().parent().attr('id')},
	function(data){
		$(obj).parent().parent().parent().remove();
	});
}

function create(obj) {
	if ($("#content").val() !== "" &&
	    $("#title").val() !== "") {
		if($("#submit-id").val()!==""){
			$.post("/db/update_item",{
				id:$("#submit-id").val(),
				content:$("#content").val(),
				title:$("#title").val()},function(data){
					reload_todo_item_with_id($("#submit-id").val());
					$("#submit-id").val("");
				});
		}else{
			$.post("/db/create_item",{
				content:$("#content").val(),
				title:$("#title").val()},function(data){
		    			get_last_todo_item();
				});
		}
	    $("#create_form")[0].reset();
	}
}
function submit_clear(){
	$("#submit-id").val("")
	$("#create_form")[0].reset();
}
function set_submit_info(obj){
	$("#submit-id").val($(obj).parent().parent().parent().attr('id'))
	$.get("/db/get_item",{id:$(obj).parent().parent().parent().attr('id')},
	      function(data){
		      $("#title").val($("<div/>").html(data[0]["item_title"]).text())
		      $("#content").val($("<div/>").html(data[0]["item_content"]).text())})
}
function reload_todo_list(){
	$("#todo-list").empty()
	$.get("/get_all_items_html",function(data){
		$("#todo-list").append(data);
	})
}

function reload_todo_item_with_id(id){
	$.get("/get_item_html",{id:id},function(data){
		$("#"+id).replaceWith(data);
	})
}
function get_last_todo_item(){
	$.get("/get_last_item_html",function(data){
		$("#todo-list").append(data);
	})
}
<!-- $.get("/db/get_item",{id:"13"}, -->
<!-- function(data){ -->
<!-- alert(data[0]["item_id"])}) -->
<!-- alert($(obj).parent().parent().parent().attr('id')) -->
