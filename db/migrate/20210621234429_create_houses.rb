#Create table of houses FIAS information version later 09-06-2016
#All field names must be identical to the column names in HOUSE**.DBF files
# downloaded from the site fias.nalog.ru
class CreateHouses < ActiveRecord::Migration[6.1]
  def change
    create_table :houses, primary_key: :houseid, id: :uuid, comment: "HOUSES  Сведения по номерам домов", force: :cascade do |t|
      t.uuid :aoguid, index: true, :limit => 36, comment: "Глобальный уникальный идентификатор записи родительского объекта (улицы, города, населенного пункта и т.п.)"
      t.column :buildnum, :string, :limit => 50, index: true, comment: "Номер корпуса"
      t.column :enddate, :date, index: true, comment: "Окончание действия записи"
      t.column :eststatus, :integer, :limit => 1, index: true, comment: "Признак владения. Принимает значение:0 – Не определено,1 – Владение,2 – Дом,3 – Домовладение"
      t.uuid :houseguid, index: true, :limit => 36, comment: "Глобальный уникальный идентификатор дома"
      t.column :housenum, :string, :limit => 20, index: true, comment: "Номер дома"
      t.column :statstatus, :integer, :limit => 1, comment: "Состояние дома"
      t.column :ifnsfl, :string, :limit => 4, comment: "Код ИФНС ФЛ"
      t.column :ifnsul, :string, :limit => 4, comment: "Код ИФНС ЮЛ"
      t.column :okato, :string, :limit => 11, comment: "ОКАТО"
      t.column :oktmo, :string, :limit => 11, comment: "ОКТМО"
      t.column :postalcode, :string, :limit => 6, comment: "Почтовый индекс"
      t.column :startdate, :date, comment: "Начало действия записи"
      t.column :strucnum, :string, :limit => 50, index: true, comment: "Номер строения"
      t.column :strstatus, :integer, :limit => 1, index: true, comment: "Признак строения.Принимает значение:0 – Не определено,1 – Строение,2 – Сооружение,3 – Литер"
      t.column :terrifnsfl, :string, :limit => 4, comment: "Код территориального участка ИФНС ФЛ"
      t.column :terrifnsul, :string, :limit => 4, comment: "Код территориального участка ИФНС ЮЛ"
      t.column :updatedate, :date, comment: "Дата  внесения (обновления) записи"
      t.uuid :normdoc, :string, :limit => 36, comment: "Внешний ключ на нормативный документ"
      t.column :counter, :integer, comment: "Счетчик записей домов для КЛАДР 4"
      t.column :cadnum, :string, :limit => 100, comment: "Кадастровый номер"
      t.column :divtype, :integer, :limit => 1, comment: "Тип деления: 0 – не определено \n      1 – муниципальное 2 – административное"
    end
  end
end
