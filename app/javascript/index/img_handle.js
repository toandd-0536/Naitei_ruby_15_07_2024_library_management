function initializeJQuery() {
  const fileInput = $('#episode_thumb');
  const imgView = $('.img-view img');
  const currentImg = $('.img-view').attr('src');
  const defaultImg = '/assets/placeholder-25eb8ab291d725877dbf4159904b5050359fbb6a188f838df9e5d045af7af8d2.png'
  fileInput.on('change', function (event) {
    const file = event.target.files[0];
    if (file) {
      const fileType = file.type;
      const validImageTypes = ['image/jpeg', 'image/png', 'image/gif'];

      if (validImageTypes.includes(fileType)) {
        const reader = new FileReader();
        reader.onload = function (e) {
          imgView.attr('src', e.target.result);
          imgView.show();
        }
        reader.readAsDataURL(file);
      } else {
        fileInput.val(''); 
        imgView.attr('src', defaultImg).show();
        alert(gon.img_type_error);
      }
    } else {
      imgView.attr('src', defaultImg).show();
    }
  });

  $('#new_episode').on('submit', function(event) {
    if (!fileInput.val()) {
      event.preventDefault();
      alert(gon.img_upload_error);
    }
  });
}

document.addEventListener('turbo:load', function() {
  initializeJQuery();
});
