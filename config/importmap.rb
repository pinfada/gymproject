# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "el-transition", to: "https://ga.jspm.io/npm:el-transition@0.0.7/index.js"
pin "geolib", to: "https://ga.jspm.io/npm:geolib@3.3.3/es/index.js"
pin "lodash-es", to: "https://ga.jspm.io/npm:lodash-es@4.17.21/lodash.js"
pin "sweetalert2", to: "https://ga.jspm.io/npm:sweetalert2@11.6.14/dist/sweetalert2.all.js"
pin "vanillajs-datepicker", to: "https://ga.jspm.io/npm:vanillajs-datepicker@1.2.0/js/main.js"
pin_all_from "app/javascript/controllers", under: "controllers"