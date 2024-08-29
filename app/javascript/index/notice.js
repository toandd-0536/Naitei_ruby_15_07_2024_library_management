document.addEventListener('turbo:load', function() {
  var pusher = new Pusher(gon.pusher_key, {
    cluster: gon.pusher_cluster,
    encrypted: true
  });

  var channel = pusher.subscribe(`user-${gon.user_id}`);
  channel.bind('episode-created', function(data) {
    $('#toast-new .toast-body').text(data.message);
    var toastElement = $('#toast-new');
    toastElement.removeClass('hide')
    toastElement.addClass('show')
  });
});
