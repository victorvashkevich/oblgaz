﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ТекущиеОстатки(Организация, Дата, УчитыватьДанныеДокумента = Ложь, Ссылка = Неопределено, ДатаПлатежа = Неопределено) Экспорт
	
	СтруктураОстатков = Новый Структура("ФСЗН",0);
	
	Если   ЗначениеЗаполнено(ДатаПлатежа) Тогда
		ДатаОстатка = ДатаПлатежа;
	Иначе
		ДатаОстатка = Дата;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДатаОстатка",			ДатаОстатка);
		Запрос.УстановитьПараметр("Организация",			Организация);

	Если УчитыватьДанныеДокумента И ЗначениеЗаполнено(ДатаПлатежа) И ДатаПлатежа < ДатаОстатка Тогда
		Запрос.УстановитьПараметр("Ссылка",	Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыПоСтраховымВзносам.ФСЗН
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	РегистрНакопления.РасчетыПоСтраховымВзносам КАК РасчетыПоСтраховымВзносам
		|ГДЕ
		|	РасчетыПоСтраховымВзносам.Регистратор = &Ссылка
		|	И РасчетыПоСтраховымВзносам.Организация = &Организация
		|	И РасчетыПоСтраховымВзносам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)";	
	Иначе 
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	0 КАК ФСЗН
		|ПОМЕСТИТЬ ВТДанныеДокумента";	
	КонецЕсли;
	Запрос.Выполнить();
		
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(СУММА(ДанныеДляСуммирования.ФСЗН) КАК ЧИСЛО(15, 0))) > 0
	|			ТОГДА ВЫРАЗИТЬ(СУММА(ДанныеДляСуммирования.ФСЗН) КАК ЧИСЛО(15, 0))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ФСЗН
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОстатки.ФСЗНОстаток КАК ФСЗН
	|	ИЗ
	|		РегистрНакопления.РасчетыПоСтраховымВзносам.Остатки(&ДатаОстатка, Организация = &Организация) КАК РасчетыПоСтраховымВзносамОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДанныеДокумента.ФСЗН
	|	ИЗ
	|		ВТДанныеДокумента КАК ДанныеДокумента) КАК ДанныеДляСуммирования";
	
		Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтруктураОстатков,Выборка);
	КонецЦикла;
	
	Возврат СтруктураОстатков
	
КонецФункции // ТекущиеОстатки()

Процедура Автозаполнение() Экспорт

	СтрокаЗаполняемыхПолей = "ФСЗН";
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,ТекущиеОстатки(Организация, Дата,  Проведен, Ссылка, ДатаПлатежа),СтрокаЗаполняемыхПолей);
	
	СведенияОВзносах.Загрузить(ТекущиеОстаткиПоСотрудникам(Организация).Выгрузить(ОбходРезультатаЗапроса.Прямой));
	
КонецПроцедуры

Функция ТекущиеОстаткиПоСотрудникам(Организация, УчитыватьДанныеДокумента = Ложь, ФизЛица = Неопределено, ПолучатьИтоги = Ложь) Экспорт
	
	ДатаОстатка = ДатаПлатежа;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДатаОстатка",    ДатаОстатка);
	Запрос.УстановитьПараметр("Организация",    Организация);
	Запрос.УстановитьПараметр("ПоВсемФизЛицам", ФизЛица = Неопределено);
	Запрос.УстановитьПараметр("ФизЛица", ФизЛица);


	
	Если УчитыватьДанныеДокумента И ЗначениеЗаполнено(ДатаПлатежа) И ДатаПлатежа < ДатаОстатка Тогда
		Запрос.УстановитьПараметр("Ссылка",	Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыПоСтраховымВзносам.ФСЗН,
		|	РасчетыПоСтраховымВзносам.ФизЛицо,
		|	РасчетыПоСтраховымВзносам.МесяцРасчетногоПериода
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	РегистрНакопления.РасчетыПоСтраховымВзносам КАК РасчетыПоСтраховымВзносам
		|ГДЕ
		|	РасчетыПоСтраховымВзносам.Регистратор = &Ссылка
		|	И РасчетыПоСтраховымВзносам.Организация = &Организация
		|	И РасчетыПоСтраховымВзносам.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И (&ПоВсемФизЛицам
		|			ИЛИ РасчетыПоСтраховымВзносам.ФизЛицо В (&ФизЛица))";	
	Иначе 
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК ФизЛицо,
		|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК МесяцРасчетногоПериода,
		|	0 КАК ФСЗН
		|ПОМЕСТИТЬ ВТДанныеДокумента";	
	КонецЕсли;
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СУММА(ДанныеДляСуммирования.ФСЗН) КАК ЧИСЛО(15, 0)) КАК ВзносыИсчиленные,
	|	ДанныеДляСуммирования.ФизЛицо КАК ФизЛицо,
	|	ДанныеДляСуммирования.МесяцРасчетногоПериода
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОстатки.ФСЗНОстаток КАК ФСЗН,
	|		РасчетыПоСтраховымВзносамОстатки.ФизЛицо КАК ФизЛицо,
	|		РасчетыПоСтраховымВзносамОстатки.МесяцРасчетногоПериода КАК МесяцРасчетногоПериода
	|	ИЗ
	|		РегистрНакопления.РасчетыПоСтраховымВзносам.Остатки(
	|				&ДатаОстатка,
	|				Организация = &Организация
	|					И (&ПоВсемФизЛицам
	|						ИЛИ ФизЛицо В (&ФизЛица))) КАК РасчетыПоСтраховымВзносамОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДанныеДокумента.ФСЗН,
	|		ДанныеДокумента.ФизЛицо,
	|		ДанныеДокумента.МесяцРасчетногоПериода
	|	ИЗ
	|		ВТДанныеДокумента КАК ДанныеДокумента) КАК ДанныеДляСуммирования
	|ГДЕ
	|	ДанныеДляСуммирования.ФизЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДляСуммирования.ФизЛицо,
	|	ДанныеДляСуммирования.МесяцРасчетногоПериода";
	
	Если ПолучатьИтоги Тогда
		Запрос.Текст = Запрос.Текст +"
		|ИТОГИ
		|	СУММА(ВзносыИсчиленные)
		|ПО
		|	ОБЩИЕ,
		|	ФизЛицо";
	КонецЕсли;
	
	Возврат Запрос.Выполнить();

КонецФункции

Процедура АвтозаполениеПоСотрудникам(Организация, УчитыватьДанныеДокумента = Ложь) Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамСсылка",Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.ФизЛицо,
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.МесяцРасчетногоПериода,
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.ФСЗН
	|ИЗ
	|	Документ.РасчетыПоСтраховымВзносам.СведенияОВзносах КАК РасчетыПоСтраховымВзносамСведенияОВзносах
	|ГДЕ
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.Ссылка = &парамСсылка";

	ВременнаяТаблица = Запрос.Выполнить().Выгрузить();
	ФизЛица = ВременнаяТаблица.ВыгрузитьКолонку("ФизЛицо");
	ВыборкаОбщая  = ТекущиеОстаткиПоСотрудникам(Организация, УчитыватьДанныеДокумента, ФизЛица,Истина).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
    СведенияОВзносах.Очистить();
	ВсегоВзносов = 0;
	ВсегоВзносовПоФизЛицу = 0;
	ВсегоРаспределитьПоФизЛицу = 0;
	Пока ВыборкаОбщая.Следующий() Цикл
		ВсегоВзносов = ВыборкаОбщая.ВзносыИсчиленные;
		ВыборкаПоФизЛицу = ВыборкаОбщая.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоФизЛицу.Следующий() Цикл
			ВсегоВзносовПоФизЛицу = ВыборкаПоФизЛицу.ВзносыИсчиленные;
			ВсегоРаспределитьПоФизЛицу = ФСЗН * ВсегоВзносовПоФизЛицу/ВсегоВзносов;
			
			ВыборкаПоМесяцам = ВыборкаПоФизЛицу.Выбрать();
			Пока ВыборкаПоМесяцам.Следующий() Цикл
				Распределено = 0;
				Строка = СведенияОВзносах.Добавить();
				ЗаполнитьЗначенияСвойств(Строка,ВыборкаПоМесяцам);
				Если ВсегоРаспределитьПоФизЛицу > 0 ИЛИ ВыборкаПоМесяцам.ВзносыИсчиленные > 0  тогда
					Распределено =  ?(ВсегоРаспределитьПоФизЛицу > ВыборкаПоМесяцам.ВзносыИсчиленные,ВыборкаПоМесяцам.ВзносыИсчиленные,ВсегоРаспределитьПоФизЛицу);
					ВсегоРаспределитьПоФизЛицу = ВсегоРаспределитьПоФизЛицу - Распределено;
					Строка.ФСЗН =  Распределено;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
	//СведенияОВзносах.Загрузить(Запрос.Выполнить().Выгрузить());


	
КонецПроцедуры
// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	Возврат Новый Структура();
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(Отказ, Заголовок = "")

	Если Не ЗначениеЗаполнено(Организация) Тогда
		СтрокаСообщения = ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса("Не указана организация!");
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаСообщения, Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(МесяцРасчетногоПериода) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке("Не указан расчетный период !", Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПлатежа) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке("Не указана дата операции!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

Функция СформироватьЗапросПоСведенияОВзносах()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамСсылка",Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.ФизЛицо,
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.МесяцРасчетногоПериода,
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.ФСЗН
	|ИЗ
	|	Документ.РасчетыПоСтраховымВзносам.СведенияОВзносах КАК РасчетыПоСтраховымВзносамСведенияОВзносах
	|ГДЕ
	|	РасчетыПоСтраховымВзносамСведенияОВзносах.Ссылка = &парамСсылка
	|	И РасчетыПоСтраховымВзносамСведенияОВзносах.ФСЗН <> 0";
	
	Возврат Запрос.Выполнить()
КонецФункции

Процедура ДобавитьДвижениеПоРасчетыПоСтраховымВзносам(ВыборкаПоСтрокамДокумента)
	
	Если ВидОперации = Перечисления.ВидыОперацийРасчетыПоСтраховымВзносам.Начисление Или ВидОперации = Перечисления.ВидыОперацийРасчетыПоСтраховымВзносам.ДоначислениеВзносов Тогда
		Движение = Движения.РасчетыПоСтраховымВзносам.ДобавитьПриход();
	Иначе
		Движение = Движения.РасчетыПоСтраховымВзносам.ДобавитьРасход();
	КонецЕсли;
	
	Движение.Период = ДатаПлатежа;
	Движение.Организация = Организация;
	Движение.ВидПлатежа = ВидПлатежа;
	ЗаполнитьЗначенияСвойств(Движение,ВыборкаПоСтрокамДокумента);
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ПроверитьЗаполнениеШапки(Отказ, Заголовок);
	
	Если Отказ Тогда
		ОбработкаКомментариев.ПоказатьСообщения();
		Возврат;
	КонецЕсли;
	
	ВыборкаПоСтрокамДокумента = СформироватьЗапросПоСведенияОВзносах().Выбрать();

	Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл
		ДобавитьДвижениеПоРасчетыПоСтраховымВзносам(ВыборкаПоСтрокамДокумента);
	КонецЦикла;
		
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Если ВидОперации = Перечисления.ВидыОперацийРасчетыПоСтраховымВзносам.УдалитьУплата Тогда
		ВидОперации = Перечисления.ВидыОперацийРасчетыПоСтраховымВзносам.УплатаПФР
	КонецЕсли;
КонецПроцедуры

