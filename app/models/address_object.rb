class AddressObject < AddressRecord
  VILLAGE_COUNCILS_SHORTNAMES = ["с/с", "с/а", "с/о", "с/мо"].freeze
  NOT_TOWN_SHORTNAMES = ["с/с", "с/а", "с/о", "с/мо", "сад", "снт", "тер", "автодорога", "промзона", "дп", "мкр"].freeze
  NOT_STREET_SHORTNAMES = ["уч-к", "гск", "пл-ка", "снт", "тер"].freeze
  ANOTHER_NOT_TOWN_SHORTNAMES = ["сад", "снт", "тер", "промзона", "дп"].freeze
  SHORT_NAMES = ["а.обл.", "Аобл", "а.окр.", "АО", "г", "г.", "г.ф.з.", "край", "обл", "обл.", "округ", "Респ", "респ.", "Чувашия", "АО", "АО", "вн.тер. г.", "г", "г.о.", "м.о.", "м.р-н", "п", "пос.", "р-н", "тер", "у", "у.", "волость", "г", "г.", "дп", "кп", "массив", "п", "пгт", "пгт.", "п/о", "рп", "с/а", "с/о", "с/мо", "с/п", "с/с", "тер", "р-н", "тер", "аал", "автодорога", "арбан", "аул", "волость", "высел", "г", "г-к", "гп", "дп", "дп.", "д", "ж/д_оп", "ж/д б-ка", "ж/д_будка", "ж/д в-ка", "ж/д к-ма", "ж/д_казарм", "ж/д пл-ма", "ж/д_платф", "ж/д пл-ка", "ж/д_ст", "ж/д бл-ст", "ж/д к-т", "ж/д о.п.", "ж/д_пост", "ж/д п.п.", "ж/д_рзд", "жилзона", "жилрайон", "заимка", "зим.", "казарма", "кв-л", "киш.", "кордон", "кп", "лпх", "массив", "м", "мкр", "нп", "нп.", "остров", "пл.р-н", "погост", "п", "пгт", "пгт.", "п/ст", "п. ж/д ст.", "пос.рзд", "починок", "п/о", "промзона", "рп", "рзд", "снт", "с", "сп", "сп.", "сл", "ст-ца", "ст", "тер", "у", "х", "а/я", "ал.", "аллея", "балка", "берег", "бугор", "б-р", "вал", "взв.", "въезд", "гск", "г-к", "днп", "д", "дор", "ж/д_оп", "ж/д_будка", "ж/д_казарм", "ж/д_платф", "ж/д_ст", "ж/д_пост", "ж/д_рзд", "жт", "заезд", "ззд.", "зона", "казарма", "кв-л", "км", "к-цо", "кольцо", "коса", "линия", "лн.", "мгстр.", "маяк", "м", "местность", "мкр", "мост", "наб", "наб.", "нп", "н/п", "остров", "парк", "пер-д", "переезд", "пер", "пер.", "пл.р-н", "платф", "пл-ка", "пл", "полустанок", "п", "п/ст", "п/о", "пр-д", "проезд", "промзона", "пр-к", "просек", "пр-ка", "просека", "пр-лок", "проселок", "пр-кт", "проул.", "проулок", "рзд", "рзд.", "ряд", "ряды", "сад", "снт", "с/т", "с", "с-р", "сквер", "сл", "с-к", "спуск", "ст", "стр", "сзд.", "тер", "тер. ДНТ", "тер. СНТ", "тракт", "туп", "ул", "ул.", "уч-к", "ферма", "ф/х", "х", "ш", "ш.", "м/м", "вн.р-н", "г.п.", "межсел.тер", "с.п.", "аал", "а/я", "ал.", "арбан", "аул", "б-г", "б-р", "вал", "взд.", "гск", "г-к", "днп", "д.", "дор.", "ж/д б-ка", "ж/д к-ма", "ж/д пл-ма", "ж/д ст.", "ж/д рзд.", "ж/р", "ззд.", "зона", "кв-л", "км", "к-цо", "коса", "лн.", "м-ко", "местность", "месторожд.", "мр.", "мкр", "мкр.", "наб.", "н/п", "ост-в", "парк", "пер-д", "пер.", "платф.", "пл-ка", "пл.", "порт", "п.", "п-к", "пр-д", "промзона", "п/р", "пр-к", "пр-ка", "пр-лок", "пр-кт", "проул.", "рзд.", "р-н", "сад", "снт", "с.", "с-р", "сквер", "сл.", "с-к", "ст.", "стр.", "тер", "тер.", "тер. ГСК", "тер. ДНО", "тер. ДНП", "тер. ДНТ", "тер. ДПК", "тер. ОНО", "тер. ОНП", "тер. ОНТ", "тер. ОПК", "тер. ПК", "тер. СНО", "тер. СНП", "тер. СНТ", "тер.СОСН", "тер. СПК", "тер. ТСЖ", "тер. ТСН", "тер.ф.х.", "тракт", "туп.", "ул.", "ус.", "ф/х", "х.", "ш.", "ю.", "з/у", "гск", "днп", "местность", "мкр", "н/п", "промзона", "сад", "снт", "тер", "ф/х", "аал", "а/я", "аллея", "арбан", "аул", "берег", "б-р", "вал", "въезд", "высел", "гск", "г-к", "д", "дор", "ж/д_оп", "ж/д_будка", "ж/д_казарм", "ж/д_платф", "ж/д_ст", "ж/д_пост", "ж/д_рзд", "жт", "заезд", "зона", "казарма", "кв-л", "км", "кольцо", "коса", "линия", "м", "мкр", "мост", "наб", "нп", "остров", "парк", "переезд", "пер", "пл.р-н", "платф", "пл-ка", "пл", "п", "п/ст", "починок", "п/о", "проезд", "просек", "просека", "проселок", "пр-кт", "проулок", "рзд", "ряды", "сад", "снт", "с", "сквер", "сл", "спуск", "ст", "стр", "тер", "тракт", "туп", "ул", "уч-к", "ферма", "х", "ш"]

  belongs_to :parent, -> { where(actstatus: true) }, class_name: "AddressObject", primary_key: :aoguid, foreign_key: :parentguid

  scope :full_text_search, ->(query) {
          if query.split(" ").size > 1
            #valid multywords full_text_search query
            where("to_tsvector('russian', formalname || ' ' || shortname) @@ plainto_tsquery(?)", query)
          elsif SHORT_NAMES.include? query
            # only shortname query
            where(shortname: query)
          else
            # formalname  query
            where(formalname: query.capitalize)
          end if query.present?
        }
  scope :name_like, ->(query) {
          where("LOWER(shortname || formalname || shortname) like ?", "%" + query.gsub(" ", "%") + "%") if query.present?
        }

  scope :actual_only, -> { where(actstatus: true) }

  # возвращает группy адрес-образующего элемента
  def aoGroup
    if aolevel == "region" && shortname != "г"
      # регион
      return "Region"
    elsif aolevel == "region" && shortname == "г"
      # уровень города как региона
      return "City"
    elsif aolevel == "district"
      # уровень района
      return "District"
    elsif aolevel == "city" && !VILLAGE_COUNCILS_SHORTNAMES.include?(shortname)
      # уровень города
      return "City"
    elsif ["city", "town"].include?(aolevel) && VILLAGE_COUNCILS_SHORTNAMES.include?(shortname) && !shortname.start_with?("ж/д")
      # уровень сельсовета
      return "VillageCouncil"
    elsif aolevel == "town" && !NOT_TOWN_SHORTNAMES.include?(shortname) && !shortname.start_with?("ж/д")
      # уровень населенного пункта
      return "Town"
    elsif shortname == "автодорога"
      # уровень автомобильной дороги
      return "MotorRoad"
    elsif ["street", "town"].include?(aolevel) && shortname.start_with?("ж/д")
      # уровень объекта на железной дороге
      return "RailWayObject"
    elsif aolevel == "street" && !shortname.start_with?("ж/д") &&
          !NOT_STREET_SHORTNAMES.include?(shortname) ||
          (aolevel == "town" && shortname == "мкр")
      # уровень улицы
      return "Street"
    elsif aolevel == "l90" || (aolevel == "town" && ANOTHER_NOT_TOWN_SHORTNAMES.include?(shortname)) || (aolevel == "street" && NOT_STREET_SHORTNAMES.include?(shortname))
      # уровень дополнительных территорий
      return "AddlTerritory"
    elsif aolevel == "l91"
      # уровень подчиненных дополнительным территориям объектов
      return "PartAddlTerritory"
    else
      return "GenericAddressObject"
    end
  end

  def streetAddressLine
    if parentguid.blank?
      "#{formalname} #{shortname}"
    else
      "#{parent.streetAddressLine}, #{formalname} #{shortname}"
    end
  end

  def createInfo(fullInfo = false, withParent = false)
    res = {
      AOGUID: aoguid,
      parentGUID: parentguid,
      code: code,
      name: formalname,
      shortname: shortname,
      streetAddressLine: streetAddressLine,
      level: aoGroup,
    }
    if fullInfo
      res[:fias_info] = as_json
    end

    if withParent && !parentguid.blank?
      # Getting all the parents recursively
      res[:parent] = parent.createInfo(fullInfo, withParent)
    end

    return res
  end
end
