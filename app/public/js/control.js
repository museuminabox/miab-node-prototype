control = {

  is_admin: false,

  init: function() {
    console.log('STARTED');
    socket = io();

    //  Register all the socket thingies
    socket.on('known tag', function(json){
      control.known_tag(json);
    });

    socket.on('tag lost', function(json){
      control.tag_lost(json);
    });

    socket.on('unknown tag', function(id){
      control.unknown_tag(id);
    });

    socket.on('enter admin', function(){
      control.enter_admin();
    });

    socket.on('exit admin', function(){
      control.exit_admin();
    });

  },

  known_tag: function(json) {
    console.log('known tag');
    json = JSON.parse(JSON.parse(json));
    console.log(json);

    if (control.is_admin) {
      $('#new_tag [name=id]').val(json.id);
      $('#new_tag [name=title]').val(json.title);
      $('#new_tag').css('display', 'block');
      if ("image" in json) {
        $('#new_tag #image img').attr('src', '/tag_image/' + json.image);
        $('#new_tag #image').css('display', 'block');
      }
    } else {
      $('#tag_metadata #id').text(json.id);
      $('#tag_metadata #title').text(json.title);
      $('#tag_metadata').css('display', 'block');
      if ("image" in json) {
        $('#tag_metadata #image img').attr('src', '/tag_image/' + json.image);
        $('#tag_metadata #image').css('display', 'block');
      }
    }
  },

  unknown_tag: function(id) {
    console.log('unknown tag: ' + id);
    //  Show the form
    $('#new_tag [name=id]').val(id);
    $('#new_tag [name=title]').val('');
    $('#new_tag').css('display', 'block');
  },

  tag_lost: function(id) {
    console.log('tag lost: ' + id);
    //  Show the form
    $('#new_tag').css('display', 'none');
    $('#tag_metadata').css('display', 'none');
    $('#tag_metadata #image img').attr('src', '');
    $('#tag_metadata #image').css('display', 'none');
  },

  enter_admin: function() {
    document.location.reload();
  },

  exit_admin: function() {
    document.location.reload();
  }

};
