﻿
Перем мСоответствиеРеквизитовИУзлов;

Перем мТипУдалениеДанных;
Перем мСтарыйТипОбъектаОтправки;
Перем мИнформацияОБазовыхТипах;
Перем мИмяСтарогоБазовогоТипа;

Перем мСтарыйПрефикс;


Функция ПолучитьИмяБазовогоТипаПоТипуОбъекта(ТипОбъекта) Экспорт
	
	МетаданныеТипа = Метаданные.НайтиПоТипу(ТипОбъекта);
	
	Если Метаданные.РегистрыСведений.Содержит(МетаданныеТипа) Тогда
	
		Возврат "РегистрыСведений";
		
	ИначеЕсли Метаданные.Документы.Содержит(МетаданныеТипа) Тогда
		
		Возврат "Документы";
		
	ИначеЕсли Метаданные.Справочники.Содержит(МетаданныеТипа) Тогда
		
		Возврат "Справочники";	
		
	Иначе
	   
		Возврат "";
		
	КонецЕсли;
			
КонецФункции

Процедура ОпределитьТипОтправкиДанных(ЭлементДанных, ОтправкаЭлемента) Экспорт
	
	ТипОбъекта = ТипЗнч(ЭлементДанных);
	
	Если ТипОбъекта = мТипУдалениеДанных Тогда
		
		// удаление объекта просто отсылаем как есть
		Возврат;
		
	КонецЕсли;
	
	Если мСтарыйТипОбъектаОтправки = ТипОбъекта Тогда
		
		ИмяБазовогоТипа = мИмяСтарогоБазовогоТипа;
		
	Иначе	
	
		ИмяБазовогоТипа = мИнформацияОБазовыхТипах.Получить(ТипОбъекта);
		
		Если ИмяБазовогоТипа = Неопределено Тогда
		
			ИмяБазовогоТипа = ПолучитьИмяБазовогоТипаПоТипуОбъекта(ТипОбъекта);
			мИнформацияОБазовыхТипах.Вставить(ТипОбъекта, ИмяБазовогоТипа);
		
		КонецЕсли;
		
		мИмяСтарогоБазовогоТипа = ИмяБазовогоТипа;
		мСтарыйТипОбъектаОтправки = ТипОбъекта;
	
	КонецЕсли;
	
	Если ИмяБазовогоТипа = "Справочники"
		ИЛИ ИмяБазовогоТипа = "Документы" Тогда
		
		ВыгружатьДляВсехУзлов = Ложь;
		
		//НеобходимостьРегистрации = ПроцедурыОбменаДаннымиСУправлениемТорговлей.ОпределитьНеобходимостьРегистрацииПроизвольногоТипа(ЭлементДанных, 
		//	ИмяБазовогоТипа);
		//	
		//Если Не НеобходимостьРегистрации Тогда
		//	
		//	// передаем информацию об удалении
		//	ОтправкаЭлемента = ОтправкаЭлементаДанных.Удалить;
		//	
		//ИначеЕсли ИмяБазовогоТипа = "Документы"
		//	И ТипОбъекта = мТипДокументОбъектИнвентаризацияТоваров
		//	И НЕ ЭлементДанных.Проведен Тогда
		//	
		//	ОтправкаЭлемента = ОтправкаЭлементаДанных.Удалить;
		//	
		//Иначе
		//	
		//	// объект должен ехать, нужно определить удовлетворяет ли он ограничениям по дате
		//	Если ИмяБазовогоТипа = "Документы"
		//		И ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов)
		//		И ЭлементДанных.Дата < ДатаНачалаВыгрузкиДокументов Тогда
		//		
		//		// просто не выгружаем этот документ и все - игнорируем при выгрузке
		//		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;	
		//		
		//	КонецЕсли;
		//	
		//КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	
	Если ЭтоНовый()
	 ИЛИ мСтарыйПрефикс <> ПрефиксДляЗагружаемыхДокументов Тогда
		
		ПолныеПраваДополнительный.ОбработатьУстановкуВозможногоПрефиксаИнформационнойБазы(ПрефиксДляЗагружаемыхДокументов);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	мСтарыйПрефикс = Ссылка.ПрефиксДляЗагружаемыхДокументов;
	
КонецПроцедуры


мТипУдалениеДанных = Тип("УдалениеОбъекта");

мИнформацияОБазовыхТипах = Новый Соответствие;
мСтарыйТипОбъектаОтправки = Неопределено;
мСоответствиеРеквизитовИУзлов = Неопределено;
