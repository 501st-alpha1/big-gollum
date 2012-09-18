$("#new_wiki_link").click(function() {
  show_create_dialogue();
  return false;
});

$("#cancel_create_wiki_link").click(function() {
  hide_create_dialogue();
  return false;
});


function show_create_dialogue() {
  $("#wikis").animate({
    top: '+=50',
    opacity: '0'
  }, 200, function(){
    $("#wiki_create_dialogue").fadeIn(100);
  });

  $("#new_wiki_link").animate({
    opacity: '0'
  }, 200);


}

function hide_create_dialogue() {
  $("#wiki_create_dialogue").fadeOut(100, function(){
    $("#wikis").animate({
      top: '-=50',
      opacity: '1'
    }, 200, function(){

    });

    $("#new_wiki_link").animate({
      opacity: '1'
    }, 200);
  });
}