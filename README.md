# Create REST-API service for address search in the FIAS    

## Ruby on Rails project oneline searching valid russia's address via API from FIAS 
_(Проект реализующий REST-API сервис для получения валидных адресов из ФИАС посредством поисковой строки и некоторых параметров фильтрации)_

### Compatibility
  fias_api tested to work with:
* Ruby version 2.7.3 for script running
* PostgreSQL13 as Database

### Configuration
  config/puma.rb - defaul server ports, thread options, environment config
  _(тут можно настроить порт, режим запуска сервиса)_

    max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
    #Specifies the port that Puma will listen on to receive requests; default is 3000.
    port ENV.fetch("PORT") { 3000 }
    # Specifies the `environment` that Puma will run in.
    # default is production (test, development)
    environment ENV.fetch("RAILS_ENV") { "production" }

  config/application.rb set default pagination params _(параметры пагинации по умолчанию)_  

    # the maximum number of records to be received is set by the user
    config.max_limit = 201
    # default number of records to be received
    config.default_limit = 25

  config/database.yml set database connection params _(настройка на базу данных)_
  > the user must have the rights to create a database

    default: &default
    adapter: postgresql
    encoding: unicode  
    pool: 5
    timeout: 5000
    username: rails2  #change it
    password: qwerty123 #change it
    host: localhost


### Initialization
  1. download the fulldatabase in dbf format from https://fias.nalog.ru/  to the folder `dbf/` _(грузим полную базу ФИАС в dbf)_  
  
  2. run `bin/setup`, and then, depending on the size of the input data, you will have to wait, while the database is being created from the imported files _(запускаем создание базы, и импорт данных)_
    
    $ bin/setup

  3. start server:
    
    $ rails s  

  4. in order to save disk space, delete all the files in the folder `dbf/` _(чистим папку от dbf-файлов)_ 

### Getting FIAS updates
  1. download the updates in dbf format from https://fias.nalog.ru/  to the folder `dbf/` _(грузим обновления ФИАС в dbf)_ 
  2. stop server (ctrl+c) and run `rails db:seed`, and then, depending on the size of the input data, you will have to wait _(запускаем импорт данных)_

    $ rails db:seed

  3. start server:
    
    $ rails s  

  4. in order to save disk space, delete all the files in the folder `dbf/` _(чистим папку от dbf-файлов)_   

 ### Basic API Usage
  * type of request: `GET`  
  * url of the service, by default: `http://<mydomen.com>/fias`
  * available parameters:
    * `query` - search query (search for) _(строка запроса)_
    * `searchBar`  - fulltext OneLineString search mode: `1` is ON, other - OFF
    _(режим свободного поиск одной строкой)_
    * `level` - filter address level as (`region`,`district`,`city`,`territory`, `town`,`street`, `building`) 
    * `parent` - filter by aogoid of parent address object as `UUID` _(выбрать только дочерние элементы для `parent`)_
    * `regionID` - filter by region code like (`24`,`07`..)
    * `limit`,`offset` - pagination _(задают смещение и размер страницы результатов)_
    * `total_found` - to include number of founded items: `1` is ON, other - OFF
    _(включить общее число найденных объектов)_
    * `withParent`, `fullInfo` - additional info modes params: `1` is ON, other - OFF _(включить вышестоящие элементы адреса, включить полную информаию из ФИАС)_
  
### Examples
  Auto-completion for entering an address in one line:

    request:
    http://localhost:3000/fias?searchBar=1&total_found=1&query=благовещенск,театральная,6

    response:
    {
      "status": "SUCCESS",
      "message": "1 entries received",
      "total_found": 1,
      "data": [
        {
          "AOGUID": "985e90b6-99ca-4d18-abde-bd09ce01100f",
          "HouseGUID": "0afe10c4-bbfb-4ba2-bab8-85de58c27856",
          "name": "д. 65",
          "streetAddressLine": "Амурская обл, Благовещенск г, Театральная ул, д. 65",
          "rustype": "д.",
          "level": "building"
        }
      ]
    }

  Auto-completion by cities of the Amur region

    request:
    http://localhost:3000/fias?parent=844a80d6-5e31-4017-b422-4d9c01e9942c&level=city&total_found=1

    response:
    {
      "status": "SUCCESS",
      "message": "9 entries received",
      "total_found": 9,
      "data": [
        {
          "AOGUID": "c528e99b-7e81-4290-9cda-8713884472a5",
          "parentGUID": "844a80d6-5e31-4017-b422-4d9c01e9942c",
          "code": "2800000300000",
          "name": "Белогорск",
          "shortname": "г",
          "streetAddressLine": "Амурская обл, Белогорск г",
          "level": "City"
        },
        {
          "AOGUID": "8f41253d-6e3b-48a9-842a-25ba894bd093",
          "parentGUID": "844a80d6-5e31-4017-b422-4d9c01e9942c",
          "code": "2800000100000",
          "name": "Благовещенск",
          "shortname": "г",
          "streetAddressLine": "Амурская обл, Благовещенск г",
          "level": "City"
        },
        {
          "AOGUID": "581855f4-f0bc-44a5-a36e-a298279f9ec4",
          "parentGUID": "844a80d6-5e31-4017-b422-4d9c01e9942c",
          "code": "2800000400000",
          "name": "Зея",
          "shortname": "г",
          "streetAddressLine": "Амурская обл, Зея г",
          "level": "City"
        },
        {
          "AOGUID": "16de8821-04f5-4239-b33b-739f8eff7c88",
          "parentGUID": "844a80d6-5e31-4017-b422-4d9c01e9942c",
          "code": "2800000800000",
          "name": "Прогресс",
          "shortname": "пгт",
          "streetAddressLine": "Амурская обл, Прогресс пгт",
          "level": "City"
        },
        ...  
