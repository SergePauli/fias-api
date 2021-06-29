#Create table of AddressObjects FIAS information version later 09-06-2016
#All field names must be identical to the column names in ADRROB**.DBF files
# downloaded from the site fias.nalog.ru
class CreateAddressObjects < ActiveRecord::Migration[6.1]
  def change
    create_table "address_objects", primary_key: :aoid, id: :uuid, comment: " содержит коды, наименования и типы адресообразующих элементов.", force: :cascade do |t|
      t.uuid :previd, comment: "Идентификатор записи связывания с предыдушей исторической записью"
      t.uuid :nextid, comment: "Идентификатор записи  связывания с последующей исторической записью"
      t.uuid :aoguid, index: true, comment: "Глобальный уникальный идентификатор адресообразующего элемента"
      t.uuid :parentguid, index: true, comment: "Идентификатор элемента родительского элемента"
      t.string :formalname, limit: 120, index: true, comment: "Формализованное наименование"
      t.string :shortname, limit: 10, index: true, comment: "Краткое наименование типа элемента"
      t.string :offname, limit: 120, comment: "Официальное наименование"
      t.string :postalcode, limit: 6, comment: "Почтовый индекс"
      t.string :okato, limit: 11, comment: "ОКАТО"
      t.string :oktmo, limit: 11, comment: "ОКТМО"
      t.integer :aolevel, limit: 2, index: true, comment: "Уровень адресообразующего элемента "
      t.string :regioncode, limit: 2, index: true, comment: "Код региона"
      t.string :autocode, limit: 1, comment: "Код автономии"
      t.string :areacode, limit: 3, comment: "Код района"
      t.string :citycode, limit: 3, comment: "Код города"
      t.string :ctarcode, limit: 3, comment: "Код внутригородского района"
      t.string :placecode, limit: 3, comment: "Код населенного пункта"
      t.string :streetcode, limit: 4, comment: "Код улицы"
      t.string :extrcode, limit: 4, comment: "Код дополнительного адресообразующего элемента"
      t.string :sextcode, limit: 3, comment: "Код подчиненного дополнительного адресообразующего элемента"
      t.string :code, limit: 17, comment: "Код адресообразующего элемента одной строкой с признаком актуальности из КЛАДР 4.0."
      t.string :plaincode, limit: 15, comment: "Код адресообразующего элемента из КЛАДР 4.0 одной строкой без признака актуальности (последних двух цифр)"
      t.integer :currstatus, comment: "Статус актуальности КЛАДР 4 (последние две цифры в коде)"
      t.string :IFNSFL, limit: 4, comment: "Код ИФНС ФЛ"
      t.string :TERRIFNSFL, limit: 4, comment: "Код территориального участка ИФНС ФЛ"
      t.string :IFNSUL, limit: 4, comment: "Код ИФНС ЮЛ"
      t.string :TERRIFNSUL, limit: 4, comment: "Код территориального участка ИФНС ЮЛ"
      t.boolean :actstatus, index: true, comment: "Статус актуальности адресообразующего элемента ФИАС. Актуальный адрес на текущую дату. Обычно последняя запись об адресообразующем элементе. 0 – Не актуальный, 1 - Актуальный"
      t.boolean :centstatus, comment: "Статус центра"
      t.date :startdate, comment: "Начало действия записи"
      t.date :enddate, comment: "Окончание действия записи"
      t.date :updatedate, comment: "Дата  внесения (обновления) записи"
      t.integer :operstatus, comment: "Статус действия над записью – причина появления записи (см. описание таблицы OperationStatus)"
      t.boolean :lifestatus, comment: "Признак действующего адресообразующего элемента: 0 – недействующий адресный элемент, 1 - действующий"
      t.uuid :normdoc, comment: "Внешний ключ на нормативный документ"
      t.string :cadnum, limit: 100, comment: "Кадастровый номер"
      t.integer :divtype, limit: 1, comment: "Тип деления: 0 – не определено \n      1 – муниципальное 2 – административное"
      t.string :plancode, limit: 4, comment: "Код элемента планировочной структуры"
      t.index "to_tsvector('russian'::regconfig, (((formalname)::text || ' '::text) || (shortname)::text))", name: "ao_fts_idx", using: :gin
    end
  end
end
