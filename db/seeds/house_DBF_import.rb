#Загрузка обновлений домов ФИАС
#в таблицу houses
# get loadCSV function
require("./db/seeds/loadCSV")

99.times do |index|
  regID = index == 0 ? "5001" : index.to_s.rjust(2, "0")
  if File.exist?("dbf/HOUSE#{regID}.dbf")
    # Загрузка обновлений, добавлений, удалений домов ФИАС
    # в таблицу houses
    print "proccessing HOUSE#{regID}.dbf..."
    #Export data from dbf to CSV
    print %x{dbf -c dbf/HOUSE#{regID}.dbf > dbf/HOUSE#{regID}.csv}
    puts "done"
    if File.exist?("dbf/DHOUSE#{regID}.dbf")
      # Есть удаления записей
      print "proccessing DHOUSE#{regID}.dbf..."
      print %x{dbf -c dbf/DHOUSE#{regID}.dbf > dbf/DHOUSE#{regID}.csv}
      puts "done"
      loadCSV("dbf/HOUSE#{regID}.csv", "sql/house_dhouse.sql", "dbf/DHOUSE#{regID}.csv")
      puts "done"
    else
      loadCSV("dbf/HOUSE#{regID}.csv", "sql/house.sql")
      puts "done"
    end
  end
end
