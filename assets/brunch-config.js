exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
          "js/app.js":/^(js|node_modules|vendor)/,
          "js/pagination.js": "single-page/pagination.js",
          "js/pagination-implement.js": "single-page/pagination-implement.js"
      },
      order: {
        before: [
          "vendor/js/jquery-3.3.1.js",
          "vendor/js/bootstrap.min.js"
        ]
      }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
          after: [ "css/app.scss"],
          before: ["vendor/css"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor", "fonts", "single-page"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
        plugins: ['transform-async-to-generator', 'babel-polyfill'],
        // Do not use ES6 compiler in vendor code
        ignore: [/vendor/]
    },
    sass: {
        mode: 'native',
        options: {
            includePaths: [
                "node_modules/bulma",
                "node_modules/bulma-extensions/src/sass",
                "node_modules/font-awesome"
            ]
        }
    },
    copycat: { // to js and css folders
        "vendor/fine-uploader": [
            "node_modules/fine-uploader/jquery.fine-uploader"
        ],
        "vendor/image-picker": [
            "node_modules/image-picker/image-picker"
        ],
        "vendor/jquery-modal": [
            "node_modules/jquery-modal/jquery.modal.min.css",
            "node_modules/jquery-modal/jquery.modal.min.js"
        ]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"],
      "js/pagination.js": ["single-page/pagination"],
      "js/pagination-implement.js": ["single-page/pagination-implement"]
    }
  },

  npm: {
    globals: {
      $: 'jquery',
      jQuery: 'jquery',
      QuillDeltaToHtmlConverter: 'quill-delta-to-html'
    }
  }
};
