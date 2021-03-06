$(document).ready(function() {

  function setCookie (name, value, expires, path, domain, secure) {
      document.cookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
  }

  var host = $('body').data("host");
  var client = new Faye.Client('http://' + host + ':9292/faye');

  // Subscribe to the public channel
  var public_subscription = client.subscribe('/tweets/new', function(data) {
    data = JSON.parse(data);
    var jTweetTemplate = $('.tweet-template');
    var jNewTweet = jTweetTemplate.clone();
    jNewTweet.removeClass('hidden');
    jNewTweet.removeClass('tweet-template');

    jNewTweet.find('img').attr('src', data.userpic);
    jNewTweet.find('.profile-link').attr("href", "https://twitter.com/" + data.username);
    jNewTweet.find('.profile-link').text(data.username);
    jNewTweet.find('.tweet-text').text(data.tweet);
    var date = new Date(data.created_at);
    jNewTweet.find('.created-date').text(date.getDate() + "." + (date.getMonth() + 1) + '.' + date.getFullYear());
    $('.new').removeClass('new');
    $('.tweets').prepend(jNewTweet.addClass('new').hide().fadeIn('slow'));
  });

  $('.about-alert .close').click(function(){
    setCookie("about", "hidden");
    $(this).parent().fadeOut();
  });

  $('.pagination').hide();

  $('.tweets').infinitescroll({
     navSelector: '.pagination',
     nextSelector: '.pagination a:first',
     itemSelector: '.tweets',
     loadingImg: "/img/loading.gif",
     loadingText: "Загружаю...",
     donetext: "Больше ничего нет",
     debug: false
  });
});

