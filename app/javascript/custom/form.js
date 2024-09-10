document.addEventListener('DOMContentLoaded', function() {
  var form = document.getElementById('advancedSearchForm');
  var generateReportButton = document.getElementById('generateReportButton');
  var advancedSearchModal = new bootstrap.Modal(document.getElementById('advancedSearchModal'));

  function resetForm() {
    form.reset();

    var multiSelects = form.querySelectorAll('select[multiple]');
    multiSelects.forEach(function(select) {
      for (var i = 0; i < select.options.length; i++) {
        select.options[i].selected = false;
      }

      const hiddenInput = select.previousElementSibling;
      hiddenInput.value = '';
    });
  }

  if (form) {
    document.getElementById('resetButton').addEventListener('click', function() {
      resetForm()
    });

    if (generateReportButton) {
      generateReportButton.addEventListener('click', function() {
        var reportUrl = generateReportButton.dataset.url;
        form.action = reportUrl;
        form.submit();

        resetForm()

        advancedSearchModal.hide();
    });
    }
  }
});
