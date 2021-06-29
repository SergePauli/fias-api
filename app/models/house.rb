class House < AddressRecord
  ESTNAMES = [false, "Владение", "Дом", "Домовладение", "Гараж", "Здание", "Шахта", "Подвал", "Котельная", "Погреб", "Объект нез-го"].freeze
  ESTNAMESSHORT = [false, "влд.", "д.", "двлд.", "г-ж", "зд.", "шахта", "подв.", "кот.", "пб.", "ОНС"].freeze
  STRNAMES = [false, "Строение", "Сооружение", "Литер"].freeze
  STRNAMESSHORT = [false, "стр", "соор", "литер"].freeze

  belongs_to :parent, -> { where(actstatus: true) }, class_name: "AddressObject", primary_key: :aoguid, foreign_key: :aoguid

  scope :actual_only, -> { where("houses.enddate > ?", Date.current) }

  scope :regioncode, ->(query) {
      joins(:parent).merge(AddressObject.where(regioncode: query)) if query.present?
    }

  scope :name_like, ->(query) {
          def create_codes_array(q, names_array)
            codes = []
            i = 0
            names_array.each do |sname|
              codes.push(i) if sname && sname.start_with?(q)
              i += 1
            end
            return codes
          end

          predicate = nil
          if query.present?
            q_array = query.split(" ")
            q_array.push(query) if q_array.size == 0
            isbuildnum = false
            while q_array.size > 0
              q = q_array.shift
              codes = create_codes_array(q, ESTNAMESSHORT)
              if codes.size > 0
                predicate = where(eststatus: codes)
              else
                codes = create_codes_array(q, STRNAMESSHORT)
                if codes.size > 0
                  predicate = where(strstatus: codes)
                else
                  codes = create_codes_array(q, ["корпус", "корп.", "кор."])
                  if codes.size > 0
                    isbuildnum = true
                  else
                    if predicate == nil
                      predicate = isbuildnum ? where("buildnum like ?", q + "%") : where("COALESCE(housenum,'')||COALESCE(strucnum,'') like ?", q + "%")
                    else
                      predicate = isbuildnum ? predicate.where("buildnum like ?", q + "%") : predicate.where("COALESCE(housenum,'')||COALESCE(strucnum,'') like ?", q + "%")
                    end
                    isbuildnum = false
                  end
                end
              end
            end
          end
          return predicate
        }

  def fullnumber
    (housenum.blank? ? "" : "#{ESTNAMESSHORT[eststatus]} #{housenum}") +
    (strucnum.blank? ? "" : " #{STRNAMESSHORT[strstatus]} #{strucnum}") +
    (buildnum.blank? ? "" : " корп. #{buildnum}")
  end

  def streetAddressLine
    if aoguid.blank?
      fullnumber
    else
      "#{parent.streetAddressLine}, #{fullnumber}"
    end
  end

  def createInfo(fullInfo = false, withParent = false)
    res = {
      AOGUID: aoguid,
      HouseGUID: houseguid,
      name: fullnumber,
      streetAddressLine: streetAddressLine,
      rustype: ESTNAMESSHORT[eststatus] || STRNAMES[strstatus],
      level: :building,
    }
    # Gettin native FIAS record
    res[:fias_info] = as_json if fullInfo
    # Getting all the parents recursively
    res[:parent] = parent.createInfo(fullInfo, withParent) if withParent && !aoguid.blank?
    return res
  end
end
