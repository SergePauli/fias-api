# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the
# bin/rails db:seed command (or created alongside the database with db:setup).

# import data from dbf/ADDROB**.DBF files
require("./db/seeds/addrob_DBF_import")

# import data from dbf/HOUSE**.DBF files
require("./db/seeds/house_DBF_import")
