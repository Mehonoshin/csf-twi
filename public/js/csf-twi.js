$(document).ready(function() {
  $('.pagination').hide();

  $.infinitescroll.fn = {
    loadingImg : '/img/loading.gif'
  }

  $('.tweets').infinitescroll({
     navSelector: '.pagination',
     nextSelector: '.pagination a:first',
     itemSelector: '.tweets',
     loadingImg: "/img/loading.gif",
     loadingMsg: "Загружаю...",
     animate: true,
     finishedMsg: "Больше ничего нет",
     debug: false
  });
});

