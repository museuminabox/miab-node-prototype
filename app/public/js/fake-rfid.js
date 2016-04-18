var tags = [];
var offset = {x: null, y: null};
var is_dragging = false;
var dragged = null;
var radius = 32;
var max_tags = 12;
var old_tag = null;


//  Place all the tags onto the canvas.
function setup() {
  createCanvas(640, 320);
  var heightMod = 1;
  for (var i = 0; i < max_tags; i++) {
    if (i < max_tags/2) {
      tags.push({
          id: '012345ABCDEF0' + i,
          x: i*(radius*2)+radius,
          y:height-radius
        })
    } else {
      tags.push({
          id: '012345ABCDEF0' + i,
          x: (i-max_tags/2)*(radius*2)+radius,
          y:height-(radius*3)
        })
    }
  }
}

//  Draw the positions of the circles
function draw() {

  //  Update the position of a being dragged tag
  if (is_dragging) {
    tags[dragged].x = mouseX + offset.x;
    tags[dragged].y = mouseY + offset.y;
  }

  //  Set the background colour
  colorMode(RGB, 255);
  background(240);

  //  Drag the tag reader
  fill(255);
  ellipse(width-68, 68, 128, 128);

  //  Draw the tags
  colorMode(HSB, 360);
  for (var i = 0; i < max_tags; i++) {
    fill(i/max_tags*360, 360, 360);
    ellipse(tags[i].x, tags[i].y, radius*2, radius*2);
  }

  //  Work out if a dragged tag is over the reader
  if (dragged !== null) {
    //  Get the distance of the tag from the reader
    var d = dist(width-36, 36, tags[dragged].x, tags[dragged].y);
    //  If it's close enough (75px in this case) assume the tag is over the
    //  reader
    if (d <= 75) {
      if (dragged != old_tag) {
        old_tag = dragged;
        $("h1").text("Fake RFID - Detected: " + tags[dragged].id);
        $.getJSON("/api/miab.tag.detected?id=" + tags[dragged].id, function( data ) {
          console.log(data);
        });
      }
    } else {
      if (old_tag != null) {
        $("h1").text("Fake RFID - Tag lost");
        old_tag = null;
        $.getJSON("/api/miab.tag.lost", function( data ) {
          console.log(data);
        });
      }
    }
  }

}

function mouseReleased() {
  is_dragging = false;
}

function mousePressed() {

  //  loop thru all the tags to see if we are over any of them.
  for (var i = max_tags-1; i >= 0; i--) {
    var d = dist(mouseX, mouseY, tags[i].x, tags[i].y);
    if (d < radius) {
      is_dragging = true;
      dragged = i;
      offset.x = tags[i].x - mouseX;
      offset.y = tags[i].y - mouseY;
      break;
    }
  }
}
