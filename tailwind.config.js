const defaultTheme = require('tailwindcss/defaultTheme')
module.exports = {
  theme: {
    fontSize: {
      'xs': '.75rem',
      'sm': '.875rem',
      'base': '1rem',
      'lg': '1.125rem',
      'xl': '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': '2.25rem',
      '5xl': '3rem',
      '6xl': '4rem',
      '7xl': '5rem',
      '8xl': '6rem',
    },
    extend: {
      height: theme => ({
        "screen/2": "50vh",
        "screen/3": "calc(100vh / 3)",
        "screen/4": "calc(100vh / 4)",
        "screen/5": "calc(100vh / 5)",
      }),
      width: {
        "1/7": "14.2857143%",
        "2/7": "28.5714286%",
        "3/7": "42.8571429%",
        "4/7": "57.1428571%",
        "5/7": "71.4285714%",
        "6/7": "85.7142857%",
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
        mono: ['IBM Plex Mono', ...defaultTheme.fontFamily.mono]
      },
      colors: {
        'plum': '#fb6484',
        'blurple': '#312783',
        'darky': '#2f2f41',
        'light-gray': '#d8d8d8',
        'lighter-gray': '#9B9B9B',
        'yellowy': '#E5D151',
        'light-yellowy': '#FFE35F',
        'post-it-yellowy': '#F6E573',
        'pinkish': '#E71EA3',
        'greeny': '#027540',
        'reddy': '#DC6660',
        'purply': '#A260DC',
        'wine': '#750202',
        'wine-light': '#ba7f80',
        'light-greeny': '#DBFFC1',
        'light-blurple': '#DFD8FF',
        'beigy': '#FBEDEB'
      },
      maxWidth: theme => ({
        'screen-sm': theme('screens.sm'),
        'screen-md': theme('screens.md'),
        'screen-lg': theme('screens.lg'),
        'screen-xl': theme('screens.xl'),
      })
    },
  },
  plugins: [
    require('@tailwindcss/ui'),
  ]
}