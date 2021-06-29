# get loadCSV function
require("./db/seeds/loadCSV")

99.times do |index|
  regID = index.to_s.rjust(2, "0")
  if File.exist?("dbf/ADDROB#{regID}.dbf")
    #Загрузка обновлений адресообразующих элементов ФИАС
    #в таблицу address_objects
    print "proccessing ADDROB#{regID}.dbf..."
    #Export data from dbf to CSV
    print %x{dbf -c dbf/ADDROB#{regID}.dbf > dbf/ADDROB#{regID}.csv}
    puts "done"
    if File.exist?("dbf/DADDROB#{regID}.dbf")
      print "proccessing DADDROB#{regID}.dbf..."
      print %x{dbf -c dbf/DADDROB#{regID}.dbf > dbf/DADDROB#{regID}.csv}
      puts "done"
      loadCSV("dbf/DADDROB#{regID}.csv", "sql/addrob_daddrob.sql")
      puts "done"
    else
      loadCSV("dbf/ADDROB#{regID}.csv", "sql/addrob.sql")
      puts "done"
    end
  end
end
