document.addEventListener('turbo:load', function() {
  if (!window.pusher) {
    window.pusher = new Pusher(gon.pusher_key, {
      cluster: gon.pusher_cluster,
      encrypted: true
    });
  }

  if (window.channel) {
    window.pusher.unsubscribe(`user-${gon.user_id}`);
  }

  window.channel = window.pusher.subscribe(`user-${gon.user_id}`);

  window.channel.unbind('episode-created');

  window.channel.bind('episode-created', function(data) {
    if (data.type === 'Episode') {
      var episodeLink = `/books/${data.episode.book_id}/episodes/${data.episode.id}`;
      var messageWithLink = `<a href="${episodeLink}" class="text-light">${data.message}</a>`;

      $('#toast-new .toast-body').html(messageWithLink);
    } else {
      $('#toast-new .toast-body').text(data.message);
    }

    var toastElement = $('#toast-new');
    toastElement.removeClass('hide');
    toastElement.addClass('show');

    var notificationBadge = $('.header-area .main-nav .nav li:last-child .badge.badge-warning');

    if (notificationBadge.length) {
      var currentCount = parseInt(notificationBadge.text().trim(), 10);
      if (isNaN(currentCount)) {
        currentCount = 0;
      }
      notificationBadge.text(currentCount + 1);
    } else {
      $('.header-area .main-nav .nav li:last-child').append('<span class="badge badge-warning">1</span>');
    }
  });
});
