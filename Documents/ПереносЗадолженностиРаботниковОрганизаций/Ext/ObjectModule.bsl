﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура Автозаполнение() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("парамОрганизация",			Организация);
	Запрос.УстановитьПараметр("парамДата",					Макс(Дата,КонецМесяца(ПериодРегистрации) + 1));
	Запрос.УстановитьПараметр("парамМесяц",					ПериодРегистрации);
	
	Если ПодразделениеОрганизации.Пустая() Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.Физлицо,
		|	-ВзаиморасчетыСРаботникамиОрганизацииОстатки.СуммаВзаиморасчетовОстаток КАК Результат,
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.ПериодВзаиморасчетов КАК ПериодВозникновения
		|ИЗ
		|	РегистрНакопления.ВзаиморасчетыСРаботникамиОрганизаций.Остатки(
		|		&парамДата,
		|		Организация = &парамОрганизация
		|		    И ПериодВзаиморасчетов < &парамМесяц) КАК ВзаиморасчетыСРаботникамиОрганизацииОстатки
		|	
		|ГДЕ
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.СуммаВзаиморасчетовОстаток < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.Физлицо.Наименование,
		|	ПериодВозникновения";
		
	Иначе
		
		Запрос.УстановитьПараметр("ВнутреннееСовместительство",	Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство);
		Запрос.УстановитьПараметр("Прием",						Перечисления.ПричиныИзмененияСостояния.ПриемНаРаботу);
		Запрос.УстановитьПараметр("парамПодразделениеОрганизации",ПодразделениеОрганизации);
		Запрос.УстановитьПараметр("парамГоловнаяОрганизация",	ОбщегоНазначения.ГоловнаяОрганизация(Организация));
		Запрос.УстановитьПараметр("ПустаяДата",					'00010101');

		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.Физлицо,
		|	-ВзаиморасчетыСРаботникамиОрганизацииОстатки.СуммаВзаиморасчетовОстаток КАК Результат,
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.ПериодВзаиморасчетов КАК ПериодВозникновения
		|ИЗ
		|	РегистрНакопления.ВзаиморасчетыСРаботникамиОрганизаций.Остатки(
		|		&парамДата,
		|		Организация = &парамОрганизация
		|		    И ПериодВзаиморасчетов < &парамМесяц) КАК ВзаиморасчетыСРаботникамиОрганизацииОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|			ДатыДвижений.Физлицо КАК Физлицо
		|		ИЗ
		|			(ВЫБРАТЬ
		|				МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период,
		|				РаботникиОрганизаций.Сотрудник.Физлицо КАК Физлицо,
		|				РаботникиОрганизаций.Организация КАК Организация
		|			ИЗ
		|				РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|			ГДЕ
		|				РаботникиОрганизаций.Организация = &парамГоловнаяОрганизация
		|				И РаботникиОрганизаций.Период <= &парамДата
		|				И РаботникиОрганизаций.Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство
		|				И РаботникиОрганизаций.ПричинаИзмененияСостояния = &Прием
		|			
		|			СГРУППИРОВАТЬ ПО
		|				РаботникиОрганизаций.Сотрудник.Физлицо,
		|				РаботникиОрганизаций.Организация) КАК ДатыДвижений
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		|				ПО ДатыДвижений.Период = РаботникиОрганизаций.Период
		|					И ДатыДвижений.Организация = РаботникиОрганизаций.Организация
		|					И ДатыДвижений.Физлицо = РаботникиОрганизаций.Сотрудник.Физлицо
		|					И (РаботникиОрганизаций.Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство)
		|					И (РаботникиОрганизаций.ПричинаИзмененияСостояния = &Прием)) КАК Сотрудники
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(&парамДата, Организация = &парамГоловнаяОрганизация) КАК РаботникиОрганизацийСрезПоследних
		|			ПО Сотрудники.Сотрудник = РаботникиОрганизацийСрезПоследних.Сотрудник
		|				И (ВЫБОР
		|						КОГДА  РаботникиОрганизацийСрезПоследних.ПериодЗавершения <= &парамДата
		|							И РаботникиОрганизацийСрезПоследних.ПериодЗавершения <> &ПустаяДата
		|							ТОГДА РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизацииЗавершения
		|						ИНАЧЕ РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации
		|					КОНЕЦ  В ИЕРАРХИИ (&парамПодразделениеОрганизации))
		|		ПО ВзаиморасчетыСРаботникамиОрганизацииОстатки.Физлицо = Сотрудники.Физлицо
		|	
		|ГДЕ
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.СуммаВзаиморасчетовОстаток < 0
		|	И РаботникиОрганизацийСрезПоследних.Сотрудник ЕСТЬ НЕ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВзаиморасчетыСРаботникамиОрганизацииОстатки.Физлицо.Наименование,
		|	ПериодВозникновения";
	КонецЕсли;
	
	Задолженность.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры //Автозаполнение()

Процедура Рассчитать() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("парамОрганизация",	Организация);
	Запрос.УстановитьПараметр("парамДата",			Макс(Дата,КонецМесяца(ПериодРегистрации) + 1));
	Запрос.УстановитьПараметр("парамМесяц",			ПериодРегистрации);
	Запрос.УстановитьПараметр("Ссылка",				Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПереносЗадолженностиРаботниковОрганизацийЗадолженность.Физлицо,
	|	ПереносЗадолженностиРаботниковОрганизацийЗадолженность.ПериодВозникновения,
	|	-ВзаиморасчетыСРаботникамиОрганизацииОстатки.СуммаВзаиморасчетовОстаток КАК Результат
	|ИЗ
	|	Документ.ПереносЗадолженностиРаботниковОрганизаций.Задолженность КАК ПереносЗадолженностиРаботниковОрганизацийЗадолженность
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыСРаботникамиОрганизаций.Остатки(
	|		&парамДата,
	|		Организация = &парамОрганизация
	|		    И ПериодВзаиморасчетов < &парамМесяц
	|		    И Физлицо В
	|		        (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		            ПереносЗадолженностиРаботниковОрганизацийЗадолженность.Физлицо
	|		        ИЗ
	|		            Документ.ПереносЗадолженностиРаботниковОрганизаций.Задолженность КАК ПереносЗадолженностиРаботниковОрганизацийЗадолженность
	|		        ГДЕ
	|		            ПереносЗадолженностиРаботниковОрганизацийЗадолженность.Ссылка = &Ссылка)) КАК ВзаиморасчетыСРаботникамиОрганизацииОстатки
	|		ПО ПереносЗадолженностиРаботниковОрганизацийЗадолженность.Физлицо = ВзаиморасчетыСРаботникамиОрганизацииОстатки.Физлицо
	|			И ПереносЗадолженностиРаботниковОрганизацийЗадолженность.ПериодВозникновения = ВзаиморасчетыСРаботникамиОрганизацииОстатки.ПериодВзаиморасчетов
	|			И (ВзаиморасчетыСРаботникамиОрганизацииОстатки.СуммаВзаиморасчетовОстаток < 0)
	|ГДЕ
	|	ПереносЗадолженностиРаботниковОрганизацийЗадолженность.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПереносЗадолженностиРаботниковОрганизацийЗадолженность.НомерСтроки";
	
	Задолженность.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
	
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
	Запрос.УстановитьПараметр("ДокументСсылка",			Ссылка);
	Запрос.УстановитьПараметр("парамПустаяОрганизация",	Справочники.Организации.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПереносЗадолженностиРаботниковОрганизаций.Дата,
	|	ПереносЗадолженностиРаботниковОрганизаций.Организация,
	|	ПереносЗадолженностиРаботниковОрганизаций.ПериодРегистрации,
	|	ПереносЗадолженностиРаботниковОрганизаций.Ответственный,
	|	ПереносЗадолженностиРаботниковОрганизаций.Ссылка
	|ИЗ
	|	Документ.ПереносЗадолженностиРаботниковОрганизаций КАК ПереносЗадолженностиРаботниковОрганизаций
	|ГДЕ
	|	ПереносЗадолженностиРаботниковОрганизаций.Ссылка = &ДокументСсылка";
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Задолженность" документа
//
// Параметры:
//	нет
//
// Возвращаемое значение:
//	Результат запроса.
//
Функция СформироватьЗапросПоЗадолженность()

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",			Ссылка);

	// Описание текста запроса:
	// 1. Выборка "ТЧНачисления":
	//		Выбираются строки документа.
	// 2. Выборка "ПересекающиесяСтроки":
	//		Среди остальных строк документа ищем строки c совпадающими физлицом и периодом возникновения задолжности
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗадолженностьРаботниковОрганизаций.НомерСтроки КАК НомерСтроки,
	|	ЗадолженностьРаботниковОрганизаций.Физлицо КАК Физлицо,
	|	ЗадолженностьРаботниковОрганизаций.ПериодВозникновения,
	|	ЗадолженностьРаботниковОрганизаций.Результат КАК Результат,
	|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	|ИЗ
	|	Документ.ПереносЗадолженностиРаботниковОрганизаций.Задолженность КАК ЗадолженностьРаботниковОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереносЗадолженностиРаботниковОрганизаций.Задолженность КАК ПересекающиесяСтроки
	|		ПО ЗадолженностьРаботниковОрганизаций.Ссылка = ПересекающиесяСтроки.Ссылка
	|			И ЗадолженностьРаботниковОрганизаций.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
	|			И ЗадолженностьРаботниковОрганизаций.ПериодВозникновения = ПересекающиесяСтроки.ПериодВозникновения
	|			И ЗадолженностьРаботниковОрганизаций.Физлицо = ПересекающиесяСтроки.Физлицо
	|ГДЕ
	|	ЗадолженностьРаботниковОрганизаций.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗадолженностьРаботниковОрганизаций.НомерСтроки,
	|	ЗадолженностьРаботниковОрганизаций.Физлицо,
	|	ЗадолженностьРаботниковОрганизаций.ПериодВозникновения,
	|	ЗадолженностьРаботниковОрганизаций.Результат
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ
	|	СУММА(Результат)
	|ПО
	|	Физлицо";
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоЗадолженность()

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

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ПериодРегистрации) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан период (месяц) в который переносится задолженность!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Задолженность" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//								  из результата запроса по строкам документа, 
//	Отказ 						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиЗадолженность(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	""" табл. части ""Задолженность"": ";

	// Физлицо
	НетФизлицо = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Физлицо);
	Если НетФизлицо Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран работник!", Отказ, Заголовок);
	КонецЕсли;
	
	// ПериодВозникновения
	НетПериодВозникновения = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПериодВозникновения);
	Если НетПериодВозникновения Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан период возникновения задолженности!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НетФизлицо ИЛИ НетПериодВозникновения Тогда
		Возврат; // Дальше не проверяем
	КонецЕсли;
	
	Если ВыборкаПоСтрокамДокумента.ПериодВозникновения >= ВыборкаПоШапкеДокумента.ПериодРегистрации Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "период возникновения задолженности должен предшествовать периоду, В который она переносится!", Отказ, Заголовок);
	КонецЕсли;
	
	// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		СтрокаСообщениеОбОшибке = "указана повторяющаяся строка (см. строку  № " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеСтрокиЗадолженность()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры:
//	ВыборкаПоШапкеДокумента			- выборка из результата запроса по шапке документа
//	ВыборкаПоТЧ						- выборка из результата запроса по табличной части документа.
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоТЧ, ОбрабатываетсяПрошлыйПериод)
	
	Движение = Движения.ВзаиморасчетыСРаботникамиОрганизаций.Добавить();
	
	// Свойства
	Движение.Период					= Дата;
	Движение.ВидДвижения			= ВидДвиженияНакопления.Приход;
	
	// Измерения
	Движение.Организация			= ВыборкаПоШапкеДокумента.Организация;
	Движение.ФизЛицо				= ВыборкаПоТЧ.ФизЛицо;
	
	Если ОбрабатываетсяПрошлыйПериод Тогда // списано задолженности прошлых периодов за работником
		
		// т.к. процедура вызывается только когда учет задолженности ведется в разрезе периодов, то ПериодВзаиморасчетов заполняется безусловно
		Движение.ПериодВзаиморасчетов	= ВыборкаПоТЧ.ПериодВозникновения;
		
		// Ресурсы
		Движение.СуммаВзаиморасчетов	= ВыборкаПоТЧ.Результат;
		
	Иначе // перенесено задолженности за работником в текущий период
		
		// т.к. процедура вызывается только когда учет задолженности ведется в разрезе периодов, то ПериодВзаиморасчетов заполняется безусловно
		Движение.ПериодВзаиморасчетов	= ПериодРегистрации;
		
		// Ресурсы
		Движение.СуммаВзаиморасчетов	= -ВыборкаПоТЧ.Результат;
		
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамНакопления()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
		
	// Получение учетной политики по персоналу организации
	УчетЗадолженностиПоМесяцам	= ПроцедурыУправленияПерсоналом.ЗначениеУчетнойПолитикиПоПерсоналуОрганизации(глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"), Организация, "УчетЗадолженностиПоМесяцам");
	Если НЕ УчетЗадолженностиПоМесяцам Тогда
		Сообщить("Учет задолженности работников в разрезе месяцев ее образования не ведется!");
	Иначе
		РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();
		
		// Получим реквизиты шапки из запроса
		ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
		
		Если ВыборкаПоШапкеДокумента.Следующий() Тогда
			
			//Надо позвать проверку заполнения реквизитов шапки
			ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
			
			// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
			Если НЕ Отказ Тогда
				
				// получим реквизиты табличной части
				ВыборкаПоЗадолженности = СформироватьЗапросПоЗадолженность().Выбрать(ОбходРезультатаЗапроса.Прямой);
				
				Пока ВыборкаПоЗадолженности.Следующий() Цикл 
					
					Если ВыборкаПоЗадолженности.ТипЗаписи() = ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
						
						// проверим очередную строку табличной части
						ПроверитьЗаполнениеСтрокиЗадолженность(ВыборкаПоШапкеДокумента, ВыборкаПоЗадолженности, Отказ, Заголовок);
						
					КонецЕсли;
					
					Если НЕ Отказ Тогда
						
						// Заполним записи в наборах записей регистров
						ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоЗадолженности, ВыборкаПоЗадолженности.ТипЗаписи() = ТипЗаписиЗапроса.ДетальнаяЗапись);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(Задолженность,,"Физлицо");
	
КонецПроцедуры // ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
