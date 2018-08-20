exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
          "js/app.js":/^(js|node_modules|vendor)/,
          "js/pagination/pagination.js": "single-page/pagination/pagination.js",
          "js/pagination/pagination-images.js": "single-page/pagination/pagination-images.js",
          "js/socket/admin-socket.js": "single-page/socket/admin-socket.js",
          "js/socket/user-socket.js": "single-page/socket/user-socket.js",
          "vendor/jquery.scrollUp/jquery.scrollUp.min.js": "single-page/jquery.scrollUp.min.js",
          "vendor/slicknav/jquery.slicknav.min.js": "single-page/slicknav/jquery.slicknav.min.js"
      },
      order: {
        before: [
          "vendor/js/jquery-3.3.1.js",
          "vendor/js/bootstrap.min.js"
        ]
      }
    },
    stylesheets: {
      joinTo: {
          "css/app.css": "css/app.scss",
          "css/blog-theme-index.css": "single-page/blog-theme/blog-theme-index.css",
          "vendor/slicknav/slicknav.min.css": "single-page/slicknav/slicknav.min.css",
          "vendor/bulma/bulma.extensions.css": "css/vendor/bulma-extensions.min.css",
          "vendor/font/font-awesome.min.css": "vendor/css/font-awesome.min.css"
      },
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
        ],
        "vendor/jquery-migrate": [
            "node_modules/jquery-migrate/dist/jquery-migrate.min.js"
        ],
        "vendor/animate-css": [
            "node_modules/animate.css/animate.min.css"
        ],
        "vendor/owl": [
            "node_modules/owl.carousel/dist/assets",
            "node_modules/owl.carousel/dist/owl.carousel.min.js"
        ],
        "vendor/jquery.easing": [
            "node_modules/jquery.easing/jquery.easing.min.js"
        ],
        "vendor/jquery.scrollUp": [
            "single-page/jquery.scrollUp.min.js"
        ]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"],
      "js/pagination/pagination.js": ["single-page/pagination/pagination"],
      "js/pagination/pagination-images.js": ["single-page/pagination/pagination-images"],
      "js/socket/admin-socket.js": ["single-page/socket/admin-socket"],
      "js/socket/user-socket.js": ["single-page/socket/user-socket"]
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
