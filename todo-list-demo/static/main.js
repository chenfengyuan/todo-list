function del(obj) {
	$.get("/db/delete_item",{id:$(obj).parent().parent().parent().attr('id')},
	function(data){
		$(obj).parent().parent().parent().remove();
	});
}

function create(obj) {
	if ($("#content").val() !== "" &&
	    $("#title").val() !== "") {
	    $.post("/db/create_item",{
		    content:$("#content").val(),
		    title:$("#title").val()},function(data){
		    	    get_last_todo_item();
		    });
	    $("#create_form")[0].reset();
	}
}
function reload_todo_list(){
	$("#todo-list").empty()
	$.get("/get_all_items_html",function(data){
		$("#todo-list").append(data);
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
