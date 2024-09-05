document.addEventListener('DOMContentLoaded', function() {
  var form = document.getElementById('advancedSearchForm');

  if (form) {
    document.getElementById('resetButton').addEventListener('click', function() {
      form.reset();

      var multiSelects = form.querySelectorAll('select[multiple]');
      multiSelects.forEach(function(select) {
        for (var i = 0; i < select.options.length; i++) {
          select.options[i].selected = false;
        }

        const hiddenInput = select.previousElementSibling;
        hiddenInput.value = '';
      });
    });
  }
});
