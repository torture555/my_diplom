﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПарсингКонстанты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СформироватьКонстанту();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

&НаСервере
Процедура ЛогинПарольПриИзмененииНаСервере()
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПарольПриИзменении(Элемент)
	
	ЛогинПарольПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыФункции

&НаСервере
Процедура ПарсингКонстанты()
	
	Если ЗначениеЗаполнено(НаборКонстант.ЖИПК_ДанныеСистемногоПользователя) Тогда
		ЛогинПароль = СтрРазделить(НаборКонстант.ЖИПК_ДанныеСистемногоПользователя, ";");
		
		Если ЛогинПароль.Количество() > 0 Тогда
			Логин = ЛогинПароль[0];
			Если ЛогинПароль.Количество() > 1 Тогда
				Пароль = "Пароль введен";
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКонстанту()
	
	НаборКонстант.ЖИПК_ДанныеСистемногоПользователя = Логин + ";" + Пароль;
	
КонецПроцедуры

#КонецОбласти