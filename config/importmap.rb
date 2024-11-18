# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "@stimulus-components/clipboard", to: "@stimulus-components--clipboard.js" # @5.0.0
pin "@splidejs/splide", to: "@splidejs--splide.js" # @4.1.4
pin "@stimulus-components/read-more", to: "@stimulus-components--read-more.js" # @5.0.0
# pin "flatpickr" # @4.6.13
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/flatpickr.js"
pin "flatpickr/dist/l10n/fr.js", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/l10n/fr.js"
