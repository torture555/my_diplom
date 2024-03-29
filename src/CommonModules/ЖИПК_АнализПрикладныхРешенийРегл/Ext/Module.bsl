﻿
#Область ПрограммныйИнтерфейс

Процедура ВыполнитьЗаписьХешСуммыКонфигурации() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ЖИПК_АнализПрикладныхРешений.ОбновитьСостоянияКлючейАналитики();
	
	ПараметрыВыгрузки = ПолучитьПараметрыЗапускаПрограммы();
	
	Если ПараметрыВыгрузки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФайлКонф = КаталогВременныхФайлов() + "1cv8.cf"; 
	
   	СтрокаЗапуска = ПараметрыВыгрузки.Программа + " infobase config save" + 
								" --db-server=localhost " +
								" --dbms=" + ПараметрыВыгрузки.СУБД +
								" --db-user=" + ПараметрыВыгрузки.ЛогинСУБД + 
								" --db-pwd=" + ПараметрыВыгрузки.ПарольСУБД +
								" --db-name=" + ПараметрыВыгрузки.ИмяБазы +
								" --user=" + ПараметрыВыгрузки.Логин +
								" --password=" + ПараметрыВыгрузки.Пароль + 
								" "	+ ФайлКонф;
	
	КодОтвета = Неопределено;
	ЗапуститьПриложение(СтрокаЗапуска,, Истина, КодОтвета); 
	Если КодОтвета > 0 Или КодОтвета = Неопределено Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Ошибка выполнения выгрузки конфигурации");
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ФайлКонф);
	ХешСумма = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешСумма.Добавить(ДвоичныеДанные);
	ХешСумма = ХешСумма.ХешСумма;
	
	КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.ОсноваяКонфигурация;
	
	Запись = РегистрыСведений.ЖИПК_РегистрХешСуммПрикладныхРешений.СоздатьМенеджерЗаписи();
	Запись.Период = ТекущаяДатаСеанса();
	Запись.ПрикладноеРешение = КлючАналитики;
	Запись.ХешСумма = Строка(ХешСумма);
	Запись.Записать(Ложь);
	
	УстановитьПривилегированныйРежим(Ложь);
	                                   
КонецПроцедуры

Процедура ВыполнитьЗаписьХешСуммыРасширений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЖИПК_АнализПрикладныхРешений.ОбновитьСостоянияКлючейАналитики();
	
	Для Каждого Расширение Из РасширенияКонфигурации.Получить() Цикл
		
		ГУИД = Строка(Расширение.УникальныйИдентификатор);
		
		Имя = Расширение.Имя;
		
		ПараметрыВыгрузки = ПолучитьПараметрыЗапускаПрограммы();
		Если ПараметрыВыгрузки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ФайлРасширения = КаталогВременныхФайлов() + Имя + ".cfe"; 
	    СтрокаЗапуска = ПараметрыВыгрузки.Программа + " infobase config save" + 
									" --db-server=localhost " +
									" --extension=" + Имя +
									" --dbms=" + ПараметрыВыгрузки.СУБД +
									" --db-user=" + ПараметрыВыгрузки.ЛогинСУБД + 
									" --db-pwd=" + ПараметрыВыгрузки.ПарольСУБД +
									" --db-name=" + ПараметрыВыгрузки.ИмяБазы +
									" --user=" + ПараметрыВыгрузки.Логин +
									" --password=" + ПараметрыВыгрузки.Пароль +
									" " + ФайлРасширения;
		
		КодОтвета = Неопределено;
		ЗапуститьПриложение(СтрокаЗапуска,, Истина, КодОтвета);
		Если КодОтвета > 0 Или КодОтвета = Неопределено Тогда
			ЗаписатьОшибкуВЖурналРегистрации("Не удалось выполнить выгрузку расширения конфигурации " + Имя); 	
		КонецЕсли;
		ДвоичныеДанные = Новый ДвоичныеДанные(ФайлРасширения);
		
		ХешСумма = Новый ХешированиеДанных(ХешФункция.SHA256);
		ХешСумма.Добавить(ДвоичныеДанные);
		ХешСумма = ХешСумма.ХешСумма;
		
		КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.НайтиПоРеквизиту("ИдентификаторРешения", ГУИД);
		Если КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.ПустаяСсылка() Тогда
			ТипПрикладногоРешения = Перечисления.ЖИПК_ТипыПрикладныхРешений.РасширениеКонфигурации;
			СтруктураНового = Новый Структура;
			СтруктураНового.Вставить("Наименование", Расширение.Имя);
			СтруктураНового.Вставить("ИдентификаторРешения", ГУИД);
			СтруктураНового.Вставить("ТипПрикладногоРешения", ТипПрикладногоРешения);
			СтруктураНового.Вставить("Отсутствует", Ложь);
			ЖИПК_АнализПрикладныхРешенийСлужебный.ДобавитьНовыйКлючАналитики(СтруктураНового);
			КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.НайтиПоРеквизиту("ИдентификаторРешения", ГУИД);
		КонецЕсли;
		
		Запись = РегистрыСведений.ЖИПК_РегистрХешСуммПрикладныхРешений.СоздатьМенеджерЗаписи();
		Запись.Период = ТекущаяДатаСеанса();
		Запись.ПрикладноеРешение = КлючАналитики;
		Запись.ХешСумма = Строка(ХешСумма);
		Запись.Записать(Ложь);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ВыполнитьЗаписьХешСуммыДополнительных() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ЖИПК_АнализПрикладныхРешений.ОбновитьСостоянияКлючейАналитики();
	
	Запрос = Новый Запрос;
	Запрос.Текст = ЖИПК_АнализПрикладныхРешений.ТекстЗапросаДополнительныеОтчетыИОбработки();
	Дополнительные = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из Дополнительные Цикл
		
		ГУИД = Строка(Стр.Ссылка.УникальныйИдентификатор());
		КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.НайтиПоРеквизиту("ИдентификаторРешения", ГУИД);
		Если КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.ПустаяСсылка() Тогда
			ТипПрикладногоРешения = Перечисления.ЖИПК_ТипыПрикладныхРешений.ДополнительныеОтчетыОбработки;
			СтруктураНового = Новый Структура;
			СтруктураНового.Вставить("Наименование", Стр.Наименование);
			СтруктураНового.Вставить("ИдентификаторРешения", ГУИД);
			СтруктураНового.Вставить("ТипПрикладногоРешения", ТипПрикладногоРешения);
			СтруктураНового.Вставить("Отсутствует", Ложь);
			ЖИПК_АнализПрикладныхРешенийСлужебный.ДобавитьНовыйКлючАналитики(СтруктураНового);
			КлючАналитики = Справочники.ЖИПК_КлючиАналитикиПрикладныхРешений.НайтиПоРеквизиту("ИдентификаторРешения", ГУИД);
		КонецЕсли;
	
		ДвоичныеДанные = Стр.ХранилищеОбработки.Получить();	
		Если ТипЗнч(ДвоичныеДанные) <> Тип("ДвоичныеДанные") Тогда
			Возврат;
		КонецЕсли;
		
		ХешСумма = Новый ХешированиеДанных(ХешФункция.SHA256);
		ХешСумма.Добавить(ДвоичныеДанные);
		ХешСумма = ХешСумма.ХешСумма;
		
		Запись = РегистрыСведений.ЖИПК_РегистрХешСуммПрикладныхРешений.СоздатьМенеджерЗаписи();
		Запись.Период = ТекущаяДатаСеанса();
		Запись.ПрикладноеРешение = КлючАналитики;
		Запись.ХешСумма = Строка(ХешСумма);
		Запись.Записать(Ложь);	
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыЗапускаПрограммы()

	ЛогинПарольСУБД = Константы.ЖИПК_ДанныеПользователяСУБД.Получить();
	ЛогинПарольСУБД = СтрРазделить(ЛогинПарольСУБД, ";", Истина);
	Если ЛогинПарольСУБД.Количество() <> 2 Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Не заполнены доступы к СУБД");
		Возврат Неопределено;
	КонецЕсли;
	ЛогинСУБД = ЛогинПарольСУБД[0];
	ПарольСУБД = ЛогинПарольСУБД[1];
	
	ЛогинПароль = Константы.ЖИПК_ДанныеСистемногоПользователя.Получить();
	ЛогинПароль = СтрРазделить(ЛогинПароль, ";", Истина);
	Если ЛогинПароль.Количество() <> 2 Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Не заполнены доступы системного пользователя инф.базы");
		Возврат Неопределено;
	КонецЕсли;
	Логин = ЛогинПароль[0];
	Пароль = ЛогинПароль[1];
	
	ПодключениеАгент = Константы.ЖИПК_ДанныеАгентаСервера.Получить();
	ПодключениеАгент = СтрРазделить(ПодключениеАгент, ";", Истина);
	Если ПодключениеАгент.Количество() <> 4 Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Не заполнены доступы к агенту сервера");
		Возврат Неопределено;
	КонецЕсли;
	ЛогинАгент = ПодключениеАгент[0]; 
	ПарольАгент = ПодключениеАгент[1];
	IPАгента = ?(ПустаяСтрока(ПодключениеАгент[2]), "127.0.0.1", ПодключениеАгент[2]);
	ПортАгента = ?(ПустаяСтрока(ПодключениеАгент[3]), "1545", ПодключениеАгент[3]);
	
	ПодключениеКластер = Константы.ЖИПК_ДанныеАдминистратораКластера.Получить();
	ПодключениеКластер = СтрРазделить(ПодключениеКластер, ";", Истина);
	Если ПодключениеКластер.Количество() <> 2 Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Не заполнены доступы к кластеру серверов");
		Возврат Неопределено;
	КонецЕсли;
	ЛогинКластера = ПодключениеКластер[0];
	ПарольКластера = ПодключениеКластер[1];	
	
	ТекСоединение = СтрокаСоединенияИнформационнойБазы();
	ПараметрыСоединения = СтрРазделить(СтрЗаменить(ТекСоединение, """", ""), ";");
	ИмяБазы = "";
	Для Каждого Параметр Из ПараметрыСоединения Цикл
		Если СтрНайти(Параметр, "Ref=") > 0 Тогда
			ИмяБазы = СтрЗаменить(Параметр, "Ref=", "");
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяСтрока(ИмяБазы) Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Не была получена информация о инф.базе. Возможно используется файловый режим работы");
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Агент = Новый АдминистрированиеСервера(IPАгента, ПортАгента);
		Агент.ВыполнитьАутентификацию(ЛогинАгент, ПарольАгент);
	Исключение
		ЗаписатьОшибкуВЖурналРегистрации("Ошибка доступа к агенту серверов. Проверьте введенные данные");
		Возврат Неопределено;
	КонецПопытки;
	
	Кластеры = Агент.ПолучитьКластеры();
	АдминТекИнфБазы = Неопределено;
	Для Каждого Кластер Из Кластеры Цикл
		Попытка
			Кластер.ВыполнитьАутентификацию(ЛогинКластера, ПарольКластера);
		Исключение
			Продолжить;
		КонецПопытки;
		ИнфБазы = Кластер.ПолучитьИнформационныеБазы();
		Для Каждого База Из ИнфБазы Цикл
			Если База.Имя = ИмяБазы Тогда
				АдминТекИнфБазы = База;
				Прервать;
			КонецЕсли;			
		КонецЦикла;
		Если АдминТекИнфБазы <> Неопределено Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если АдминТекИнфБазы = Неопределено Тогда
		ЗаписатьОшибкуВЖурналРегистрации("Не найдена информационная база в кластере серверов");
		Возврат Неопределено;
	КонецЕсли;
	АдминТекИнфБазы.ВыполнитьАутентификацию(Логин, Пароль);
	
	Программа = КаталогПрограммы() + "ibcmd";
	ФайлПрограммы = Новый Файл(Программа);
	Если Не ФайлПрограммы.Существует() Тогда
		Программа = Программа + ".exe";
		ФайлПрограммыWind = Новый Файл(Программа);
		Если Не ФайлПрограммыWind.Существует() Тогда
			ЗаписатьОшибкуВЖурналРегистрации("Проверьте утилиту ibcmd в каталоге программы");
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("СУБД", АдминТекИнфБазы.СУБД);
	ПараметрыВыгрузки.Вставить("ИмяБазы", АдминТекИнфБазы.Имя );
	ПараметрыВыгрузки.Вставить("Программа", Программа);
	ПараметрыВыгрузки.Вставить("ЛогинСУБД", ЛогинСУБД);
	ПараметрыВыгрузки.Вставить("ПарольСУБД", ПарольСУБД);
	ПараметрыВыгрузки.Вставить("Логин", Логин);
	ПараметрыВыгрузки.Вставить("Пароль", Пароль);

	Возврат ПараметрыВыгрузки;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки)
	
	ЗаписьЖурналаРегистрации("Журнал изменений конфигураций",
							 УровеньЖурналаРегистрации.Ошибка,
							 Метаданные.ОбщиеМодули.ЖИПК_АнализПрикладныхРешенийРегл,,
							 ОписаниеОшибки,
							 РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);						 
	
КонецПроцедуры

#Область ТекстыЗапросов

Функция ТекстЗапросаДополнительныеОтчетыОбработки()
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ДополнительныеОтчетыИОбработки.ХранилищеОбработки КАК ХранилищеОбработки,
	               |	ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка,
	               |	ДополнительныеОтчетыИОбработки.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти
