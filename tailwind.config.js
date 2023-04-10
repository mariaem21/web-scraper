module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/stylesheets/*.css',
  ],  
  safelist: [
    {
      pattern: /./,
      variants: ['sm', 'md', 'lg', 'xl', '2xl'],
    },
    ],
}
