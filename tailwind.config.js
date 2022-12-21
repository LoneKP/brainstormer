const defaultTheme = require('tailwindcss/defaultTheme')
module.exports = {
  mode: "jit",
  purge: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  theme: {
    scale: {
      '0': '0',
      '25': '.25',
      '50': '.5',
      '75': '.75',
      '90': '.9',
      '95': '.95',
      '100': '1',
      '105': '1.05',
      '110': '1.1',
      '125': '1.25',
      '150': '1.5',
      '200': '2',
      '250': '2.5',
      '300': '3',
      '400': '4',
      '500': '5',
    },
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
      keyframes: {
        "ping-once": {
          "0%, 100%": { transform: "scale(1.3)" }
        },
        openmenu: {
          // initial position
              '0%': {right:  '-300px'},
          // final position
              '100%': {right:  '0px'}
          },
      },
      animation: {
        "ping-once": 'ping-once ease 200ms 1',
        "openmenu": "openmenu 0.15s ease-in-out",
      },
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
        'pinky': '#feeceb',
        'darker-pinky': '#DECFCC',
        'blurple': '#312783',
        'blurple-gray': '#f4f2f7',
        'dark-blurple': '#28206e',
        'darker-blurple': '#211b5c',
        'darky': '#2f2f41',
        'light-gray': '#d8d8d8',
        'lighter-gray': '#9B9B9B',
        'yellowy': '#E5D151',
        'dark-yellowy': '#d1bd3d',
        'light-yellowy': '#FFE35F',
        'post-it-yellowy': '#F6E573',
        'post-it-yellowy-dark': '#ebd96c',
        'post-it-yellowy-darker': '#d6c660',
        'post-it-yellowy-90': 'rgba(246,229,115,0.9)',
        'post-it-yellowy-80': 'rgba(246,229,115,0.8)',
        'post-it-yellowy-70': 'rgba(246,229,115,0.7)',
        'post-it-yellowy-60': 'rgba(246,229,115,0.6)',
        'post-it-yellowy-50': 'rgba(246,229,115,0.5)',
        'post-it-yellowy-40': 'rgba(246,229,115,0.4)',
        'post-it-yellowy-30': 'rgba(246,229,115,0.3)',
        'post-it-yellowy-20': 'rgba(246,229,115,0.2)',
        'post-it-yellowy-10': 'rgba(246,229,115,0.1)',
        'greeny': '#027540',
        'dark-greeny': '#006637',
        'darker-greeny': '#005c31',
        'greeny-gray': '#dce8e3',
        'reddy': '#DC6660',
        'purply': '#A260DC',
        'wine': '#750202',
        'wine-light': '#ba7f80',
        'light-greeny': '#DBFFC1',
        'light-greeny-darker': '#cff2b6',
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
  variants: {
    extend: {
      backgroundColor: ['active'],
      animation: ['hover'],
      visibility: ["group-hover"],
    }
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/aspect-ratio'),
  ]
}