
source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0.1'
# Use sqlite3 as the database for Active Record
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
group :development do 
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rvm'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano3-puma'
  gem 'capistrano3-nginx'
  gem 'capistrano-upload-config'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Maquetación y efectos dinámicos
gem 'simple_form'
gem 'font-awesome-sass'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'jquery-ui-rails'
gem 'rails-jquery-autocomplete'

# Autenticación y control
gem 'devise'
gem 'cancancan', '~> 1.15'


# Pasar datos desde el controlador a el coffeescript con esta gema
# https://github.com/gazay/gon
gem 'gon'

# Grupo de gemas para exportar a excel  
gem 'axlsx', '2.1.0.pre'
gem 'axlsx_rails'

# Gema para exportar a PDF
gem 'wicked_pdf'

# Formato de la moneda
gem 'money'

# Ransack para buscar por todas las columnas
gem 'ransack', github: 'activerecord-hackery/ransack'

# Es una dependencia de premailer-rails y esta gema sirve para tratar documentos html, xml
gem 'nokogiri'

# Esta gema dá el estilo a los correos sin tener que poner style en la misma linea de las etiquetas
# html, como tendría que ser para dar estilo.
gem 'premailer-rails'


ruby "2.3.1"
