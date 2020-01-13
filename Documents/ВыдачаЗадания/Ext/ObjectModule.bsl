﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мДлинаСуток;

// Механизм исправлений
Перем мВосстанавливатьДвижения;
Перем мСоответствиеДвижений;
Перем мИсправляемыйДокумент;


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//	Название макета печати передается в качестве параметра,
//	по переданному названию находим имя макета в соответствии.
//
// Параметры:
//	НазваниеМакета	- строка, название макета.
//
Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ИмяМакета="Задание" ТОгда
		Если Не Проведен Тогда
			Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
		ТабДокумент=ПечатьЗадания();
		Возврат РаботаСДиалогами.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект,Метаданные().Синоним));
	КонецЕсли;
	

КонецФункции // Печать()

#КонецЕсли
// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//	Струткура, каждая строка которой соответствует одному из вариантов печати
//
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураМакетов = Новый Структура;	
	
	СтруктураМакетов.Вставить("Задание","Задание");
	Возврат СтруктураМакетов;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВыдачаЗадания.Дата,
	|	ВыдачаЗадания.ДатаЗадания,
	|	ВыдачаЗадания.Номер,
	|	ВыдачаЗадания.Организация,
	|	ВыдачаЗадания.Мастер,
	|	ВЫБОР
	|		КОГДА ВыдачаЗадания.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ВыдачаЗадания.Организация
	|		ИНАЧЕ ВыдачаЗадания.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.ВыдачаЗадания КАК ВыдачаЗадания
	|ГДЕ
	|	ВыдачаЗадания.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры: 
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса. В запросе данные документа дополняются значениями
//	проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",			Ссылка);
	Запрос.УстановитьПараметр("Организация",			Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",	ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.Сотрудник.Наименование,
	|	ТЧРаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
	|	ТЧРаботникиОрганизации.ВидРаботы КАК ВидРаботы,
	|	ТЧРаботникиОрганизации.ВидРаботыСсылка КАК ВидРаботыСсылка,
	|	ТЧРаботникиОрганизации.КодРаботы КАК КодРаботы,
	|	ТЧРаботникиОрганизации.ПродолжительностьРаботы,
	|	ТЧРаботникиОрганизации.АдресВыполненияРаботы,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.Ссылка.Дата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок
	|	КОНЕЦ КАК ЗанимаемыхСтавок,
	|	ВЫБОР
	|		КОГДА ТЧРаботникиОрганизации.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации
	|ИЗ
	|	Документ.ВыдачаЗадания.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МАКСИМУМ(Работники.Период) КАК Период
	|		ИЗ
	|			Документ.ВыдачаЗадания.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|				ПО (Работники.Период <= ТЧРаботникиОрганизации.Ссылка.Дата)
	|					И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
	|		ГДЕ
	|			ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ДатыПоследнихДвиженийРаботников
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ДатыПоследнихДвиженийРаботников.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|		ПО (ДанныеПоРаботникуДоНазначения.Период = ДатыПоследнихДвиженийРаботников.Период)
	|			И ТЧРаботникиОрганизации.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник
	|ГДЕ
	|	ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.ВидРаботы";
		
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

Функция СформироватьЗапросПоРаботникиОрганизацииДляПечати(ВыборкаПоШапкеДокумента)
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",			Ссылка);
	Запрос.УстановитьПараметр("Организация",			Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",	ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТЧРаботникиОрганизации.НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.Сотрудник.Наименование,
	|	ТЧРаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
	|	ТЧРаботникиОрганизации.ВидРаботы КАК ВидРаботы,
	|	ТЧРаботникиОрганизации.ВидРаботыСсылка КАК ВидРаботыСсылка,
	|	ТЧРаботникиОрганизации.КодРаботы КАК КодРаботы,
	|	СУММА(ТЧРаботникиОрганизации.ПродолжительностьРаботы) КАК ПродолжительностьРаботы,
	|	ТЧРаботникиОрганизации.АдресВыполненияРаботы,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.Ссылка.Дата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок
	|	КОНЕЦ КАК ЗанимаемыхСтавок,
	|	ВЫБОР
	|		КОГДА ТЧРаботникиОрганизации.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации
	|ИЗ
	|	Документ.ВыдачаЗадания.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МАКСИМУМ(Работники.Период) КАК Период
	|		ИЗ
	|			Документ.ВыдачаЗадания.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|				ПО (Работники.Период <= ТЧРаботникиОрганизации.Ссылка.Дата)
	|					И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
	|		ГДЕ
	|			ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ДатыПоследнихДвиженийРаботников
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ДатыПоследнихДвиженийРаботников.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|		ПО (ДанныеПоРаботникуДоНазначения.Период = ДатыПоследнихДвиженийРаботников.Период)
	|			И ТЧРаботникиОрганизации.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник
	|ГДЕ
	|	ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник.Наименование,
	|	ТЧРаботникиОрганизации.Сотрудник.Физлицо,
	|	ТЧРаботникиОрганизации.ВидРаботы,
	|	ТЧРаботникиОрганизации.ВидРаботыСсылка,
	|	ТЧРаботникиОрганизации.КодРаботы,
	|	ТЧРаботникиОрганизации.АдресВыполненияРаботы,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.Ссылка.Дата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТЧРаботникиОрганизации.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.НомерСтроки";
	//|	ТЧРаботникиОрганизации.ВидРаботы.Наименование";
	//|	ТЧРаботникиОрганизации.АдресВыполненияРаботы";
		
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация, работники которой отправляются в отпуск!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаЗадания) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана дата задания!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НачалоДня(ВыборкаПоШапкеДокумента.ДатаЗадания)<НачалоДня(ТекущаяДата()) И Не РольДоступна("ПолныеПрава") ТОгда
		ОбщегоНазначения.СообщитьОбОшибке("Нельзя создавать документ с датой, меньшей, чем текущая!", Отказ, Заголовок);
	КонецЕсли;
	

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка
//								  из результата запроса по работникам,
//	Отказ						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	""" табл. части ""Работники организации"": ";

	// Сотрудник
	НетСотрудника = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник);
	Если НетСотрудника Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;

	НетВидаРаботы = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидРаботы);
	Если НетВидаРаботы Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан вид работы!", Отказ, Заголовок);
	КонецЕсли;
	
	НетПродолжительности = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПродолжительностьРаботы);
	Если НетПродолжительности Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана продолжительность работы!", Отказ, Заголовок);
	КонецЕсли;

	Если НетСотрудника ИЛИ НетВидаРаботы или НетПродолжительности Тогда
		Возврат;
	КонецЕсли;
		
	// Организация сотрудника должна совпадать с организацией документа
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "указанный сотрудник оформлен на другую организацию!", Отказ, Заголовок);
	КонецЕсли;
		
	// Проверка: ранее работник должен быть принят на работу
	Если ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = NULL Тогда
		СтрокаПродолжениеСообщенияОбОшибке = "на " + Формат(ВыборкаПоШапкеДокумента.Дата, "ДЛФ=DD") + " работник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " еще не принят на работу!";
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
	ИначеЕсли ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = 0 Тогда	
		СтрокаПродолжениеСообщенияОбОшибке = "на " + Формат(ВыборкаПоШапкеДокумента.Дата, "ДЛФ=DD") + " работник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " уже уволен!";
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
	КонецЕсли; 
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры:
//	ВыборкаПоШапкеДокумента - выборка из результата запроса по шапке документа,
//	ВыборкаПоРаботникиОрганизации
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации)

	Движение = Движения.НарушенияПоОхранеТруда.Добавить();

	// Свойства
	Движение.Период			= ВыборкаПоШапкеДокумента.Дата;

	// Измерения
	Движение.Сотрудник		= ВыборкаПоРаботникиОрганизации.Сотрудник;
	Движение.Организация	= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
	Движение.ВидНарушения	= ВыборкаПоРаботникиОрганизации.ВидНарушения;
	Движение.ВидНаказания	= ВыборкаПоРаботникиОрганизации.ВидНаказания;

	// Ресурсы
	Движение.ДатаНарушения	= ВыборкаПоРаботникиОрганизации.ДатаНарушения;
	Движение.ДатаПриказа	= ВыборкаПоШапкеДокумента.ДатаПриказа;
	Движение.НомерПриказа	= ВыборкаПоШапкеДокумента.НомерПриказа;
	//реквизиты
	Движение.ОбособленноеПодразделение = ВыборкаПоШапкеДокумента.Организация;
		
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();

	//// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
	//	
	//	//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		Если НЕ Отказ Тогда
	//		
			ВыборкаПоРаботникиОрганизации = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);							
	//		
			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл 
	//			// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);

	//			Если НЕ Отказ Тогда
	//				// Заполним записи в наборах записей регистров
	//				ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации);

	//			КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаЗаполнения" модуля объекта
//
Процедура ОбработкаЗаполнения(Основание)

	ТипОснования = ТипЗнч(Основание);
	Если ТипОснования = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда	
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
		|	СотрудникиОрганизаций.Физлицо,
		|	СотрудникиОрганизаций.Организация,
		|	СотрудникиОрганизаций.ОбособленноеПодразделение
		|ИЗ
		|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
		|ГДЕ
		|	СотрудникиОрганизаций.Ссылка = &Сотрудник";
		Запрос.УстановитьПараметр("Сотрудник",	Основание);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если Не Выборка.ОбособленноеПодразделение.Пустая() Тогда
				Организация = Выборка.ОбособленноеПодразделение;
			Иначе
				Организация = Выборка.Организация;
			КонецЕсли;
			
			НоваяСтрока = РаботникиОрганизации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ДатаНачала	= ОбщегоНазначения.ПолучитьРабочуюДату();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации);	
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНаименованиеРаботы(Знач Код) Экспорт
	
	Спр=Справочники.ВидыРабот;
	
	к=Найти(Код,".");
	
	Наименование="";
	
	СтрКод="";
	
	ПервыйПроход=Истина;
	Пока к>0 Цикл
		
		СтрКод=СтрКод+?(ПервыйПроход,"",".")+Лев(Код,к-1);
		НайденнаяСсылка=Спр.НайтиПоРеквизиту("КодПоПрейскуранту",СтрКод+?(ПервыйПроход,"","-"));
		
		Если Не НайденнаяСсылка.Пустая() ТОгда
			Наименование=Наименование+СокрЛП(НайденнаяСсылка.Наименование)+" ";
		КонецЕсли;		
		
		Код=Сред(Код,к+1);
		
		к=Найти(Код,".");
		
		ПервыйПроход=Ложь;
		
	КонецЦикла;		
	
	
	Возврат Наименование;
	
КонецФункции

Функция  ПечатьЗадания()	
	ТабДок = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("Задание");
	// Шапка
	Шапка = Макет.ПолучитьОбласть("Шапка");
	
	ВыборкаПоШапке=СформироватьЗапросПоШапке().Выбрать();;
	
	Если ВыборкаПоШапке.Следующий()>0 Тогда
		
		Шапка.Параметры.Заполнить(ВыборкаПоШапке);
		Шапка.Параметры.ДатаЗадания=Формат(ВыборкаПоШапке.ДатаЗадания,"ДФ=dd.MM.yyyy");
		ОбластьРаботникиОрганизации = Макет.ПолучитьОбласть("Строка");
		
		ВыборкаПоРаботникам=СформироватьЗапросПоРаботникиОрганизацииДляПечати(ВыборкаПоШапке).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоРаботникам.СледующийПоЗначениюПоля("Сотрудник")>0 Цикл
			Шапка.Параметры.Сотрудник=ВыборкаПоРаботникам.Сотрудник;
			ТабДок.Вывести(Шапка);		
			ИтогоЧасов=0;
			НомерПП=1;
			//Пока ВыборкаПоРаботникам.СледующийПоЗначениюПоля("ВидРаботы")>0 Цикл
			Пока ВыборкаПоРаботникам.СледующийПоЗначениюПоля("НомерСтроки")>0 Цикл
				ОбластьРаботникиОрганизации.Параметры.Заполнить(ВыборкаПоРаботникам);
				ОбластьРаботникиОрганизации.Параметры.НомерСтроки=НомерПП;
				Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ВидРаботыСсылка) ТОгда
					ОбластьРаботникиОрганизации.Параметры.ВидРаботы=ВыборкаПоРаботникам.КодРаботы+" "+СтрЗаменить(ВыборкаПоРаботникам.ВидРаботыСсылка.ПолноеНаименование(),"ПРЕЙСКУРАНТЫ ОБЛГАЗА/","");				
				Иначе
					ОбластьРаботникиОрганизации.Параметры.ВидРаботы=ВыборкаПоРаботникам.ВидРаботы;				
				КонецЕсли;				
				ТабДок.Вывести(ОбластьРаботникиОрганизации);
				ИтогоЧасов=ИтогоЧасов+ВыборкаПоРаботникам.ПродолжительностьРаботы;
				НомерПП=НомерПП+1;
			КонецЦикла;		
			
			ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
			ОбластьПодвал.Параметры.ИтогоЧасов=ИтогоЧасов;
			ОбластьПодвал.Параметры.Мастер=УправлениеОтчетамиЗК.ФамилияИнициалыОтветсвенногоЛица(ВыборкаПоШапке.Мастер);
			ОбластьПодвал.Параметры.Сотрудник=УправлениеОтчетамиЗК.ФамилияИнициалыОтветсвенногоЛица(ВыборкаПоРаботникам.Сотрудник);
			ТабДок.Вывести(ОбластьПодвал);

		
		КонецЦикла;
			
		ТабДок.ОтображатьСетку = Ложь;
		ТабДок.АвтоМасштаб=Истина;
		ТабДок.ОриентацияСтраницы=ОриентацияСтраницы.Портрет;
		ТабДок.Защита = Ложь;
		ТабДок.ТолькоПросмотр = Истина;
		ТабДок.ОтображатьЗаголовки = Ложь;
	КонецЕсли;
	
	Возврат ТабДок;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;

мВосстанавливатьДвижения = Ложь;

