const defaultTheme = require('tailwindcss/defaultTheme')
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'plum': '#fb6484',
        'blurple': '#6c62ff',
        'darky': '#2f2f41',
        'yellowy': '#fbe603',
        'pinkish': '#E71EA3'
      },
    },
  },
  plugins: [
    require('@tailwindcss/ui'),
  ]
}