// tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        'inter': ['Inter', 'sans-serif'],
      },
      colors: {
        'sakura-bg': '#E8EBF2',
        'sakura-accent': '#B9AAD3',
      }
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        sakura: {
          "primary": "#B9AAD3",
          "secondary": "#E8EBF2",
          "accent": "#B9AAD3",
          "neutral": "#B9AAD3",
          "base-100": "#E8EBF2",
          "base-200": "#B9AAD3",
          "base-300": "#B9AAD3",
          "base-content": "#B9AAD3",
          "neutral-content": "#FFFFFF",
          "--rounded-box": "1rem",
          "--rounded-btn": "0.5rem",
          "--rounded-badge": "1.9rem",
        },
      },
    ],
  },
}
