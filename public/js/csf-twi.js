$(document).ready(function() {

  var client = new Faye.Client('http://localhost:9292/faye');

  // Subscribe to the public channel
  var public_subscription = client.subscribe('/tweets/new', function(data) {
    console.log(data);
  });

  $('.pagination').hide();

  $('.tweets').infinitescroll({
     navSelector: '.pagination',
     nextSelector: '.pagination a:first',
     itemSelector: '.tweets',
     loadingImg: "/img/loading.gif",
     loadingText: "Загружаю...",
     donetext: "Больше ничего нет",
     debug: true
  });
});

