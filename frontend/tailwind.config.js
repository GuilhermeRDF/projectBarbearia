/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        barber: {
          dark: '#121214',
          gray: '#202024',
          light: '#e1e1e6',
          gold: '#d4af37',
          goldHover: '#b5952f'
        }
      }
    },
  },
  plugins: [],
}