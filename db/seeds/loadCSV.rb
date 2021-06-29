#Грузим СSV данные в СУБД
#Data loading function (from CSV to PG database)
# Used params:
# fileName: CSV-file with new or changed records
# delfileName: CSV-file with deleted records
# scriptName: sql-script-file for loading data from CSV

def loadCSV(fileName, scriptName, delfileName = nil)
  print "processing #{fileName}..."
  File.open(scriptName, "r") do |file|
    sql = file.read
    apath = File.absolute_path(fileName)
    sql = sql.gsub! "absPATH", apath # inject filename in script
    if delfileName != nil
      apath = File.absolute_path(delfileName)
      sql = sql.gsub! "absPATH2", apath # inject delfileName in script
    end
    results = ActiveRecord::Base.connection.execute(sql)
    if results.present?
      results.each do |row|
        puts row
      end
    end
    # cleanup dir from CSV
    File.delete(fileName) if File.exists? fileName
    File.delete(delfileName) if delfileName != nil && File.exists?(delfileName)
  end
end
