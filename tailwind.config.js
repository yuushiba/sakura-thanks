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
        // 以下を追加
        "success": "#36D399",  // 成功時の色
        "error": "#F87272",    // エラー時の色
        "warning": "#FBBD23",  // 警告時の色
        "info": "#3ABFF8"      // 情報時の色
      }
    }]
  }
}
