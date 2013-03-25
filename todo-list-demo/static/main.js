function get_id(id_str){
	return id_str.replace("item-id-","");
}

function del(obj) {
	var id = get_id($(obj).parent().parent().parent().attr('id'));
	if(id===$("#submit-id").val())
		submit_clear();
	$.get("/api/delete_item_json",{id:id},
	      function(data){
		      $(obj).parent().parent().parent().remove();
	      });
}

function todo_submit() {
	id=$("#submit-id").val();
	if ($("#submit-todo-content").val() !== "" &&
		$("#submit-todo-title").val() !== "") {
		if($("#submit-id").val()!==""){
			$.post("/api/update_item_json",{
				id:$("#submit-id").val(),
				content:$("#submit-todo-content").val(),
				state:$("#submit-todo-state").text(),
				title:$("#submit-todo-title").val()},function(data){
					reload_todo_item_with_id(id);
				});
		}else{
			$.post("/api/create_item_json",{
				content:$("#submit-todo-content").val(),
				state:$("#submit-todo-state").text(),
				title:$("#submit-todo-title").val()},function(data){
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

var decode_entities = (function() {
	// Remove HTML Entities
	var element = document.createElement('div');

	function decode_HTML_entities (str) {

		if(str && typeof str === 'string') {

			// Escape HTML before decoding for HTML Entities
			str = escape(str).replace(/%26/g,'&').replace(/%23/g,'#').replace(/%3B/g,';');

			element.innerHTML = str;
			if(element.innerText){
				str = element.innerText;
				element.innerText = '';
			}else{
				// Firefox support
				str = element.textContent;
				element.textContent = '';
			}
		}
		return unescape(str);
	}
	return decode_HTML_entities;
})();

function set_submit_info(obj){
	$("#submit-id").val(get_id($(obj).parent().parent().parent().attr('id')));
	$.get("/api/get_item_json",{id:get_id($(obj).parent().parent().parent().attr('id'))},
	      function(data){
		      $("#submit-todo-title").val(decode_entities(data[0]["item_title"]));
		      $("#submit-todo-content").val(decode_entities(data[0]["item_content"]));
		      $("#submit-todo-state").text(data[0]["item_todo_state"]);
		      $("#submit-todo-title").val(decode_entities(data[0]["item_title"]));
		      set_submit_todo_state();
	      });
}

function reload_todo_list(){
	$("#todo-list").empty();
	$.get("/api/get_all_items_html",function(data){
		$("#todo-list").append(data);
	});
}

function reload_todo_item_with_id(id){
	$.get("/api/get_item_html",{id:id},function(data){
		$("#item-id-"+id).replaceWith(data);
	});
}

function get_last_todo_item(){
	$.get("/api/get_last_item_html",function(data){
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
	var id = get_id($(obj).parent().parent().parent().attr('id'));
	if(id===$("#submit-id").val())
		submit_clear();
	if(parseInt($("#item-todo-state-"+ id).text())===0){
		$("#item-todo-state-"+ id).text("1");
		$("#item-id-"+id).removeClass("alert-error");
		$("#item-id-"+id).addClass("alert-success");
		$("#item-todo-state-dis-"+id).text("DONE");
	}else{
		$("#item-todo-state-"+ id).text("0");
		$("#item-id-"+id).removeClass("alert-success");
		$("#item-id-"+id).addClass("alert-error");
		$("#item-todo-state-dis-"+id).text("TODO");
	}
	$.post("/api/update_item_json",{id:id,
					state:$("#item-todo-state-"+id).text()});
}

function set_alert(id){
	if((parseInt($("#item-todo-state-"+ id).text())===0)){
		$("#item-id-"+id).removeClass("alert-success");
		$("#item-id-"+id).addClass("alert-error");
		$("#item-todo-state-dis-"+id).text("TODO");
	}else{
		$("#item-id-"+id).removeClass("alert-error");
		$("#item-id-"+id).addClass("alert-success");
		$("#item-todo-state-dis-"+id).text("DONE");
	}
}
//<!-- $.get("/db/get_item",{id:"13"}, -->
//<!-- function(data){ -->
//<!-- alert(data[0]["item_id"])}) -->
//<!-- alert($(obj).parent().parent().parent().attr('id')) -->
