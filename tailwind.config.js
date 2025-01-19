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
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [{
      sakura: {
        "primary": "#DD7594",
        "base-100": "#E8EBF2",
        "primary-content": "#FFFFFF",
        "neutral": "#89AAD3",
        "neutral-content": "#FFFFFF",
      }
    }]
  }
}
