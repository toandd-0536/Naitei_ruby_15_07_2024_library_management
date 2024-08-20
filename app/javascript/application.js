import '@hotwired/turbo-rails'
import 'controllers'
import './settings/jquery.min'
import './settings/isotope.min'
import './settings/owl-carousel'
import './settings/counter'
import './settings/custom'
import 'bootstrap'
import 'custom/admin'
import './index/search'

document.addEventListener("turbo:load", function () {
  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  var dropdownElementList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="dropdown"]')
  );
  var dropdownList = dropdownElementList.map(function (dropdownEl) {
    return new bootstrap.Dropdown(dropdownEl);
  });
});
