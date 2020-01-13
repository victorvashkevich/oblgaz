﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мДлинаСуток;

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
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация",	Справочники.Организации.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОтсутствиеНаРаботеОрганизаций.Дата,
	|	ОтсутствиеНаРаботеОрганизаций.Организация,
	|	ВЫБОР КОГДА ОтсутствиеНаРаботеОрганизаций.Организация.ГоловнаяОрганизация = &ПустаяОрганизация ТОГДА ОтсутствиеНаРаботеОрганизаций.Организация ИНАЧЕ ОтсутствиеНаРаботеОрганизаций.Организация.ГоловнаяОрганизация КОНЕЦ КАК ГоловнаяОрганизация,
	|	ОтсутствиеНаРаботеОрганизаций.Ссылка
	|ИЗ
	|	Документ.ОтсутствиеПериодомНаРаботеОрганизаций КАК ОтсутствиеНаРаботеОрганизаций
	|
	|ГДЕ
	|	ОтсутствиеНаРаботеОрганизаций.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим	- режим проведения
//
// Возвращаемое значение:
//	Результат запроса. В запросе данные документа дополняются значениями
//	проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("ПустаяДата",	'00010101');
	

	// Описание текста запроса:
	// 1. Выборка "СтрокиДокумента": 
	//	Во вложенном запросе выбираются строки документа, к ним добавляется 
	//	дата предшествующего "дате начала" движения из рег-ра РаботникиОрганизации
	//
	// 2. Выборка "РаботникиОрганизации": 
	//	Для каждой строки документа выполняем срез по регистру РаботникиОрганизации на 
	//	дату ДатаНачала для выполнения движений по штатному расписаниюи и проверки, 
	//	работает ли работник на эту дату (использует данные выборки "СтрокиДокумента")
	//
	// 3. Выборка "ПересекающиесяСтроки": 
	//	Среди остальных строк документа ищем строки, имеющие ту же дату ДатаНачала
	//
	// 4. Выборка "ИмеющиесяСостояния": 
	//	В рег-ре СостояниеРаботниковОрганизации ищем движения на дату ДатаНачала
	//
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
	|				И РаботникиОрганизации.ПериодЗавершения <> &ПустаяДата
	|			ТОГДА РаботникиОрганизации.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ РаботникиОрганизации.ПодразделениеОрганизации
	|	КОНЕЦ КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
	|				И РаботникиОрганизации.ПериодЗавершения <> &ПустаяДата
	|			ТОГДА РаботникиОрганизации.ДолжностьЗавершения
	|		ИНАЧЕ РаботникиОрганизации.Должность
	|	КОНЕЦ КАК Должность,
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
	|				И РаботникиОрганизации.ПериодЗавершения <> &ПустаяДата
	|			ТОГДА РаботникиОрганизации.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ РаботникиОрганизации.ЗанимаемыхСтавок
	|	КОНЕЦ КАК ЗанимаемыхСтавок,
	|	СтрокиДокумента.НомерСтроки,
	|	СтрокиДокумента.ДатаНачала,
	|	СтрокиДокумента.ДатаОкончания,
	|	СтрокиДокумента.ДатаРаботыВВыходной,
	|	СтрокиДокумента.Сотрудник,
	|	СтрокиДокумента.Сотрудник.Наименование,
	|	РаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
	|	СтрокиДокумента.ОсвобождатьСтавку,
	|	СтрокиДокумента.ПричинаОтсутствия,
	|	СтрокиДокумента.ВнутрисменныхЧасов,
	|	СтрокиДокумента.ПричинаНетрудоспособности,
	|	СтрокиДокумента.Ссылка,
	|	СтрокиДокумента.ДатаИзменения,
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрока,
	|	ИмеющиесяСостояния.Состояние КАК КонфликтноеСостояние,
	|	ИмеющиесяСостояния.Регистратор.Представление КАК КонфликтныйДокумент,
	|	РаботникиОрганизации.УсловияТрудаИзмерение,
	|	РаботникиОрганизации.ВидДеятельностиИзмерение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Док.НомерСтроки КАК НомерСтроки,
	|		Док.ДатаНачала КАК ДатаНачала,
	|		Док.ДатаОкончания КАК ДатаОкончания,
	|		Док.ДатаРаботыВВыходной КАК ДатаРаботыВВыходной,
	|		Док.Сотрудник КАК Сотрудник,
	|		Док.ОсвобождатьСтавку КАК ОсвобождатьСтавку,
	|		Док.ПричинаОтсутствия КАК ПричинаОтсутствия,
	|		Док.ВнутрисменныхЧасов КАК ВнутрисменныхЧасов,
	|		Док.ПричинаНетрудоспособности КАК ПричинаНетрудоспособности,
	|		Док.Ссылка КАК Ссылка,
	|		МАКСИМУМ(Работники.Период) КАК ДатаИзменения
	|	ИЗ
	|		Документ.ОтсутствиеПериодомНаРаботеОрганизаций.РаботникиОрганизации КАК Док
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|			ПО Док.ДатаНачала >= Работники.Период
	|				И Док.Сотрудник = Работники.Сотрудник
	|	ГДЕ
	|		Док.Ссылка = &ДокументСсылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Док.НомерСтроки,
	|		Док.ДатаНачала,
	|		Док.ДатаОкончания,
	|		Док.ДатаРаботыВВыходной,
	|		Док.ОсвобождатьСтавку,
	|		Док.ПричинаОтсутствия,
	|		Док.ВнутрисменныхЧасов,
	|		Док.ПричинаНетрудоспособности,
	|		Док.Ссылка,
	|		Док.Сотрудник) КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|		ПО СтрокиДокумента.ДатаИзменения = РаботникиОрганизации.Период
	|			И СтрокиДокумента.Сотрудник = РаботникиОрганизации.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтсутствиеПериодомНаРаботеОрганизаций.РаботникиОрганизации КАК ПересекающиесяСтроки
	|		ПО СтрокиДокумента.Ссылка = ПересекающиесяСтроки.Ссылка
	|			И СтрокиДокумента.ДатаНачала = ПересекающиесяСтроки.ДатаНачала
	|			И СтрокиДокумента.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
	|			И СтрокиДокумента.Сотрудник = ПересекающиесяСтроки.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций КАК ИмеющиесяСостояния
	|		ПО СтрокиДокумента.ДатаНачала = ИмеющиесяСостояния.Период
	|			И СтрокиДокумента.Ссылка <> ИмеющиесяСостояния.Регистратор
	|			И СтрокиДокумента.Сотрудник = ИмеющиесяСостояния.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
	|				И РаботникиОрганизации.ПериодЗавершения <> &ПустаяДата
	|			ТОГДА РаботникиОрганизации.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ РаботникиОрганизации.ПодразделениеОрганизации
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
	|				И РаботникиОрганизации.ПериодЗавершения <> &ПустаяДата
	|			ТОГДА РаботникиОрганизации.ДолжностьЗавершения
	|		ИНАЧЕ РаботникиОрганизации.Должность
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.ДатаНачала >= РаботникиОрганизации.ПериодЗавершения
	|				И РаботникиОрганизации.ПериодЗавершения <> &ПустаяДата
	|			ТОГДА РаботникиОрганизации.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ РаботникиОрганизации.ЗанимаемыхСтавок
	|	КОНЕЦ,
	|	СтрокиДокумента.НомерСтроки,
	|	СтрокиДокумента.ДатаНачала,
	|	СтрокиДокумента.ДатаОкончания,
	|	СтрокиДокумента.ДатаРаботыВВыходной,
	|	СтрокиДокумента.ОсвобождатьСтавку,
	|	СтрокиДокумента.ПричинаОтсутствия,
	|	СтрокиДокумента.ВнутрисменныхЧасов,
	|	СтрокиДокумента.ПричинаНетрудоспособности,
	|	СтрокиДокумента.Ссылка,
	|	ИмеющиесяСостояния.Состояние,
	|	ИмеющиесяСостояния.Регистратор.Представление,
	|	СтрокиДокумента.ДатаИзменения,
	|	СтрокиДокумента.Сотрудник,
	|	СтрокиДокумента.Сотрудник.Наименование,
	|	РаботникиОрганизации.Сотрудник.Физлицо,
	|	РаботникиОрганизации.УсловияТрудаИзмерение,
	|	РаботникиОрганизации.ВидДеятельностиИзмерение,
	|	ВЫБОР
	|		КОГДА СтрокиДокумента.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ";
	
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
//	Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация!", Отказ, Заголовок);
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
//								  из результата запроса по товарам документа, 
//	Отказ						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	""" табл. части ""Работники организации"": ";
	
	// Сотрудник
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
	// Организация сотрудника должна совпадать с организацией документа
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "указанный сотрудник оформлен на другую организацию!", Отказ, Заголовок);
	КонецЕсли;
	
	// Дата "с"
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаНачала) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата изменения состояния!", Отказ, Заголовок);
	КонецЕсли;
	
	// Причина отсутствия
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПричинаОтсутствия) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указано состояние!", Отказ, Заголовок);
	КонецЕсли;
	
	Если ВыборкаПоСтрокамДокумента.ПричинаОтсутствия=Перечисления.СостоянияРаботникаОрганизации.Заболевание ТОгда
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПричинаНетрудоспособности) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана причина нетрудоспособности!", Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;	
	
	// Работник не должен быть уволенным.
	Если ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = 0 Тогда
		СтрокаСообщениеОбОшибке = "на " + Формат(ВыборкаПоСтрокамДокумента.ДатаНачала, "ДЛФ=DD") + " работник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " уже уволен (с " + Формат(ВыборкаПоСтрокамДокумента.ДатаИзменения, "ДЛФ=DD") + ")!";
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
		// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока <> NULL Тогда
		СтрокаСообщениеОбОшибке = "в строке " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока + " указана та же дата изменения состояния!"; 
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
	// Проверка: в регистре уже есть такое движение
	Если ВыборкаПоСтрокамДокумента.КонфликтноеСостояние <> NULL Тогда
		СтрокаСообщениеОбОшибке = "работник уже переведен в состояние """ + ВыборкаПоСтрокамДокумента.КонфликтноеСостояние + """ документом " + ВыборкаПоСтрокамДокумента.КонфликтныйДокумент + "!"; 
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// Создает и заполняет структуру, содержащую имена регистров сведений
// по которым надо проводить документ
//
// Параметры: 
//	СтруктураПроведенияПоРегистрамСведений	- структура, содержащая имена регистров сведений 
//											  по которым надо проводить документ
//
// Возвращаемое значение:
//	Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	СтруктураПроведенияПоРегистрамСведений.Вставить("СостояниеРаботниковОрганизаций");
	СтруктураПроведенияПоРегистрамСведений.Вставить("ПериодыСостоянийРаботниковОрганизаций");
	СтруктураПроведенияПоРегистрамСведений.Вставить("КомпенсацияЗаРаботуВВыходныеДни");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//	ВыборкаПоШапкеДокумента					- выборка из результата запроса по шапке документа,
//	СтруктураПроведенияПоРегистрамСведений	- структура, содержащая имена регистров 
//											  сведений по которым надо проводить документ,
//  СтруктураПараметров						- структура параметров проведения,
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "СостояниеРаботниковОрганизаций";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период			= ВыборкаПоРаботникиОрганизации.ДатаНачала;
		
		// Измерения
		Движение.Сотрудник		= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация	= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;

		// Ресурсы
		Движение.Состояние		= ВыборкаПоРаботникиОрганизации.ПричинаОтсутствия;
		// Свойства
		Движение.ПериодЗавершения		= ВыборкаПоРаботникиОрганизации.ДатаОкончания + мДлинаСуток;
		
		// Ресурсы
		Движение.СостояниеЗавершения	= Перечисления.СостоянияРаботникаОрганизации.Работает;	
		//реквизиты
		Движение.Внутрисменное		= ВыборкаПоРаботникиОрганизации.ВнутрисменныхЧасов>0;
	КонецЕсли;

	ИмяРегистра = "ПериодыСостоянийРаботниковОрганизаций";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда
		Движение = Движения[ИмяРегистра].Добавить();
			
		// Измерения
		Движение.Сотрудник	= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.ДатаНачала		= ВыборкаПоРаботникиОрганизации.ДатаНачала;		
		Движение.ДатаОкончания	= ВыборкаПоРаботникиОрганизации.ДатаОкончания;		
	КонецЕсли;
	
	ИмяРегистра = "КомпенсацияЗаРаботуВВыходныеДни";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда
		Если ВыборкаПоРаботникиОрганизации.ПричинаОтсутствия=Перечисления.СостоянияРаботникаОрганизации.ВыходнойЗаРанееОтработанноеВремя Тогда
			Движение = Движения[ИмяРегистра].Добавить();
			
			Движение.Период			= ВыборкаПоРаботникиОрганизации.ДатаНачала;
			
			// Измерения
			Движение.Организация	= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
			Движение.Сотрудник	     = ВыборкаПоРаботникиОрганизации.Сотрудник;
			Движение.ДатаРаботы	 	 = ВыборкаПоРаботникиОрганизации.ДатаРаботыВВыходной;		
			Движение.ДатаКомпенсации = ВыборкаПоРаботникиОрганизации.ДатаОкончания;		
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

// Создает и заполняет структуру, содержащую имена регистров накопления
// документа. В дальнейшем движения заносятся только по тем регистрам накопления, для которых в 
// данной процедуре заданы ключи
//
// Параметры:
//	СтруктураПроведенияПоРегистрамНакопления	- структура, содержащая имена регистров 
//												  накопления по которым надо проводить документ
//
// Возвращаемое значение:
//	Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамНакопления)

	СтруктураПроведенияПоРегистрамНакопления = Новый Структура();
	СтруктураПроведенияПоРегистрамНакопления.Вставить("ЗанятыеШтатныеЕдиницыОрганизаций");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры:
//	ВыборкаПоШапкеДокумента						- выборка из результата запроса по шапке документа
//	СтруктураПроведенияПоРегистрамНакопления	- структура, содержащая имена регистров 
//												  накопления по которым надо проводить документ
//	СтруктураПараметров							- структура параметров проведения.
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, 
		  СтруктураПроведенияПоРегистрамНакопления, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ЗанятыеШтатныеЕдиницыОрганизаций";
	Если СтруктураПроведенияПоРегистрамНакопления.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();
		
		// Свойства
		Движение.Период						= ВыборкаПоРаботникиОрганизации.ДатаНачала;
		Если ВыборкаПоРаботникиОрганизации.ПричинаОтсутствия = Перечисления.СостоянияРаботникаОрганизации.Работает Тогда
			Движение.ВидДвижения			= ВидДвиженияНакопления.Приход;
		Иначе
			Движение.ВидДвижения			= ВидДвиженияНакопления.Расход;
		КонецЕсли;

		// Измерения
		Движение.ПодразделениеОрганизации	= ВыборкаПоРаботникиОрганизации.ПодразделениеОрганизации;
		Движение.Должность					= ВыборкаПоРаботникиОрганизации.Должность;
		Движение.УсловияТрудаИзмерение		= ВыборкаПоРаботникиОрганизации.УсловияТрудаИзмерение;
		Движение.ВидДеятельностиИзмерение	= ВыборкаПоРаботникиОрганизации.ВидДеятельностиИзмерение;

		
		// Ресурсы
		Движение.КоличествоСтавок			= ВыборкаПоРаботникиОрганизации.ЗанимаемыхСтавок; 

	КонецЕсли;

КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамНакопления()

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//	Структура, каждая строка которой соответствует одному из вариантов печати
//	
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураМакетов = Новый Структура;	
	СтруктураМакетов.Вставить("Макет",	"Протокол");
	
	Возврат СтруктураМакетов;

	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Функция СформироватьДокумент()
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПремииРаботниковОрганизации_Расчет";
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = ПолучитьМакет("Протокол");
	
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока=Макет.ПолучитьОбласть("Строка");
	ОбластьПредседатель=Макет.ПолучитьОбласть("Председатель");
	ОбластьЧленКомиссии=Макет.ПолучитьОбласть("ЧленКомиссии");
	
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("СписокДокументов",РаботникиОрганизации.ВыгрузитьКолонку("БольничныйЛист"));
	
	Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДниОплаты.Ссылка,
	|	ДниОплаты.Ссылка.Дата КАК ДатаВыдачи,
	|	ДниОплаты.Ссылка.Физлицо.Наименование КАК Сотрудник,
	|	ДниОплаты.Ссылка.ДатаНачала КАК Начало,
	|	ДниОплаты.Ссылка.ДатаОкончания КАК Окончание,
	|	ДниОплаты.Ссылка.НомерВходящегоДокумента КАК Номер,
	|	ДниОплаты.Ссылка.СерияВходящегоДокумента КАК Серия,
	|	ДниОплаты.Ссылка.Диагноз КАК Диагноз,
	|	СУММА(ДниОплаты.Дней100) КАК Дней100,
	|	СУММА(ДниОплаты.Дней80) КАК Дней80,
	|	СУММА(ДниОплаты.Дней80)+СУММА(ДниОплаты.Дней100) КАК ДнейБолезни
	|ИЗ
	|	(ВЫБРАТЬ
	|		НачислениеПоБольничномуЛистуНачисления.Ссылка КАК Ссылка,
	|		НачислениеПоБольничномуЛистуНачисления.ОплаченоДнейЧасов КАК Дней100,
	|		0 КАК Дней80
	|	ИЗ
	|		Документ.НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛистуНачисления
	|	ГДЕ
	|		НачислениеПоБольничномуЛистуНачисления.Показатель1 > 80
	|		И НачислениеПоБольничномуЛистуНачисления.Ссылка В (&СписокДокументов) 
	|		И НачислениеПоБольничномуЛистуНачисления.Ссылка.ВидРасчета = НачислениеПоБольничномуЛистуНачисления.ВидРасчета
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НачислениеПоБольничномуЛистуНачисления.Ссылка,
	|		0,
	|		НачислениеПоБольничномуЛистуНачисления.ОплаченоДнейЧасов
	|	ИЗ
	|		Документ.НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛистуНачисления
	|	ГДЕ
	|		НачислениеПоБольничномуЛистуНачисления.Показатель1 <= 80
	|		И НачислениеПоБольничномуЛистуНачисления.Ссылка В (&СписокДокументов) 
	|		И НачислениеПоБольничномуЛистуНачисления.Ссылка.ВидРасчета = НачислениеПоБольничномуЛистуНачисления.ВидРасчета) КАК ДниОплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ДниОплаты.Ссылка";
	
	Выборка=Запрос.Выполнить().Выбрать();
	
	
	Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Номер КАК НомерДок,
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Дата КАК ДатаДок,
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Организация,
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Председатель,
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Комиссия1,
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Комиссия2
	|ИЗ
	|	Документ.ПротоколКомиссииПоСоцСтрахуОрганизаций КАК ПротоколКомиссииПоСоцСтрахуОрганизаций
	|ГДЕ
	|	ПротоколКомиссииПоСоцСтрахуОрганизаций.Ссылка = &парамСсылка";
	
	Запрос.УстановитьПараметр("парамСсылка",Ссылка);
	
	ВыборкаПоШапке=Запрос.Выполнить().Выбрать();
	ВыборкаПоШапке.Следующий();
	
	ОбластьШапка.Параметры.Заполнить(ВыборкаПоШапке);
	ОбластьШапка.Параметры.ДатаДок=Формат(ВыборкаПоШапке.ДатаДок,"ДЛФ=DD");
	ТабДокумент.Вывести(ОбластьШапка);
	
	НомерСтроки=1;
	
	Пока Выборка.Следующий() Цикл	
		
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ОбластьСтрока.Параметры.НомерСтроки=НомерСтроки;
		ОбластьСтрока.Параметры.Начало=Формат(Выборка.Начало,"ДФ=dd.MM.yy");
		ОбластьСтрока.Параметры.Окончание=Формат(Выборка.Окончание,"ДФ=dd.MM.yy");
		ТабДокумент.Вывести(ОбластьСтрока);
		НомерСтроки=НомерСтроки+1;
		
	КонецЦикла;
	
	Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЧленыКомиссии.ФизЛицо КАК ФизЛицо
	|ИЗ
	|	Документ.ПротоколКомиссииПоСоцСтрахуОрганизаций.ЧленыКомиссии КАК ЧленыКомиссии
	|ГДЕ
	|	ЧленыКомиссии.Ссылка = &парамСсылка";
	
	Запрос.УстановитьПараметр("парамСсылка",Ссылка);
	
	ВыборкаПоКомиссии=Запрос.Выполнить().Выбрать();
	
	ОбластьПредседатель.Параметры.Председатель=УправлениеОтчетамиЗК.ФамилияИнициалыОтветсвенногоЛица(ВыборкаПоШапке.Председатель);
	ТабДокумент.Вывести(ОбластьПредседатель);
	
	Пока ВыборкаПоКомиссии.Следующий() Цикл
		ОбластьЧленКомиссии.Параметры.ЧленКомиссии=УправлениеОтчетамиЗК.ФамилияИнициалыОтветсвенногоЛица(ВыборкаПоКомиссии.ФизЛицо);	
		ТабДокумент.Вывести(ОбластьЧленКомиссии);
	КонецЦикла;
	
	Возврат ТабДокумент;
	
	
КонецФункции

Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	Если Не Проведен Тогда
		Предупреждение("Документ можно распечатать только после расчета и проведения!");
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяМакета="Макет" ТОгда
		
		ТабДокумент=СформироватьДокумент();
		
		Возврат РаботаСДиалогами.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, РаботаСДиалогами.СформироватьЗаголовокДокумента(ЭтотОбъект,Метаданные().Синоним));		
		
	Иначе
		
	КонецЕсли;
	

 КонецФункции // Печать()
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров накопления, по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	//структура, содержащая имена регистров сведений, по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;

	//структура, содержащая имена регистров расчета, по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамРасчета;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда
			
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации);
	КраткийСоставДокумента = "";
	
	Для каждого СтрокаТЧ Из РаботникиОрганизации Цикл
		
		ФИОФизЛица = ПроцедурыУправленияПерсоналом.ФамилияИнициалыФизЛица(СтрокаТЧ.БольничныйЛист.Сотрудник.Наименование);
		Если Найти(КраткийСоставДокумента, ФИОФизЛица) = 0 Тогда
			
			Если СтрДлина(КраткийСоставДокумента) < 100 Тогда
				КраткийСоставДокумента = КраткийСоставДокумента + ", " + ФИОФизЛица;
			Иначе
				КраткийСоставДокумента = Сред(КраткийСоставДокумента,3,95) + "...";
				Прервать;
			КонецЕсли;
			
		КонецЕсли; 
	
	КонецЦикла;
	
	Если Лев(КраткийСоставДокумента,2) = ", " Тогда
		ДлинаСтроки = СтрДлина(КраткийСоставДокумента);
		Если ДлинаСтроки < 100 Тогда
			КраткийСоставДокумента = Сред(КраткийСоставДокумента,3)
		Иначе
			КраткийСоставДокумента = Сред(КраткийСоставДокумента,3,95) + "...";
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаЗаполнения(Основание)

	ТипОснования = ТипЗнч(Основание);
	Если ТипОснования = Тип("ДокументСсылка.ОтсутствиеНаРаботе") Тогда

		// Заполним реквизиты из стандартного набора.
		ОбщегоНазначения.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		Если Основание.Проведен Тогда
			
			ТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");
			
			Если Организация.Пустая() Тогда
				Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекущийПользователь, "ОсновнаяОрганизация")
			КонецЕсли;
			
			Запрос = Новый Запрос;
			
			Запрос.УстановитьПараметр("Основание",	Основание);
	
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОтсутствиеНаРаботеРаботники.Сотрудник,
			|	ОтсутствиеНаРаботеРаботники.ФизЛицо,
			|	ОтсутствиеНаРаботеРаботники.ПричинаОтсутствия,
			|	ОтсутствиеНаРаботеРаботники.ОсвобождатьСтавку,
			|	ОтсутствиеНаРаботеРаботники.ДатаНачала
			|ИЗ
			|	Документ.ОтсутствиеНаРаботе.Работники КАК ОтсутствиеНаРаботеРаботники
			|ГДЕ
			|	ОтсутствиеНаРаботеРаботники.Ссылка = &Основание";
			
			РаботникиОрганизации.Загрузить(Запрос.Выполнить().Выгрузить());
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;
