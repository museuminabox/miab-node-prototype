control = {

  is_admin: false,
  current_id: null,
  reshow: false,

  init: function() {
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

    if (control.current_id != '' && control.reshow) {
      $.getJSON("/api/miab.tag.detected?id=" + control.current_id, function( data ) {
      });
    };

  },

  known_tag: function(json) {
    json = JSON.parse(JSON.parse(json));

    if (control.is_admin) {
      $('#new_tag [name=id]').val(json.id);
      $('#new_tag [name=title]').val(json.title);
      $('#new_tag').css('display', 'block');
      if ("image" in json) {
        $('#new_tag #image img').attr('src', '/tag_image/' + json.image);
        $('#new_tag #image').css('display', 'block');
      }
      if ("mp3" in json) {
        $('#new_tag #mp3 audio').attr('src', '/tag_audio/' + json.mp3);
        $('#new_tag #mp3').css('display', 'block');
      }
    } else {
      $('#tag_metadata #id').text(json.id);
      $('#tag_metadata #title').text(json.title);
      $('#tag_metadata').css('display', 'block');
      if ("image" in json) {
        $('#tag_metadata #image img').attr('src', '/tag_image/' + json.image);
        $('#tag_metadata #image').css('display', 'block');
      }
      if ("mp3" in json) {
        $('#tag_metadata #mp3 audio').attr('src', '/tag_audio/' + json.mp3);
        $('#tag_metadata #mp3').css('display', 'block');
      }
    }
  },

  unknown_tag: function(id) {
    //  Show the form
    $('#new_tag [name=id]').val(id);
    $('#new_tag [name=title]').val('');
    $('#new_tag').css('display', 'block');
  },

  tag_lost: function(id) {
    //  Show the form
    $('#new_tag').css('display', 'none');
    $('#tag_metadata').css('display', 'none');

    $('#tag_metadata #image img').attr('src', '');
    $('#tag_metadata #image').css('display', 'none');
    $('#new_tag #image img').attr('src', '');
    $('#new_tag #image').css('display', 'none');

    $('#tag_metadata #mp3 audio').attr('src', '');
    $('#tag_metadata #mp3').css('display', 'none');
    $('#new_tag #mp3 audio').attr('src', '');
    $('#new_tag #mp3').css('display', 'none');

  },

  enter_admin: function() {
    document.location.reload();
  },

  exit_admin: function() {
    document.location.reload();
  }

};
