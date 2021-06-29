BEGIN TRANSACTION;
/**********************************************/
/* Создание временных таблиц                  */
/**********************************************/
DROP TABLE IF EXISTS Houses_temp;
CREATE TABLE Houses_temp AS SELECT * FROM houses WHERE HOUSEID IS NULL;

/****************************************************************/
/* Загрузка во временную таблицу Houses_temp изменений          */
/* в основном списке  домов ФИАС                                */
/****************************************************************/
COPY  Houses_temp(AOGUID,BUILDNUM,ENDDATE,ESTSTATUS,HOUSEGUID,HOUSEID,
HOUSENUM,STATSTATUS,IFNSFL,IFNSUL,OKATO,OKTMO,POSTALCODE,STARTDATE,
STRUCNUM,STRSTATUS,TERRIFNSFL,TERRIFNSUL,UPDATEDATE,NORMDOC,COUNTER,
CADNUM,DIVTYPE) 
FROM 'absPATH'
  WITH (FORMAT csv, DELIMITER ",", HEADER TRUE, FORCE_NULL(NORMDOC,STRSTATUS,DIVTYPE,STATSTATUS));


/****************************************************************/
/* Обновление существующих записей основного списка houses      */ 
/* записей, данными обновления из временной таблицы Houses_Temp */
/****************************************************************/

UPDATE houses h SET 
    AOGUID = t.AOGUID,
    BUILDNUM = t.BUILDNUM,
    ENDDATE = t.ENDDATE,
    ESTSTATUS = t.ESTSTATUS,
    HOUSEGUID = t.HOUSEGUID,
    HOUSEID = t.HOUSEID,
    HOUSENUM = t.HOUSENUM,
    STATSTATUS = t.STATSTATUS,
    IFNSFL = t.IFNSFL,
    IFNSUL = t.IFNSUL,
    OKATO = t.OKATO,
    OKTMO = t.OKTMO,
    POSTALCODE = t.POSTALCODE,
    STARTDATE = t.STARTDATE,
    STRUCNUM = t.STRUCNUM,
    STRSTATUS = t.STRSTATUS,
    TERRIFNSFL = t.TERRIFNSFL,
    TERRIFNSUL = t.TERRIFNSUL,
    UPDATEDATE = t.UPDATEDATE,
    NORMDOC = t.NORMDOC,
    COUNTER = t.COUNTER,
    CADNUM = t.CADNUM,
    DIVTYPE =t.DIVTYPE
  FROM houses dh
	INNER JOIN Houses_temp t ON dh.HOUSEID = t.HOUSEID
  WHERE h.HOUSEID = dh.HOUSEID;	

/****************************************************************/
/* Добавление вновь поступивших записей основного списка houses */
/* записей, данными из временной таблицы Houses_temp            */
/****************************************************************/

INSERT INTO houses 	 
SELECT * FROM Houses_temp t
  WHERE NOT EXISTS(SELECT * FROM houses h 
                    WHERE h.HOUSEID=t.HOUSEID)
  ORDER BY AOGUID;

/**************************************************************/
/* Удаление временных таблиц из базы данных.                  */
/**************************************************************/

DROP TABLE IF EXISTS Houses_temp;
--ROLLBACK TRANSACTION;
COMMIT TRANSACTION;