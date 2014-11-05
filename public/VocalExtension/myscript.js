$( window ).load(function() {
  var element = "<div class='vocal-wrapper'></div>"
  $('body').append(element);
  if($('body').find('.vocal-wrapper').length < 1){
    $('body').append(element);
  }
  var wrapperCss = {
    "text-align": "left",
    "font-size": "13px",
    "color": "#FFF",
    "min-height": "40px",
    "padding": "10px",
    "width": "230px",
    "background": "none repeat scroll 0% 0% #111",
    "position":"fixed", 
    "right": "0",
    "z-index":"9999",
    "top": "80px",
    "opacity":"0.8",
    "font-family": "Arial",
    "line-height": "1.6",
    "border-radius":"10px",
    "margin-right": "10px"
  }
  var handlerIn = function(e){
      $(e.currentTarget).fadeOut(100);
  }
  var handlerOut = function(e){
      $(e.currentTarget).fadeIn(500);
  }
  $( "div.vocal-wrapper" ).click(function(e) {
     handlerIn(e);
     var _this = e
     setTimeout(function(){handlerOut(_this);}, 5000);
  }).css( wrapperCss )
  AjaxToRetriveWord();

});
var AjaxToRetriveWord = function(){
  var raw_html = "<div>";
  $.ajax({
    type: "GET",
    url: "http://localhost:5000/words/retrive_word",
  })
  .success(function( response ) {
    var titleCss = {
      "color": "white", 
      "text-shadow": "0px 0px 1px #fff", 
      "text-transform": "capitalize", 
      "font-size": "15px", 
      "font-weight": "600"
    }
    var pharseCss = {
      "padding": "5px 0",
      "text-align": "right",
      "color": "#D0F649"
    }
    var exampleCss={
      "padding-left":"15px",
      "display":"block",
      "color" : "#CC9825"
    }
    var word = response.word
    var blocks = word.content.word;
    raw_html += "<div class='vocal-title'>" + word.title + "</div>";
    $.each( blocks , function( index, block ) {
      var header = "<div class='vocal-pharse'><span>" + block.pharse + "</span>&nbsp;<span>" + block.pronunciation + "</span></div>";
      var body = "";
      $.each( block.content , function(index, content){
        body += "<div><div> - " + content.mean + "</div><i class='vocal-example'>" + content.example + "</i></div>";
      });
      raw_html += header + body;
    });
    raw_html += "</div>"
    $('body').find('.vocal-wrapper').append(raw_html);
    $('body').find('.vocal-wrapper').find('.vocal-title').css(titleCss);
    $('body').find('.vocal-wrapper').find('.vocal-pharse').css(pharseCss);
    $('body').find('.vocal-wrapper').find('.vocal-example').css(exampleCss);
  });
}