module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        'inter': ['Inter', 'sans-serif'],
      },
      colors: {
        'header-footer': '#89AAD3', // rgbから16進数に変更
        'main-text': '#073472',
        'accent': '#DD7594',
        'button-blue': '#4981CF',
      }
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [{
      sakura: {
        "primary": "#DD7594",
        "base-100": "#E8EBF2",
        "primary-content": "#FFFFFF",
      }
    }]
  }
}
