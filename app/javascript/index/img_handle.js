function initializeJQuery() {
  const fileInput = $('#episode_thumb');
  const imgView = $('.img-view img');
  const currentImg = $('.img-view').attr('src');
  
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
        imgView.attr('src', '').hide();
      }
    } else {
      imgView.attr('src', '').hide();
    }
  });
}

document.addEventListener('turbo:load', function() {
  initializeJQuery();
});
