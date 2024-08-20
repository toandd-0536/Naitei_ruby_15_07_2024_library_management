document.addEventListener('turbo:load', function() { 
  $('#searchEpisode').on('keyup', function() {
    var searchValue = $(this).val();

    if (searchValue === '') {
        $('#list-result').html('');
        return;
      }

    $.ajax({
      url: '/search_ajax',
      method: 'GET',
      data: { search: searchValue },
      dataType: 'script',
      success: function(response) {
      },
      error: function(response) {
        console.log('Error:', response);
      }
    });
  });
})
