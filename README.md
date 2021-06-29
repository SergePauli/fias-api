# Create REST-API service for address search in the FIAS database   

Ruby on Rails project find russia's address with FIAS or KLADR code via API from FIAS database

* Ruby version 2.7.3 for script running
* Postgres server for Database

* System dependencies
  100 Gb free disk space 
  4Gb RAM 


* Configuration
  config/puma.rb - server ports, thread options config

* Database creation
  1. run 'rails db:create' in command line
  2. run 'rails db:migrate' in command line  
  

* Database initialization
  1. just put in 'dbf' folder actual updates or fullbase in dbf format from 
  https://fias.nalog.ru/
  2. run 'rails db:seed' in command line, And then, depending on the size of the input data, you will have to wait


