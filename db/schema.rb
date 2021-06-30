# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_21_234429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address_objects", primary_key: "aoid", id: :uuid, default: -> { "gen_random_uuid()" }, comment: " содержит коды, наименования и типы адресообразующих элементов.", force: :cascade do |t|
    t.uuid "previd", comment: "Идентификатор записи связывания с предыдушей исторической записью"
    t.uuid "nextid", comment: "Идентификатор записи  связывания с последующей исторической записью"
    t.uuid "aoguid", comment: "Глобальный уникальный идентификатор адресообразующего элемента"
    t.uuid "parentguid", comment: "Идентификатор элемента родительского элемента"
    t.string "formalname", limit: 120, comment: "Формализованное наименование"
    t.string "shortname", limit: 10, comment: "Краткое наименование типа элемента"
    t.string "offname", limit: 120, comment: "Официальное наименование"
    t.string "postalcode", limit: 6, comment: "Почтовый индекс"
    t.string "okato", limit: 11, comment: "ОКАТО"
    t.string "oktmo", limit: 11, comment: "ОКТМО"
    t.integer "aolevel", limit: 2, comment: "Уровень адресообразующего элемента "
    t.string "regioncode", limit: 2, comment: "Код региона"
    t.string "autocode", limit: 1, comment: "Код автономии"
    t.string "areacode", limit: 3, comment: "Код района"
    t.string "citycode", limit: 3, comment: "Код города"
    t.string "ctarcode", limit: 3, comment: "Код внутригородского района"
    t.string "placecode", limit: 3, comment: "Код населенного пункта"
    t.string "streetcode", limit: 4, comment: "Код улицы"
    t.string "extrcode", limit: 4, comment: "Код дополнительного адресообразующего элемента"
    t.string "sextcode", limit: 3, comment: "Код подчиненного дополнительного адресообразующего элемента"
    t.string "code", limit: 17, comment: "Код адресообразующего элемента одной строкой с признаком актуальности из КЛАДР 4.0."
    t.string "plaincode", limit: 15, comment: "Код адресообразующего элемента из КЛАДР 4.0 одной строкой без признака актуальности (последних двух цифр)"
    t.integer "currstatus", comment: "Статус актуальности КЛАДР 4 (последние две цифры в коде)"
    t.string "ifnsfl", limit: 4, comment: "Код ИФНС ФЛ"
    t.string "terrifnsfl", limit: 4, comment: "Код территориального участка ИФНС ФЛ"
    t.string "ifnsul", limit: 4, comment: "Код ИФНС ЮЛ"
    t.string "terrifnsul", limit: 4, comment: "Код территориального участка ИФНС ЮЛ"
    t.boolean "actstatus", comment: "Статус актуальности адресообразующего элемента ФИАС. Актуальный адрес на текущую дату. Обычно последняя запись об адресообразующем элементе. 0 – Не актуальный, 1 - Актуальный"
    t.boolean "centstatus", comment: "Статус центра"
    t.date "startdate", comment: "Начало действия записи"
    t.date "enddate", comment: "Окончание действия записи"
    t.date "updatedate", comment: "Дата  внесения (обновления) записи"
    t.integer "operstatus", comment: "Статус действия над записью – причина появления записи (см. описание таблицы OperationStatus)"
    t.boolean "lifestatus", comment: "Признак действующего адресообразующего элемента: 0 – недействующий адресный элемент, 1 - действующий"
    t.uuid "normdoc", comment: "Внешний ключ на нормативный документ"
    t.string "cadnum", limit: 100, comment: "Кадастровый номер"
    t.integer "divtype", limit: 2, comment: "Тип деления: 0 – не определено \n      1 – муниципальное 2 – административное"
    t.string "plancode", limit: 4, comment: "Код элемента планировочной структуры"
    t.index "to_tsvector('russian'::regconfig, (((formalname)::text || ' '::text) || (shortname)::text))", name: "ao_fts_idx", using: :gin
    t.index ["actstatus"], name: "index_address_objects_on_actstatus"
    t.index ["aoguid"], name: "index_address_objects_on_aoguid"
    t.index ["aolevel"], name: "index_address_objects_on_aolevel"
    t.index ["formalname"], name: "index_address_objects_on_formalname"
    t.index ["parentguid"], name: "index_address_objects_on_parentguid"
    t.index ["regioncode"], name: "index_address_objects_on_regioncode"
    t.index ["shortname"], name: "index_address_objects_on_shortname"
  end

  create_table "houses", primary_key: "houseid", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "HOUSES  Сведения по номерам домов", force: :cascade do |t|
    t.uuid "aoguid", comment: "Глобальный уникальный идентификатор записи родительского объекта (улицы, города, населенного пункта и т.п.)"
    t.string "buildnum", limit: 50, comment: "Номер корпуса"
    t.date "enddate", comment: "Окончание действия записи"
    t.integer "eststatus", limit: 2, comment: "Признак владения. Принимает значение:0 – Не определено,1 – Владение,2 – Дом,3 – Домовладение"
    t.uuid "houseguid", comment: "Глобальный уникальный идентификатор дома"
    t.string "housenum", limit: 20, comment: "Номер дома"
    t.integer "statstatus", limit: 2, comment: "Состояние дома"
    t.string "ifnsfl", limit: 4, comment: "Код ИФНС ФЛ"
    t.string "ifnsul", limit: 4, comment: "Код ИФНС ЮЛ"
    t.string "okato", limit: 11, comment: "ОКАТО"
    t.string "oktmo", limit: 11, comment: "ОКТМО"
    t.string "postalcode", limit: 6, comment: "Почтовый индекс"
    t.date "startdate", comment: "Начало действия записи"
    t.string "strucnum", limit: 50, comment: "Номер строения"
    t.integer "strstatus", limit: 2, comment: "Признак строения.Принимает значение:0 – Не определено,1 – Строение,2 – Сооружение,3 – Литер"
    t.string "terrifnsfl", limit: 4, comment: "Код территориального участка ИФНС ФЛ"
    t.string "terrifnsul", limit: 4, comment: "Код территориального участка ИФНС ЮЛ"
    t.date "updatedate", comment: "Дата  внесения (обновления) записи"
    t.uuid "normdoc", comment: "Внешний ключ на нормативный документ"
    t.uuid "string", comment: "Внешний ключ на нормативный документ"
    t.integer "counter", comment: "Счетчик записей домов для КЛАДР 4"
    t.string "cadnum", limit: 100, comment: "Кадастровый номер"
    t.integer "divtype", limit: 2, comment: "Тип деления: 0 – не определено \n      1 – муниципальное 2 – административное"
    t.index ["aoguid"], name: "index_houses_on_aoguid"
    t.index ["buildnum"], name: "index_houses_on_buildnum"
    t.index ["enddate"], name: "index_houses_on_enddate"
    t.index ["eststatus"], name: "index_houses_on_eststatus"
    t.index ["houseguid"], name: "index_houses_on_houseguid"
    t.index ["housenum"], name: "index_houses_on_housenum"
    t.index ["strstatus"], name: "index_houses_on_strstatus"
    t.index ["strucnum"], name: "index_houses_on_strucnum"
  end

end
