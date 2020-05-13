const defaultTheme = require('tailwindcss/defaultTheme')
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
        mono: ['IBM Plex Mono', ...defaultTheme.fontFamily.mono]
      },
      colors: {
        'plum': '#fb6484',
        'blurple': '#312783',
        'darky': '#2f2f41',
        'light-gray': '#d8d8d8',
        'yellowy': '#E5D151',
        'pinkish': '#E71EA3',
        'greeny': '#027540',
        'reddy': '#DC6660',
        'purply': '#A260DC',
        'wine': '#750202'
      },
    },
  },
  plugins: [
    require('@tailwindcss/ui'),
  ]
}