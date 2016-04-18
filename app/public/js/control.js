control = {

  init: function() {
    console.log('STARTED');
    socket = io();

    //  Register all the socket thingies
    socket.on('chat message', function(msg){
      control.chat_message(msg);
    });

    socket.on('enter admin', function(){
      control.enter_admin();
    });

    socket.on('exit admin', function(){
      control.exit_admin();
    });

  },

  chat_message: function(msg) {
    $('#messages').append($('<li>').text(msg));
  },

  enter_admin: function() {
    document.location.reload();
  },

  exit_admin: function() {
    document.location.reload();
  }

};
