# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/custom", under: "custom"
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.8/dist/esm/index.js"
pin "slim-select", to: "https://ga.jspm.io/npm:slim-select@2.8.2/dist/slimselect.js"
