(function ($) {

  'use strict';

  $(document).on('submit', 'form', function() {
    if (!$(this).attr('data-turbo-frame')) {
      $('.js-preloader').removeClass('loaded');
    }
  });

  $(document).on('click', 'a', function() {
    if ($(this).attr('href') && $(this).attr('href') !== '#' && !$(this).attr('data-turbo-frame')) {
      $('.js-preloader').removeClass('loaded');
    }
  });

  document.addEventListener('turbo:load', function() {
    $('#js-preloader').addClass('loaded');
  });

  $(window).scroll(function() {
    var scroll = $(window).scrollTop();
    var box = $('.header-text').height();
    var header = $('header').height();

    if (scroll >= box - header) {
      $('header').addClass('background-header');
    } else {
      $('header').removeClass('background-header');
    }
  });

  var width = $(window).width();
  $(window).resize(function() {
    if (width > 767 && $(window).width() < 767) {
      location.reload();
    } else if (width < 767 && $(window).width() > 767) {
      location.reload();
    }
  });

// ---------------------------

  $(window).on('load', function() {
    if ($('.cover').length) {
      $('.cover').parallax({
        imageSrc: $('.cover').data('image'),
        zIndex: '1'
      });
    }

    $('#preloader').animate({
      'opacity': '0'
    }, 600, function() {
      setTimeout(function() {
        $('#preloader').css('visibility', 'hidden').fadeOut();
      }, 300);
    });
  });

})(window.jQuery);
