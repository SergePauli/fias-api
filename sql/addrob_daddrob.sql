BEGIN TRANSACTION;
/**********************************************/
/* Создание временных таблиц                  */
/**********************************************/
DROP TABLE IF EXISTS AddressObjects_temp;
DROP TABLE IF EXISTS DeletedAddressObjects_temp;

CREATE TABLE AddressObjects_temp AS SELECT * FROM address_objects WHERE aoid IS NULL;
CREATE TABLE DeletedAddressObjects_temp AS SELECT * FROM address_objects WHERE aoid IS NULL;
/****************************************************************/
/* Загрузка во временную таблицу AddressObjects_temp изменений  */
/* в основном списке адресообразующих элементов ФИАС            */
/****************************************************************/
COPY  AddressObjects_temp(actstatus,aoguid,aoid,aolevel,areacode,
				autocode,centstatus,citycode,code,currstatus,enddate,formalname,ifnsfl,ifnsul,nextid,
				offname,okato,oktmo,operstatus,parentguid,placecode,plaincode,postalcode,previd,regioncode,shortname,startdate,streetcode,terrifnsfl,terrifnsul,updatedate,ctarcode,extrcode,sextcode,lifestatus,normdoc,plancode,cadnum,divtype) 
  FROM 'absPATH'
  WITH (FORMAT csv, DELIMITER ",", HEADER TRUE, FORCE_NULL(parentguid,normdoc,nextid,previd,currstatus,divtype));

/**************************************************************/
/* Загрузка во временную таблицу DeletedAddressObjects_Temp   */
/* записей, которые должны быть удалены из основнго списка    */
/**************************************************************/

COPY  DeletedAddressObjects_Temp(actstatus,aoguid,aoid,aolevel,areacode,
				autocode,centstatus,citycode,code,currstatus,enddate,formalname,ifnsfl,ifnsul,nextid,
				offname,okato,oktmo,operstatus,parentguid,placecode,plaincode,postalcode,previd,regioncode,shortname,startdate,streetcode,terrifnsfl,terrifnsul,updatedate,ctarcode,extrcode,sextcode,lifestatus,normdoc,plancode,cadnum,divtype) 
	FROM 'absPATH2'
	WITH (FORMAT csv, DELIMITER ",", HEADER TRUE, FORCE_NULL(parentguid,normdoc,nextid,previd,currstatus,divtype));

/************************************************************************/
/* Обновление существующих записей основного списка address_objects     */ 
/* записей, данными обновления из временной таблицы AddressObjects_Temp */
/************************************************************************/
UPDATE address_objects ao SET actstatus=t.actstatus,
				aoguid=t.aoguid,
				aolevel=t.aolevel,
				areacode=t.areacode,
				autocode=t.autocode,
				centstatus=t.centstatus,
				citycode=t.citycode,
				code=t.code,
				currstatus=t.currstatus,
				enddate=t.enddate,
				formalname=t.formalname,
				ifnsfl=t.ifnsfl,
				ifnsul=t.ifnsul,
				nextid=t.nextid,
				offname=t.offname,
				okato=t.okato,
				oktmo=t.oktmo,
				operstatus=t.operstatus,
				parentguid=t.parentguid,
				placecode=t.placecode,
				plaincode=t.plaincode,
				postalcode=t.postalcode,
				previd=t.previd,
				regioncode=t.regioncode,
				shortname=t.shortname,
				startdate=t.startdate,
				streetcode=t.streetcode,
				terrifnsfl=t.terrifnsfl,
				terrifnsul=t.terrifnsul,
				updatedate=t.updatedate,
				ctarcode=t.ctarcode,
				extrcode=t.extrcode,
				sextcode=t.sextcode,
				lifestatus=t.lifestatus,
				normdoc=t.normdoc,
        plancode=t.plancode,
        cadnum=t.cadnum,
        divtype=t.divtype
              FROM address_objects dao
			        INNER JOIN AddressObjects_temp t ON dao.aoid=t.aoid
              WHERE ao.aoid=dao.aoid;	

/***************************************************************************/
/* Удаление существующих записей основного списка address_objects записей, */
/* на основании данных из временной таблицы DeletedAddressObjects_Temp     */
/***************************************************************************/

DELETE FROM address_objects ao WHERE EXISTS(SELECT 1 FROM 
DeletedAddressObjects_Temp delao WHERE delao.aoid=ao.aoid);

/**************************************************************************/
/* Добавление вновь поступивших записей основного списка address_objects  */
/* записей, данными из временной таблицы AddressObjects_Temp              */
/**************************************************************************/
INSERT INTO address_objects 	 
SELECT * 
   FROM AddressObjects_temp t
   WHERE NOT EXISTS(SELECT * FROM address_objects ao 
                                 WHERE ao.aoid=t.aoid)
   ORDER BY code;

/********************************************************************************/
/* Исправление нарушений целостности address_objects.                           */
/* Непустые ссылки на предыдущую и последующую записи заменяются значением NULL	*/
/********************************************************************************/
UPDATE address_objects ao SET nextid=NULL	
   WHERE ao.nextid IS NOT NULL AND NOT EXISTS(SELECT * FROM address_objects nao
                                WHERE nao.aoid=ao.nextid);	
UPDATE address_objects ao SET previd=NULL	
   WHERE ao.previd IS NOT NULL AND NOT EXISTS(SELECT * FROM address_objects pao
                                WHERE pao.aoid=ao.previd);		

/************************************************/
/* Удаление временных таблиц из базы данных.    */
/************************************************/
DROP TABLE IF EXISTS AddressObjects_temp;
DROP TABLE IF EXISTS DeletedAddressObjects_temp;
--ROLLBACK TRANSACTION;
COMMIT TRANSACTION;