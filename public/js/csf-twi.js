$(document).ready(function() {
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

