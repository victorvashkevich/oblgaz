﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем РежимЗаписиРегистратора Экспорт;
Перем ПустойНаборЗаписей;

Перем мФизлица;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ВыполнитьПроверку(СообщатьОбОшибкахПериодов, УчитиыватьРегистратор)
	
	Регистратор = Отбор.Регистратор.Значение;
	
	Запрос = Новый Запрос;
	
	ТаблицаПериодов = ОбщегоНазначения.ПериодыИспользованияРесурсов("ПериодыСостоянийРаботников", , , "Периоды.Физлицо В (&Физлица)", УчитиыватьРегистратор);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Регистратор1,
	|	Регистратор2,
	|	ПРЕДСТАВЛЕНИЕ(Регистратор1) КАК ПредставлениеРегистратор1,
	|	ПРЕДСТАВЛЕНИЕ(Регистратор2) КАК ПредставлениеРегистратор2,
	|	Физлицо,
	|	Физлицо.Наименование КАК ФизлицоНаименование,
	|	ДатаНачала,
	|	ДатаОкончания
	|ИЗ
	|	(" + ТаблицаПериодов + ") КАК Периоды
	|УПОРЯДОЧИТЬ ПО
	|	ФизлицоНаименование,
	|	ДатаНачала";
	
	Запрос.УстановитьПараметр("Регистратор",	Регистратор);
	Запрос.УстановитьПараметр("Физлица",		мФизлица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// обработаем периоды
	ТекущееФизлицо						= Неопределено;
	ПоследняяДатаНачала					= '0001-01-01';
	ПоследняяДатаОкончания				= '0001-01-01';
	ПоследнийРегистратор1				= Неопределено;
	ПоследнийРегистратор2				= Неопределено;
	ПоследнийПредставлениеРегистратор1	= "";
	ПоследнийПредставлениеРегистратор2	= "";
	СообщенияОбОшибках					= Новый Массив;
	ОшибкиПериодов						= Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		Если ТекущееФизлицо <> Выборка.Физлицо Тогда
			ТекущееФизлицо = Выборка.Физлицо;
			
		ИначеЕсли (ПоследняяДатаОкончания > Выборка.ДатаНачала) ИЛИ (ПоследняяДатаОкончания = '0001-01-01') Тогда
			ОшибкиПериодов[Выборка.Физлицо] = 0;
			Если СообщатьОбОшибкахПериодов и
				(ПоследнийРегистратор1 = Регистратор ИЛИ
				ПоследнийРегистратор2 = Регистратор ИЛИ
				Выборка.Регистратор1 = Регистратор ИЛИ
				Выборка.Регистратор2 = Регистратор) Тогда
				СообщениеОбОшибке = Новый Структура("Физлицо, ДатаНачала, ДатаОкончания, ДатаНачалаПред, ДатаОкончанияПред, Регистратор1, Регистратор2, ПослРегистратор1, ПослРегистратор2");
				СообщениеОбОшибке.Физлицо			= Выборка.ФизлицоНаименование;
				СообщениеОбОшибке.ДатаНачала		= Выборка.ДатаНачала;
				СообщениеОбОшибке.ДатаОкончания		= Выборка.ДатаОкончания;
				СообщениеОбОшибке.ДатаНачалаПред	= ПоследняяДатаНачала;
				СообщениеОбОшибке.ДатаОкончанияПред	= ПоследняяДатаОкончания;
				
				Если Выборка.Регистратор1 = Регистратор Тогда
					СообщениеОбОшибке.Регистратор1 = Выборка.ПредставлениеРегистратор1 + " (текущий документ)";
					
				Иначе
					СообщениеОбОшибке.Регистратор1 = "" + Выборка.ПредставлениеРегистратор1;
					
				КонецЕсли;
				
				Если Выборка.Регистратор2 = Регистратор Тогда
					СообщениеОбОшибке.Регистратор2 = Выборка.ПредставлениеРегистратор2 + " (текущий документ)";
					
				Иначе
					СообщениеОбОшибке.Регистратор2 = "" + Выборка.ПредставлениеРегистратор2;
					
				КонецЕсли;
				
				Если Выборка.Регистратор1 <> ПоследнийРегистратор1 
					и Выборка.Регистратор2 <> ПоследнийРегистратор1 Тогда
					Если ПоследнийРегистратор1 = Регистратор Тогда
						СообщениеОбОшибке.ПослРегистратор1 = ПоследнийПредставлениеРегистратор1 + " (текущий документ)";
						
					Иначе
						СообщениеОбОшибке.ПослРегистратор1 = "" + ПоследнийПредставлениеРегистратор1;
						
					КонецЕсли;
				КонецЕсли;
				
				Если Выборка.Регистратор1 <> ПоследнийРегистратор2 
					и Выборка.Регистратор2 <> ПоследнийРегистратор2 Тогда
					Если ПоследнийРегистратор2 = Регистратор Тогда
						СообщениеОбОшибке.ПослРегистратор2 = ПоследнийПредставлениеРегистратор2 + " (текущий документ)";
						
					Иначе
						СообщениеОбОшибке.ПослРегистратор2 = "" + ПоследнийПредставлениеРегистратор2;
						
					КонецЕсли;
				КонецЕсли;
				
				СообщенияОбОшибках.Добавить(СообщениеОбОшибке);
				
			КонецЕсли;
		КонецЕсли;
		
		ПоследнийРегистратор1				= Выборка.Регистратор1;
		ПоследнийРегистратор2				= Выборка.Регистратор2;
		ПоследнийПредставлениеРегистратор1	= Выборка.ПредставлениеРегистратор1;;
		ПоследнийПредставлениеРегистратор2	= Выборка.ПредставлениеРегистратор2;
		ПоследняяДатаНачала					= Выборка.ДатаНачала;
		ПоследняяДатаОкончания				= Выборка.ДатаОкончания;
	КонецЦикла;
	
	// запишем новое состояние ошибок
	НаборЗаписей = РегистрыСведений.ПериодыСостоянийРаботниковОшибки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Физлицо.Использование = Истина;
	Для Каждого Элемент Из мФизлица Цикл
		НаборЗаписей.Очистить();
		НаборЗаписей.Отбор.Физлицо.Значение = Элемент;
		// если ошибка периода - пишем непустой набор записей
		Если ОшибкиПериодов[Элемент] = 0 Тогда
			Строка = НаборЗаписей.Добавить();
			Строка.Физлицо = Элемент;
		КонецЕсли;
		НаборЗаписей.Записать();
	КонецЦикла;
	
	// сообщим об ошибках
	Если СообщатьОбОшибкахПериодов Тогда
		Для Каждого Сообщение Из СообщенияОбОшибках Цикл
			СтрокаСообщениеОбОшибке = Сообщение.Физлицо + ": Противоречие в периодах по состоянию" + Символы.ПС+ "(" + 
			Формат(Сообщение.ДатаНачала, "ДФ='дд МММ гг ""г.""'") + " - " + 
			Формат(Сообщение.ДатаОкончания, "ДФ='дд МММ гг ""г.""'") + " и " + 
			Формат(Сообщение.ДатаНачалаПред, "ДФ='дд МММ гг ""г.""'") + " - " + 
			Формат(Сообщение.ДатаОкончанияПред, "ДФ='дд МММ гг ""г.""'") + ")";
			СтрокаСообщениеОбОшибке = СтрокаСообщениеОбОшибке + Символы.ПС + "Документы, которые противоречат друг другу:";
			Если не ПустаяСтрока(Сообщение.Регистратор1) Тогда
				СтрокаСообщениеОбОшибке = СтрокаСообщениеОбОшибке + Символы.ПС + "   " + Сообщение.Регистратор1;
			КонецЕсли;
			Если не ПустаяСтрока(Сообщение.Регистратор2) Тогда
				СтрокаСообщениеОбОшибке = СтрокаСообщениеОбОшибке + Символы.ПС + "   " + Сообщение.Регистратор2;
			КонецЕсли;
			Если не ПустаяСтрока(Сообщение.ПослРегистратор1) Тогда
				СтрокаСообщениеОбОшибке = СтрокаСообщениеОбОшибке + Символы.ПС + "   " + Сообщение.ПослРегистратор1;
			КонецЕсли;
			Если не ПустаяСтрока(Сообщение.ПослРегистратор2) Тогда
				СтрокаСообщениеОбОшибке = СтрокаСообщениеОбОшибке + Символы.ПС + "   " + Сообщение.ПослРегистратор2;
			КонецЕсли;
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщениеОбОшибке);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Регистратор",	Отбор.Регистратор.Значение);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Периоды.Физлицо
	|ИЗ
	|	РегистрСведений.ПериодыСостоянийРаботников КАК Периоды
	|ГДЕ
	|	Периоды.Регистратор = &Регистратор";
	
	мФизлица = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Физлицо");
	
	ВыполнитьПроверку(РежимЗаписиРегистратора = РежимЗаписиДокумента.ОтменаПроведения, Ложь);
	
	ПустойНаборЗаписей = ЭтотОбъект.Количество() = 0;
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мФизлица.Очистить();
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		мФизлица.Добавить(Запись.Физлицо);
	КонецЦикла;

	Если Не ПустойНаборЗаписей Тогда
		ВыполнитьПроверку(РежимЗаписиРегистратора = РежимЗаписиДокумента.Проведение, Истина);
	КонецЕсли;
	
КонецПроцедуры // ПриЗаписи()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
