﻿// Процедура предназначена для записи наборов записей перерасчета для тех документов, которые затронуты
// данным набором записей регистра
// Если набор записей НадбавкиПоШтатномуРасписаниюОрганизаций записывается с датами, после которых проводились 
// начисления зарплаты (по тем же физлицам, по которым записываем начисления), то нужно переначислить 
// зарплату (т.е. перезаполнить соответствующие документы Начисление зарплаты)
// 
// Параметры:
//	нет
// Возвращаемое значение:
//	нет
//
Процедура ЗаписьПерерасчетов()
	
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УсловиеТекст = "";
	Для Каждого ЭлементОтбора из ЭтотОбъект.Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			Если не ПустаяСтрока(УсловиеТекст) Тогда
				УсловиеТекст = УсловиеТекст + " И ";
			КонецЕсли;
			УсловиеТекст = УсловиеТекст + "Надбавки." + ЭлементОтбора.Имя + " = &" + ЭлементОтбора.Имя;
			Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
		КонецЕсли;
		
	КонецЦикла;

	Если Не ПустаяСтрока(УсловиеТекст) Тогда
		УсловиеТекст = "ГДЕ " + УсловиеТекст;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Надбавки.ПодразделениеОрганизации,
	|	Надбавки.Должность,
	|	МИНИМУМ(Надбавки.Период) КАК Период,
	|	ВЫБОР
	|		КОГДА Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Надбавки.ПодразделениеОрганизации.Владелец
	|		ИНАЧЕ Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация
	|	КОНЕЦ КАК Организация
	|ПОМЕСТИТЬ ВТДанныеШтатногоРасписания
	|ИЗ
	|	РегистрСведений.НадбавкиПоШтатномуРасписаниюОрганизаций КАК Надбавки " + УсловиеТекст 
	+ "
	|
	|СГРУППИРОВАТЬ ПО
	|	Надбавки.ПодразделениеОрганизации,
	|	Надбавки.Должность,
	|	ВЫБОР
	|		КОГДА Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Надбавки.ПодразделениеОрганизации.Владелец
	|		ИНАЧЕ Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация
	|	КОНЕЦ ";
	Запрос.Выполнить();
	
	ЗапросТекст = 
	"ВЫБРАТЬ
	|	ВыбранныеЗаписи.Регистратор КАК Регистратор,
	|	ВыбранныеЗаписи.ФизЛицо,
	|	ВыбранныеЗаписи.Сотрудник,
	|	ВыбранныеЗаписи.Организация
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Расчеты.Регистратор КАК Регистратор,
	|		Расчеты.ФизЛицо КАК ФизЛицо,
	|		Расчеты.Сотрудник КАК Сотрудник,
	|		Расчеты.Организация КАК Организация
	|	ИЗ
	|		ВТДанныеШтатногоРасписания КАК Надбавки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				РаботникиОрганизации.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|				РаботникиОрганизации.Должность КАК Должность,
	|				РаботникиОрганизации.Сотрудник КАК Сотрудник
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|			ГДЕ
	|				РаботникиОрганизации.Организация В
	|						(ВЫБРАТЬ
	|							Надбавки.Организация
	|						ИЗ
	|							ВТДанныеШтатногоРасписания КАК Надбавки)
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				Работники.ПодразделениеОрганизацииЗавершения,
	|				Работники.ДолжностьЗавершения,
	|				Работники.Сотрудник
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций КАК Работники
	|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ПериодыПерекрытия
	|					ПО (ПериодыПерекрытия.Период <= Работники.ПериодЗавершения)
	|						И (ПериодыПерекрытия.Период > Работники.Период)
	|						И (ПериодыПерекрытия.Сотрудник = Работники.Сотрудник)
	|			ГДЕ
	|				Работники.Организация В
	|						(ВЫБРАТЬ
	|							Надбавки.Организация
	|						ИЗ
	|							ВТДанныеШтатногоРасписания КАК Надбавки)
	|				И Работники.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				И ПериодыПерекрытия.Период ЕСТЬ NULL ) КАК РаботникиОрганизации
	|			ПО (РаботникиОрганизации.ПодразделениеОрганизации = Надбавки.ПодразделениеОрганизации)
	|				И (РаботникиОрганизации.Должность = Надбавки.Должность)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК Расчеты
	|			ПО (Расчеты.Сотрудник = РаботникиОрганизации.Сотрудник)
	|				И (Расчеты.ПериодДействияНачало >= Надбавки.Период)) КАК ВыбранныеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК Перерасчеты
	|		ПО (Перерасчеты.ОбъектПерерасчета = ВыбранныеЗаписи.Регистратор)
	|			И (Перерасчеты.ФизЛицо = ВыбранныеЗаписи.ФизЛицо)
	|			И (Перерасчеты.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка))
	|ГДЕ
	|	Перерасчеты.ОбъектПерерасчета ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор";
	
	Запрос.Текст = ЗапросТекст;
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПроведениеРасчетов.ДописатьПерерасчетыОсновныхНачислений(Выборка);
	
КонецПроцедуры

// Обработчик события ПередЗаписью набора записей регистра сведений
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Замещение Тогда
		// запишем перерасчеты по тем записям, которые сейчас будут замещены
		ЗаписьПерерасчетов();
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если Запись.ВидНадбавки.ТребуетВводаТарифногоРазряда Тогда			
			ОбщегоНазначения.СообщитьОбОшибке("Нельзя выбирать вид надбавки требующий ввода тарифного разряда!", Отказ, "Запись набора записей регистра сведений ""Надбавки по штатному расписанию организаций: " );			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик события ПриЗаписи набора записей регистра сведений
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// запишем перерасчеты по новым записям
	ЗаписьПерерасчетов();
	
КонецПроцедуры