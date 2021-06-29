class AddressRecord < ApplicationRecord
  self.abstract_class = true
  enum aolevel: { region: 1, autonomy: 2, district: 3, city: 4,
                  territory: 5, town: 6, street: 7, building: 8, parking: 9, l35: 35,
                  l65: 65, l90: 90, l91: 91 }
end
