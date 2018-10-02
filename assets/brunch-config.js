exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
          "js/app.js":/^(js|node_modules|vendor)/,
          "js/pagination/pagination.js": "single-page/pagination/pagination.js",
          "js/pagination/pagination-images.js": "single-page/pagination/pagination-images.js",
          "js/notification/notification.js": "single-page/notification/notification.js",
          "js/switchable-input/switchable-input.js": "single-page/switchable-input/switchable-input.js",
          "js/socket/admin-socket.js": "single-page/socket/admin-socket.js",
          "js/socket/user-socket.js": "single-page/socket/user-socket.js",
          "vendor/jquery.scrollUp/jquery.scrollUp.min.js": "single-page/jquery.scrollUp.min.js",
          "vendor/slicknav/jquery.slicknav.min.js": "node_modules/slicknav/dist/jquery.slicknav.min.js",
          "vendor/slick-carousel/slick.min.js":"node_modules/slick-carousel/slick/slick.min.js",
          "vendor/owl-carousel/owl.carousel.min.js":"node_modules/owl.carousel2/dist/owl.carousel.min.js",
          "vendor/social-share/jquery.floating-social-share.min.js":"node_modules/jquery-floating-social-share/dist/jquery.floating-social-share.min.js"
      },
    },
    stylesheets: {
      joinTo: {
          "css/app.css": "css/app.scss",
          "css/blog-theme-index.css": "single-page/blog-theme/blog-theme-index.css",
          "css/blog-header-navigation.css": "single-page/blog-theme/blog-header-navigation.css",
          "vendor/bulma/bulma-extensions.min.css": "vendor/css/bulma-extensions.min.css",
          "vendor/font/font-awesome.min.css": "vendor/css/font-awesome.min.css",
          "vendor/slick-carousel/slick.css":"node_modules/slick-carousel/slick/slick.css",
          "vendor/owl-carousel/assets/owl.carousel.min.css":"node_modules/owl-carousel2/dist/assets/owl.carousel.min.css",
          "vendor/owl-carousel/assets/owl.theme.default.min.css":"node_modules/owl-carousel2/dist/assets/owl.theme.default.min.css",
          "vendor/slicknav/slicknav.min.css":"node_modules/slick-carousel/dist/slicknav.min.css",
          "vendor/social-share/jquery.floating-social-share.min.css":"node_modules/jquery-floating-social-share/dist/jquery.floating-social-share.min.css"
      },
      order: {
          after: ["css/app.scss"],
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
        "vendor/animate-css": [
            "node_modules/animate.css/animate.min.css"
        ],
        "vendor/jquery.easing": [
            "node_modules/jquery.easing/jquery.easing.min.js"
        ],
        "vendor/slicknav": [
            "node_modules/slicknav/dist"
        ],
        "vendor/owl-carousel": [
            "node_modules/slicknav/dist",
        ],
        "vendor/social-share": [
            "node_modules/jquery-floating-social-share/dist"
        ],
        "vendor/notify": [
            "vendor/js/notify.min.js"
        ]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"],
      "js/pagination/pagination.js": ["single-page/pagination/pagination"],
      "js/pagination/pagination-images.js": ["single-page/pagination/pagination-images"],
      "js/notification/notification.js": ["single-page/notification/notification"],
      "js/switchable-input/switchable-input.js": ["single-page/switchable-input/switchable-input"],
      "js/socket/admin-socket.js": ["single-page/socket/admin-socket"],
      "js/socket/user-socket.js": ["single-page/socket/user-socket"],
      "vendor/jquery.scrollUp/jquery.scrollUp.min.js": ["single-page/jquery.scrollUp.min.jp"],
      "vendor/slick-carousel/slick.min.js": ["node_modules/slick-carousel/slick/slick.min.js"],
      "vendor/slick-carousel/owl-carousel.min.js": ["node_modules/owl-carousel2/dist/owl-carousel.min.js"],
      "vendor/slicknav/jquery.slicknav.min.js": ["node_modules/slicknav/dist/jquery.slicknav.min.js"],
      "vendor/social-share/jquery.floating-social-share.min.js": ["node_modules/jquery-floating-social-share/dist/jquery.floating-social-share.min.js"]
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
