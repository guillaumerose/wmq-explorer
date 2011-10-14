function queue_name(i) {
  return $("#queue" + i + "_name").val();
}

function retrieve(i) {
  if (queue_name(i) == "")
    return;
    
  $.getJSON("/api/" + queue_name(i), function(data) { 
    if (data.errors) {
      $("#console").prepend("<pre>" + htmlEntities(data.errors) + "</pre>");
      return;
    } else {
      $("#console").html("");
    }
    
    $("#queue" + i + "_messages").html("");
    $.each(data.messages, function(key, msg) {
      $("#queue" + i + "_messages").append("<div class='message'><pre>" + htmlEntities(msg) + "</pre></div>");
    });
  });
}

function loop_retrieve() {
  retrieve(1);
  retrieve(2);
  setTimeout(function() { loop_retrieve() }, 1000);
}

function post(i) {
  var val = $("textarea#queue" + i + "_message").val();
  if (queue_name(i) == "" || val == "")
    return;
    
  $.post("/api/" + queue_name(i), "message=" + val, function (data) {}, "text");
}

function flush(i) {
  if (queue_name(i) == "")
    return;
    
  $.ajax({
    url: "/api/" + queue_name(i),
    type: "DELETE"
  });
}

function retrieveList() {
  $.getJSON("/api/queues", function(data) { 
    if (data.errors) {
      $("#console").prepend("<pre>" + htmlEntities(data.errors) + "</pre>");
      return;
    } else {
      $("#console").html("");
    }
    
    $.each(data.queues, function(key, queue) {
      $("#queue1_name").append("<option value='" + queue + "'>" + queue + "</option>");
      $("#queue2_name").append("<option value='" + queue + "'>" + queue + "</option>");
    });
  });
}

function htmlEntities(str) {
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
