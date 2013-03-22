function del(obj) {
    $.get("/db/delete_item",{id:$(obj).parent().parent().parent().attr('id')},
	  function(data){
	      $(obj).parent().parent().parent().remove();
	  });
}

function todo_submit() {
    id=$("#submit-id").val();
    if ($("#content").val() !== "" &&
	$("#title").val() !== "") {
	if($("#submit-id").val()!==""){
	    $.post("/db/update_item",{
		id:$("#submit-id").val(),
		content:$("#content").val(),
		state:$("#submit-todo-state").text(),
		title:$("#title").val()},function(data){
		    reload_todo_item_with_id(id);
		});
	}else{
	    $.post("/db/create_item",{
		content:$("#content").val(),
		state:$("#submit-todo-state").text(),
		title:$("#title").val()},function(data){
		    get_last_todo_item();
		});
	}
	submit_clear();
    }
}
function submit_clear(){
    $("#submit-id").val("");
    $("#submit-todo-state").text("0");
    $("#submit-todo-state-dis").text("TODO");
    $("#create_form")[0].reset();
}
function set_submit_info(obj){
    $("#submit-id").val($(obj).parent().parent().parent().attr('id'));
    $.get("/db/get_item",{id:$(obj).parent().parent().parent().attr('id')},
	  function(data){
	      $("#title").val($("<div/>").html(data[0]["item_title"]).text());
	      $("#content").val($("<div/>").html(data[0]["item_content"]).text());
	      $("#submit-todo-state").text(data[0]["item_todo_state"]);
	      $("#title").val($("<div/>").html(data[0]["item_title"]).text());
	      set_submit_todo_state();
	  });
}
function reload_todo_list(){
    $("#todo-list").empty();
    $.get("/get_all_items_html",function(data){
	$("#todo-list").append(data);
    });
}

function reload_todo_item_with_id(id){
    $.get("/get_item_html",{id:id},function(data){
	$("#"+id).replaceWith(data);
    });
}
function get_last_todo_item(){
    $.get("/get_last_item_html",function(data){
	$("#todo-list").append(data);
    });
}
function change_submit_todo_state () {
    if(parseInt($("#submit-todo-state").text())===0){
	$("#submit-todo-state").text("1");
	$("#submit-todo-state-dis").text("DONE");
    }else{
	$("#submit-todo-state").text("0");
	$("#submit-todo-state-dis").text("TODO");
    }
}
function set_submit_todo_state () {
    if(parseInt($("#submit-todo-state").text())===0){
	$("#submit-todo-state-dis").text("TODO");
    }else{
	$("#submit-todo-state-dis").text("DONE");
    }
}
function change_todo_state (obj) {
    var id = $(obj).parent().parent().parent().attr('id');
    if(parseInt($("#item-todo-state-"+ id).text())===0){
	$("#item-todo-state-"+ id).text("1");
	$("#"+id).removeClass("alert-error");
	$("#"+id).addClass("alert-success");
	$("#item-todo-state-dis-"+id).text("DONE");
    }else{
	$("#item-todo-state-"+ id).text("0");
	$("#"+id).removeClass("alert-success");
	$("#"+id).addClass("alert-error");
	$("#item-todo-state-dis-"+id).text("TODO");
    }
    $.post("/db/update_item",{id:id,
			      state:$("#item-todo-state-"+id).text()});
}
function set_alert(id){
    if((parseInt($("#item-todo-state-"+ id).text())===0)){
	$("#"+id).removeClass("alert-success");
	$("#"+id).addClass("alert-error");
	$("#item-todo-state-dis-"+id).text("TODO");
    }else{
	$("#"+id).removeClass("alert-error");
	$("#"+id).addClass("alert-success");
	$("#item-todo-state-dis-"+id).text("DONE");
    }
}
//<!-- $.get("/db/get_item",{id:"13"}, -->
//<!-- function(data){ -->
//<!-- alert(data[0]["item_id"])}) -->
//<!-- alert($(obj).parent().parent().parent().attr('id')) -->
