﻿Перем СохраненнаяНастройка Экспорт;       // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;     // Таблица вариантов доступных текущему пользователю

Перем НастрокаПриВыводеОтчета Экспорт;    // Настрока которая применялась при выводе отчета

Перем ДиаграммаГанта Экспорт;


Функция ПолучитьДополнительныеНастройкиОтчета() Экспорт
	МассивДополнительныхНастроек = Новый Массив;
	МассивДополнительныхНастроек.Добавить(Новый Структура("Имя, Заголовок, ЗначениеПоУмолчанию", "ВыводитьДиаграммуГанта", "Выводить диаграмму", истина));
	Возврат МассивДополнительныхНастроек;
КонецФункции	
	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
		  
	ЗначениеПанелипользователя = ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователяОбъекта(ЭтотОбъект);
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТекущаяДата"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = КонецДня(ОбщегоНазначения.ПолучитьРабочуюДату());
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	Если ЗначениеПараметра <> Неопределено И (ЗначениеПараметра.Значение = '00010101' или ЗначениеПараметра.Значение = Неопределено) Тогда
		ЗначениеПараметра.Значение      = КонецМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	Если ЗначениеПараметра <> Неопределено И (ЗначениеПараметра.Значение = '00010101' или ЗначениеПараметра.Значение = Неопределено) Тогда
		ЗначениеПараметра.Значение      = '10000101';
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	НаборДанных = ПолучитьВнешнийНаборДанных();
	
	РезультатФормированияОтчета = ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, НаборДанных, ложь);
	
	Если РезультатФормированияОтчета = Неопределено тогда
		РезультатФормированияОтчета = Результат;
	КонецЕсли;
	
	Если ((ТипЗнч(РезультатФормированияОтчета) = Тип("ТабличныйДокумент") 
		ИЛИ ТипЗнч(РезультатФормированияОтчета) = Тип("ПолеТабличногоДокумента"))) И ЗначениеПанелипользователя <> Неопределено И ЗначениеПанелипользователя.ВыводитьДиаграммуГанта тогда
		ДобавитьДиаграммуГантаВТабличныйДокумент(РезультатФормированияОтчета, КомпоновщикНастроек.Настройки);
	КонецЕсли;

	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
	
	Возврат РезультатФормированияОтчета;
		
КонецФункции

Функция ПолучитьВнешнийНаборДанных()
	
	СтруктураНабораДанных = Новый Структура("ОписаниеОтпусков");
	
	ТаблицаЗначенийДанныеСОписанием = ПолучитьТаблицуОписанияОтпусков();
	
	СтруктураНабораДанных.ОписаниеОтпусков = ТаблицаЗначенийДанныеСОписанием;
	
	Возврат СтруктураНабораДанных;
	
КонецФункции

Функция ПолучитьТаблицуОписанияОтпусков()
	
	ТаблицаОписаний = Новый ТаблицаЗначений;
	ТаблицаОписаний.Колонки.Добавить("Сотрудник");
	ТаблицаОписаний.Колонки.Добавить("НачалоИнтервала");
	ТаблицаОписаний.Колонки.Добавить("КонецИнтервала");
	ТаблицаОписаний.Колонки.Добавить("Описание");
	ТаблицаОписаний.Колонки.Добавить("ДнейОтпуска");
	ТаблицаОписаний.Колонки.Добавить("ОтпускАвансом");
	ТаблицаОписаний.Колонки.Добавить("ВидЕжегодногоОтпуска");
	ТаблицаОписаний.Колонки.Добавить("Учет");

	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат ТаблицаОписаний;
	Иначе
		НачалоПериода = ПараметрНачалоПериода.Значение;
		КонецПериода  = ПараметрКонецПериода.Значение;
	КонецЕсли;
	
	Если НачалоПериода = '00010101' или КонецПериода = '00010101' или КонецПериода < НачалоПериода тогда
		Возврат ТаблицаОписаний;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("ДатаПослеНачала", КонецДня(НачалоПериода) + 1);
	Запрос.УстановитьПараметр("ТекущаяДата", ОбщегоНазначения.ПолучитьРабочуюДату());
	Запрос.УстановитьПараметр("ДатаСведений", КонецПериода);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|Данные.ФизЛицо КАК Сотрудник,
	|Данные.Сотрудник КАК Сотр,
	|Данные.Сотрудник.Наименование КАК Имя,
	|Данные.ВидЕжегодногоОтпуска Как ВидЕжегодногоОтпуска,
	|НАЧАЛОПЕРИОДА(Данные.НачалоИнтервала, ДЕНЬ) КАК ДатаНачала,
	|НАЧАЛОПЕРИОДА(Данные.КонецИнтервала, ДЕНЬ) КАК ДатаОкончания,
	|Данные.Учет,
	|Данные.Серия
	|ИЗ ("+ПолучитьТекстЗапросПоОтпускам(Запрос)+") КАК Данные
	|ГДЕ Данные.Учет = ""ПоУпрУчету""";
	
	ТаблицаПериодов = Запрос.Выполнить().Выгрузить();
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	//Запрос.МенеджерВременныхТаблиц.Закрыть();
	//ПостроительЗапросов = Новый ПостроительЗапроса;
	//ПостроительЗапросов.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЗначений);
	//
	//ПостроительЗапросов.Выполнить();
	
	//ТаблицаПериодов = ПостроительЗапросов.Результат.Выгрузить();
	СписокСотрудников = ТаблицаПериодов.Скопировать(,"Сотрудник, Сотр");
	СписокСотрудников.Свернуть("Сотрудник, Сотр");
	ТаблицаПериодов.Свернуть("сотрудник, ДатаНачала, ДатаОкончания");
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Число"));
	МассивТипов.Добавить(Тип("Null"));
	ОписаниеТипа = Новый ОписаниеТипов(Новый ОписаниеТипов(), МассивТипов);
	ТаблицаПериодов.Колонки.Добавить("НомерСтроки", ОписаниеТипа);
	
	Для сч = 0 по ТаблицаПериодов.Количество()-1 Цикл
		СтрокаТаблицыПериодов = ТаблицаПериодов[сч];
		СтрокаТаблицыПериодов.НомерСтроки = сч+1;
	КонецЦикла;
	
	ВыборкаПоОстаткам = ПроцедурыУправленияПерсоналомДополнительный.ПодготовитьДанныеПоУправленческимОтпускам(ТаблицаПериодов, Истина, , Истина);
	
	Пока ВыборкаПоОстаткам.Следующий() Цикл
		СтрокаТаблицыОписания                 = ТаблицаОписаний.Добавить();
		СтрокаТаблицыОписания.Сотрудник       = СписокСотрудников.Найти(ВыборкаПоОстаткам.ФизЛицо, "Сотрудник").Сотр;
		СтрокаТаблицыОписания.НачалоИнтервала = ВыборкаПоОстаткам.ДатаНачала;
		СтрокаТаблицыОписания.КонецИнтервала  = КонецДня(ВыборкаПоОстаткам.ДатаОкончания);
		СтрокаТаблицыОписания.Описание        = ПроцедурыУправленияПерсоналомПереопределяемый.ВернутьОписаниеОтпуска(ВыборкаПоОстаткам, Истина) + ". ";
		СтрокаТаблицыОписания.ДнейОтпуска     = ВыборкаПоОстаткам.ДнейОтпуска;
		СтрокаТаблицыОписания.ОтпускАвансом   = ВыборкаПоОстаткам.ОтпускАвансом;
		СтрокаТаблицыОписания.ВидЕжегодногоОтпуска = "";
		СтрокаТаблицыОписания.Учет = "ПоУпрУчету";
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|Данные.Сотрудник КАК Сотрудник,
	|Данные.Сотрудник.НАименование КАК Имя,
	|Данные.ВидЕжегодногоОтпуска Как ВидЕжегодногоОтпуска,
	|НАЧАЛОПЕРИОДА(Данные.НачалоИнтервала, ДЕНЬ) КАК ДатаНачала,
	|НАЧАЛОПЕРИОДА(Данные.КонецИнтервала, ДЕНЬ) КАК ДатаОкончания,
	|Данные.Учет,
	|Данные.Серия
	|ИЗ ("+ПолучитьТекстЗапросПоОтпускам(Запрос)+") КАК Данные
	|ГДЕ Данные.Учет = ""ПоРеглУчету"" И Данные.Серия = ""Факт""";
	
	ТаблицаПериодов = Запрос.Выполнить().Выгрузить();
	
	ТаблицаПериодов.Свернуть("сотрудник, ВидЕжегодногоОтпуска, ДатаНачала, ДатаОкончания");
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Число"));
	МассивТипов.Добавить(Тип("Null"));
	ОписаниеТипа = Новый ОписаниеТипов(Новый ОписаниеТипов(), МассивТипов);
	ТаблицаПериодов.Колонки.Добавить("НомерСтроки", ОписаниеТипа);
	
	Для сч = 0 по ТаблицаПериодов.Количество()-1 Цикл
		СтрокаТаблицыПериодов = ТаблицаПериодов[сч];
		СтрокаТаблицыПериодов.НомерСтроки = сч+1;
	КонецЦикла;
	
	ВыборкаПоОстаткам = ПроцедурыУправленияПерсоналом.ПодготовитьДанныеПоРегламентированнымОтпускам(ТаблицаПериодов, , , );
	
	Пока ВыборкаПоОстаткам.Следующий() Цикл
		СтрокаТаблицыОписания                 = ТаблицаОписаний.Добавить();
		СтрокаТаблицыОписания.Сотрудник       = ВыборкаПоОстаткам.Сотрудник;
		СтрокаТаблицыОписания.НачалоИнтервала = ВыборкаПоОстаткам.ДатаНачала;
		СтрокаТаблицыОписания.КонецИнтервала  = КонецДня(ВыборкаПоОстаткам.ДатаОкончания);
		СтрокаТаблицыОписания.Описание        = ПроцедурыУправленияПерсоналомПереопределяемый.ВернутьОписаниеОтпуска(ВыборкаПоОстаткам, Ложь) + ". ";
		СтрокаТаблицыОписания.ДнейОтпуска     = ВыборкаПоОстаткам.ДнейОтпуска;
		СтрокаТаблицыОписания.ОтпускАвансом   = ВыборкаПоОстаткам.ОтпускАвансом;
		СтрокаТаблицыОписания.ВидЕжегодногоОтпуска = ВыборкаПоОстаткам.ВидЕжегодногоОтпуска;
		СтрокаТаблицыОписания.Учет = "ПоРеглУчету";
	КонецЦикла;
	
	Возврат ТаблицаОписаний;
	
КонецФункции

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

Функция ВставитьПоместить(ТекстЗапроса, ВремТаб)
	НомерСимвола = Найти(ТекстЗапроса, "{ВЫБРАТЬ");
	ТекстЗапроса = Лев(ТекстЗапроса, НомерСимвола-1) + "
	|	ПОМЕСТИТЬ "+ВремТаб+" " + Прав(ТекстЗапроса, СтрДлина(ТекстЗапроса) - НомерСимвола+1);
	Возврат ТекстЗапроса;
КонецФункции

Функция ПолучитьУсловие(ВидСравнения)
	Условие = " ";
	Если ВидСравнения = ВидСравненияКомпоновкиДанных.Равно тогда
		Условие = " = ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно тогда
		Условие = " <> ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке тогда
		Условие = " В ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке тогда
		Условие = " НЕ В ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии ИЛИ ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии тогда
		Условие = " В Иерархии ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии ИЛИ ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии тогда
		Условие = " НЕ В Иерархии ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит тогда
		Условие = " ПОДОБНО ";
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит тогда
		Условие = " НЕ ПОДОБНО ";
	КонецЕсли;
	Возврат Условие;
КонецФункции

Функция ПолучитьСтрокуОтбора(СписокПолей, Запрос)
	СтрокаУсловия = "";
	МассивОтоборов = ТиповыеОтчеты.ПолучитьЭлементыОтбора(КомпоновщикНастроек);
	
	Для каждого ЭлементОтбора из МассивОтоборов Цикл
		Если СписокПолей.НайтиПоЗначению(Строка(ЭлементОтбора.ЛевоеЗначение)) <> Неопределено и ЭлементОтбора.Использование тогда
			Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("ПолеКомпоновкиДанных") тогда
				Продолжить;
			КонецЕсли;
			СтрокаУсловияПоля = "ИСТОЧНИКДАННЫХ." + Строка(ЭлементОтбора.ЛевоеЗначение) + ПолучитьУсловие(ЭлементОтбора.ВидСравнения) + "(&" + Строка(ЭлементОтбора.ЛевоеЗначение) + ")";
			СтрокаУсловия = СтрокаУсловия + ?(СтрДлина(СтрокаУсловия) <> 0, " И ", " ") + СтрокаУсловияПоля;
			Запрос.УстановитьПараметр(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение)
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаУсловия;
КонецФункции

Функция ПолучитьТекстЗапросПоОтпускам(Запрос)
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("Серия");
	СписокПолей.Добавить("Учет");
	СписокПолей.Добавить("ФизЛицо");
	СписокПолей.Добавить("Сотрудник");
	СписокПолей.Добавить("ВидЕжегодногоОтпуска");
	
	СтрокаУсловияПоля = ПолучитьСтрокуОтбора(СписокПолей, Запрос);
	
	ГрафикОтпусков = СхемаКомпоновкиДанных.НаборыДанных.Данные.Элементы.ГрафикОтпусков.Запрос;
	//ГрафикОтпусков = СтрЗаменить(ЗапросСКД, "РАЗРЕШЕННЫЕ", "");
	ГрафикОтпусков = ВставитьПоместить(ГрафикОтпусков, "ГрафикОтпусков");
	Запрос.Текст = ГрафикОтпусков + ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ГрафикОтпусков"), "");
	Запрос.Выполнить();
	
	//2. 
	ФактическиеОтпуска = СхемаКомпоновкиДанных.НаборыДанных.Данные.Элементы.ФактическиеОтпуска.Запрос;
	ФактическиеОтпуска = ВставитьПоместить(ФактическиеОтпуска, "ФактическиеОтпуска");
	Запрос.Текст = ФактическиеОтпуска + ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ФактическиеОтпуска"), "");

	Запрос.Выполнить();
	
	//3. 
	ГрафикОтпусковРаботниковОрганизаций = СхемаКомпоновкиДанных.НаборыДанных.Данные.Элементы.ГрафикОтпусковРаботниковОрганизаций.Запрос;
	ГрафикОтпусковРаботниковОрганизаций = ВставитьПоместить(ГрафикОтпусковРаботниковОрганизаций, "ГрафикОтпусковРаботниковОрганизаций");
	Запрос.Текст = ГрафикОтпусковРаботниковОрганизаций + ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ГрафикОтпусковРаботниковОрганизаций"), "");
	Запрос.Выполнить();
	
	//4. 
	ФактическиеОтпускаРаботниковОрганизаций = СхемаКомпоновкиДанных.НаборыДанных.Данные.Элементы.ФактическиеОтпускаРаботниковОрганизаций.Запрос;
	ФактическиеОтпускаРаботниковОрганизаций = ВставитьПоместить(ФактическиеОтпускаРаботниковОрганизаций, "ФактическиеОтпускаРаботниковОрганизаций");
  	Запрос.Текст = ФактическиеОтпускаРаботниковОрганизаций + ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ФактическиеОтпускаРаботниковОрганизаций"), "");
	Запрос.Выполнить();

	ТекстЗапрос = 
	"ВЫБРАТЬ
	|	ГрафикОтпусков.Регистратор,
	|	ГрафикОтпусков.НачалоИнтервала,
	|	ГрафикОтпусков.КонецИнтервала,
	|	ГрафикОтпусков.Серия,
	|	ГрафикОтпусков.Учет,
	|	ГрафикОтпусков.ФизЛицо,
	|	ГрафикОтпусков.Сотрудник,
	|	ГрафикОтпусков.Состояние КАК Состояние,
	|	ГрафикОтпусков.ВидЕжегодногоОтпуска КАК ВидЕжегодногоОтпуска
	|	ИЗ ГрафикОтпусков КАК ГрафикОтпусков " +  ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ГрафикОтпусков"), "") + "
	
	|	ОБЪЕДИНИТЬ ВСЕ 		
	|		
	|	ВЫБРАТЬ 
	|	ФактическиеОтпуска.Регистратор,
	|	ФактическиеОтпуска.НачалоИнтервала,
	|	ФактическиеОтпуска.КонецИнтервала,
	|	ФактическиеОтпуска.Серия,
	|	ФактическиеОтпуска.Учет,
	|	ФактическиеОтпуска.ФизЛицо,
	|	ФактическиеОтпуска.Сотрудник,
	|	"""",
	|	ФактическиеОтпуска.ВидЕжегодногоОтпуска
	|	ИЗ ФактическиеОтпуска КАК ФактическиеОтпуска" +  ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ФактическиеОтпуска"), "") + "
	|
	|	ОБЪЕДИНИТЬ ВСЕ 		
	|		
	|	ВЫБРАТЬ 
	|	ГрафикОтпусковРаботниковОрганизаций.Регистратор,
	|	ГрафикОтпусковРаботниковОрганизаций.НачалоИнтервала,
	|	ГрафикОтпусковРаботниковОрганизаций.КонецИнтервала,
	|	ГрафикОтпусковРаботниковОрганизаций.Серия,
	|	ГрафикОтпусковРаботниковОрганизаций.Учет,
	|	ГрафикОтпусковРаботниковОрганизаций.ФизЛицо,
	|	ГрафикОтпусковРаботниковОрганизаций.Сотрудник,
	|	ГрафикОтпусковРаботниковОрганизаций.Состояние,
	|	ГрафикОтпусковРаботниковОрганизаций.ВидЕжегодногоОтпуска
	|	ИЗ ГрафикОтпусковРаботниковОрганизаций КАК ГрафикОтпусковРаботниковОрганизаций" + ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ГрафикОтпусковРаботниковОрганизаций"), "") + "
	|		
	|	ОБЪЕДИНИТЬ ВСЕ 		
	|		
	|	ВЫБРАТЬ 
	|	ФактическиеОтпускаРаботниковОрганизаций.Регистратор,
	|	ФактическиеОтпускаРаботниковОрганизаций.НачалоИнтервала,
	|	ФактическиеОтпускаРаботниковОрганизаций.КонецИнтервала,
	|	ФактическиеОтпускаРаботниковОрганизаций.Серия,
	|	ФактическиеОтпускаРаботниковОрганизаций.Учет,
	|	ФактическиеОтпускаРаботниковОрганизаций.ФизЛицо,
	|	ФактическиеОтпускаРаботниковОрганизаций.Сотрудник,
	|	"""",
	|	ФактическиеОтпускаРаботниковОрганизаций.ВидЕжегодногоОтпуска
	|	ИЗ ФактическиеОтпускаРаботниковОрганизаций КАК ФактическиеОтпускаРаботниковОрганизаций" + ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "ФактическиеОтпускаРаботниковОрганизаций"), "");	
	
	Возврат ТекстЗапрос;
	
КонецФункции

Процедура ДобавитьДиаграммуГантаВТабличныйДокумент(ТабличныйДокумент, Настройка)
	
	ПараметрВидДиаграммы = Настройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидДиаграммы"));
	
	Если ПараметрВидДиаграммы <> Неопределено и ПараметрВидДиаграммы.Значение = "Не выводить диаграмму" тогда
		Возврат;
	КонецЕсли;
	
	
	//получим период формирования отчета
	ПараметрНачалоПериода = Настройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = Настройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат;
	Иначе
		НачалоПериода = ПараметрНачалоПериода.Значение;
		КонецПериода  = ПараметрКонецПериода.Значение;
	КонецЕсли;
	
	Если НачалоПериода = '00010101' и КонецПериода = '00010101' тогда
		НачалоПериода = '10010102';
		КонецПериода = КонецМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
	КонецЕсли;
	
	Если КонецПериода < НачалоПериода тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
  	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("ДатаПослеНачала", КонецДня(НачалоПериода) + 1);
	Запрос.УстановитьПараметр("ТекущаяДата", ОбщегоНазначения.ПолучитьРабочуюДату());
	Запрос.УстановитьПараметр("ДатаСведений", КонецПериода);
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("ФизЛицо");
	СписокПолей.Добавить("Сотрудник");
	СписокПолей.Добавить("Должность");
	СписокПолей.Добавить("ДолжностьОрганизации");
	СписокПолей.Добавить("Подразделение");
	СписокПолей.Добавить("ПодразделениеОрганизации");
	СписокПолей.Добавить("ГоловнаяОрганизация");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("ДолжностьКадровогоПлана");
	СтрокаУсловияПоля = ПолучитьСтрокуОтбора(СписокПолей, Запрос);
	
	//6. 
	РаботникиОрганизации = СхемаКомпоновкиДанных.НаборыДанных.РаботникиОрганизации.Запрос;
	РаботникиОрганизации = ВставитьПоместить(РаботникиОрганизации, "РаботникиОрганизации");
	Запрос.Текст = РаботникиОрганизации	+ ?(СтрокаУсловияПоля <> "" ,"
	|	ГДЕ " + СтрЗаменить(СтрокаУсловияПоля, "ИСТОЧНИКДАННЫХ", "РаботникиОрганизации"), "");
	Запрос.Выполнить();
	
	Руководители = СхемаКомпоновкиДанных.НаборыДанных.Руководители.Запрос;
	Руководители = ВставитьПоместить(Руководители, "Руководители");
	Запрос.Текст = Руководители;
	Запрос.Выполнить();
	
	Руководители = СхемаКомпоновкиДанных.НаборыДанных.РуководителиОрганизации.Запрос;
	Руководители = ВставитьПоместить(Руководители, "РуководителиОрганизации");
	Запрос.Текст = Руководители;
	Запрос.Выполнить();
	
	МассивГуппировок    = ТиповыеОтчеты.ПолучитьМассивПолейГруппировки(КомпоновщикНастроек);
	ЕстьГруппировкаПоСтруктуреЮрЛиц         = ложь;
	ЕстьГруппировкаПоЦентрамОтветственности = ложь;
	
	УсловиеДляВыборки = "";
	
	УсловиеДляВыборки = УсловиеДляВыборки + "
	|ГДЕ
	|	НЕ Данные.Сотрудник.ВидДоговора ЕСТЬ NULL";
	
	ТЗ = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Данные.Регистратор,
	|	НАЧАЛОПЕРИОДА(Данные.НачалоИнтервала, ДЕНЬ) КАК НачалоИнтервала,
	|	КОНЕЦПЕРИОДА(Данные.КонецИнтервала, ДЕНЬ) КАК КонецИнтервала,
	|	Данные.Серия,
	|	Данные.ФизЛицо,
	|	Данные.Учет,
	|	Руководители.Руководитель КАК Руководитель,
	|	РуководителиОрганизации.РуководительОрганизации КАК РуководительОрганизации,
	|	РаботникиОрганизации.Должность КАК Должность,
	|	РаботникиОрганизации.Подразделение КАК Подразделение,
	|	РаботникиОрганизации.ДолжностьОрганизации КАК ДолжностьОрганизации,
	|	РаботникиОрганизации.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	РаботникиОрганизации.ГоловнаяОрганизация,
	|	РаботникиОрганизации.Организация,
	|	Данные.Сотрудник КАК Сотрудник,
	|	Данные.Состояние,
	|	ВЫБОР КОГДА Учет = ""ПоУпрУчету"" И НачалоИнтервала > ЕСТЬNULL(ДатаУвольненияУпр, ДатаУвольненияРегл) И ЕСТЬNULL(ДатаУвольненияУпр, ДатаУвольненияРегл) <> ДАТАВРЕМЯ(1,1,1)
	|	ТОГДА ИСТИНА 
	|	КОГДА Учет = ""ПоРеглУчету"" И НачалоИнтервала > ЕСТЬNULL(ДатаУвольненияРегл, ДатаУвольненияУпр) И ЕСТЬNULL(ДатаУвольненияРегл, ДатаУвольненияУпр) <> ДАТАВРЕМЯ(1,1,1)
	|	ТОГДА ИСТИНА
	|	ИНАЧЕ ЛОЖЬ 
	|	КОНЕЦ КАК Уволен
	|	ИЗ 
	|	(" + ПолучитьТекстЗапросПоОтпускам(Запрос) + ") КАК Данные
	|	ЛЕВОЕ СОЕДИНЕНИЕ РаботникиОрганизации КАК РаботникиОрганизации  
	|		ПО РаботникиОрганизации.Сотрудник = Данные.Сотрудник 
	|	ЛЕВОЕ СОЕДИНЕНИЕ Руководители КАК Руководители  
	|		ПО Руководители.ФизическоеЛицо = Данные.ФизЛицо
	|	ЛЕВОЕ СОЕДИНЕНИЕ РуководителиОрганизации КАК РуководителиОрганизации  
	|		ПО РуководителиОрганизации.ФизическоеЛицо = Данные.ФизЛицо" + УсловиеДляВыборки + "
	|{ГДЕ 
	|	Данные.Регистратор,
	|	Данные.НачалоИнтервала,
	|	Данные.КонецИнтервала,
	|	Данные.Серия,
	|	Данные.ФизЛицо,
	|	Данные.Учет,
	|	Руководители.Руководитель,
	|	РуководителиОрганизации.РуководительОрганизации,
	|	РаботникиОрганизации.Должность КАК Должность,
	|	РаботникиОрганизации.Подразделение КАК Подразделение,
	|	РаботникиОрганизации.Должность КАК ДолжностьОрганизации,
	|	РаботникиОрганизации.Подразделение КАК ПодразделениеОрганизации,
	|	РаботникиОрганизации.ГоловнаяОрганизация,
	|	РаботникиОрганизации.Организация,
	|	Данные.Сотрудник КАК Сотрудник,
	|	Данные.Состояние }
	|
	|{ИТОГИ ПО
	|	Данные.Серия,
	|	РаботникиОрганизации.Должность КАК Должность,
	|	РаботникиОрганизации.Подразделение КАК Подразделение,
	|	РаботникиОрганизации.Должность КАК ДолжностьОрганизации,
	|	РаботникиОрганизации.Подразделение КАК ПодразделениеОрганизации,
	|	РаботникиОрганизации.ГоловнаяОрганизация,
	|	РаботникиОрганизации.Организация,
	|	Данные.Сотрудник,
	|	Руководители.Руководитель КАК Руководитель,
	|	РуководителиОрганизации.РуководительОрганизации КАК РуководительОрганизации,
	|	Данные.Учет,
	|	Данные.Состояние,
	|	ВЫБОР КОГДА Учет = ""ПоУпрУчету"" И НачалоИнтервала > ЕСТЬNULL(ДатаУвольненияУпр, ДатаУвольненияРегл) И ЕСТЬNULL(ДатаУвольненияУпр, ДатаУвольненияРегл) <> ДАТАВРЕМЯ(1,1,1)
	|	ТОГДА ИСТИНА 
	|	КОГДА Учет = ""ПоРеглУчету"" И НачалоИнтервала > ЕСТЬNULL(ДатаУвольненияРегл, ДатаУвольненияУпр) И ЕСТЬNULL(ДатаУвольненияРегл, ДатаУвольненияУпр) <> ДАТАВРЕМЯ(1,1,1)
	|	ТОГДА ИСТИНА
	|	ИНАЧЕ ЛОЖЬ 
	|	КОНЕЦ КАК Уволен}
	|УПОРЯДОЧИТЬ ПО
	|	Данные.Сотрудник.Наименование,
	|	НАЧАЛОПЕРИОДА(Данные.НачалоИнтервала, ДЕНЬ)";
	
	Запрос.Текст = ТЗ;
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	
	//настроем отборы в отчете
	ПараметрыОтчета = Новый Структура("ВидОтчета, Периодичность, мСтильДиаграммыПланУтвержденный, мСтильДиаграммыПланНеУтвержденный, мСтильДиаграммыФакт, ПостроительОтчета, ДатаНач, ДатаКон, мМассивПараметров");
	ПараметрыОтчета.ДатаНач = НачалоПериода;
	ПараметрыОтчета.ДатаКон = КонецПериода;
	ПараметрыОтчета.ВидОтчета = "";
	МассивПараметров = Новый Массив;
	ПараметрыОтчета.ПостроительОтчета = Новый ПостроительОтчета;
	ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЗначений);
	ИсточникДанных.Колонки.Серия.Измерение                    = истина;
	ИсточникДанных.Колонки.Должность.Измерение                = истина;
	ИсточникДанных.Колонки.Подразделение.Измерение            = истина;
	ИсточникДанных.Колонки.ДолжностьОрганизации.Измерение     = истина;
	ИсточникДанных.Колонки.ПодразделениеОрганизации.Измерение = истина;
	ИсточникДанных.Колонки.ГоловнаяОрганизация.Измерение      = истина;
	ИсточникДанных.Колонки.Организация.Измерение              = истина;
	ИсточникДанных.Колонки.Сотрудник.Измерение                = истина;
	ИсточникДанных.Колонки.Учет.Измерение                     = истина;
	ИсточникДанных.Колонки.Руководитель.Измерение             = истина;
	ИсточникДанных.Колонки.РуководительОрганизации.Измерение  = истина;
	ИсточникДанных.Колонки.Состояние.Измерение                = истина;
	ИсточникДанных.Колонки.Уволен.Измерение                   = истина;
	
	ПараметрыОтчета.ПостроительОтчета.ИсточникДанных = ИсточникДанных;
	ПараметрыОтчета.ПостроительОтчета.ЗаполнитьНастройки();
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПриВыводеОтчета);
	МасивВыбранныхПолей = ТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек);
	
	// Настроим группировки в отчете
	СверткиТекст = "";
	ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Очистить();
	БылСотрудник = ложь;
	Для Каждого Группировка Из МассивГуппировок Цикл
		Если Группировка.Поле <> Новый ПолеКомпоновкиДанных("Серия") тогда
			Если Группировка.Поле =  Новый ПолеКомпоновкиДанных("Сотрудник") тогда
				БылСотрудник = истина;
			КонецЕсли;
			ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Добавить(Строка(Группировка.Поле));
			//Если Строка(Группировка.Поле) <> "Серия"
			//   и Строка(Группировка.Поле) <> "Состояние" 
			//   и Строка(Группировка.Поле) <> "Уволен" 
			//   и Строка(Группировка.Поле) <> "Учет" 
			//   и Строка(Группировка.Поле) <> "Руководитель" 
			//   и Строка(Группировка.Поле) <> "РуководительОрганизации" 
			//   тогда
			//	ПараметрыОтчета.ПостроительОтчета.Порядок.Добавить(Строка(Группировка.Поле) + ".Наименование");
			//Иначе
			ПараметрыОтчета.ПостроительОтчета.Порядок.Добавить(Строка(Группировка.Поле));
			//КонецЕсли;
			СверткиТекст = СверткиТекст + Строка(Группировка.Поле) + ", ";
		КонецЕсли;
	КонецЦикла;
	
	Если Не БылСотрудник тогда
		Для Каждого ВыбранноеПоле Из МасивВыбранныхПолей Цикл
			Если ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Сотрудник") тогда
				ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Добавить(Строка(ВыбранноеПоле.Поле));
				СверткиТекст = СверткиТекст + "Сотрудник, ";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Настроим отборы в отчет
	МассивОтборов = ТиповыеОтчеты.ПолучитьЭлементыОтбора(КомпоновщикНастроек);
	
	Для Каждого ЭлементОтбора Из МассивОтборов Цикл
		Если ЭлементОтбора = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") или НЕ ЭлементОтбора.Использование тогда
			Продолжить;
		КонецЕсли;
		Если Строка(ЭлементОтбора.ЛевоеЗначение) = "Серия" тогда
			МассивПараметров.Добавить(ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
		ВидСравненияСКД = ПолучитьВидСравнения(ЭлементОтбора.ВидСравнения);
		ПолеОтбора = ПараметрыОтчета.ПостроительОтчета.ДоступныеПоля.Найти(Строка(ЭлементОтбора.ЛевоеЗначение));
		Если ВидСравненияСКД <> Неопределено И ПолеОтбора <> Неопределено И ПолеОтбора.Отбор тогда
			ОтборПостроителя = ПараметрыОтчета.ПостроительОтчета.Отбор.Добавить(Строка(ЭлементОтбора.ЛевоеЗначение));
			ОтборПостроителя.ВидСравнения  = ВидСравненияСКД;
			ОтборПостроителя.Значение = ?(ПолеОтбора.ТипЗначения.СодержитТип(ТипЗнч(ЭлементОтбора.ПравоеЗначение)) ИЛИ ТипЗНЧ(ЭлементОтбора.ПравоеЗначение) = ТипЗНЧ(ОтборПостроителя.Значение) , ЭлементОтбора.ПравоеЗначение,  ОтборПостроителя.Значение);
			ОтборПостроителя.Использование = истина;
		Иначе
			Продолжить;
		Конецесли;
	КонецЦикла;
	
	Если МассивПараметров.Количество() = 0 тогда
		МассивПараметров.Добавить("План");
		МассивПараметров.Добавить("Факт");
	КонецЕсли;
	
	//ОтчетДиаграмма.ПостроительОтчета.Порядок.Добавить("Сотрудник");
	
	ПараметрыОтчета.мМассивПараметров   = МассивПараметров;
	
	ПараметрыОтчета.мСтильДиаграммыПланНеУтвержденный = ЦветаСтиля.ПлановыйНеутвержденныйПоказатель;
	ПараметрыОтчета.мСтильДиаграммыПланУтвержденный   = ЦветаСтиля.ПлановыйУтвержденныйПоказатель;
	ПараметрыОтчета.мСтильДиаграммыФакт               = ЦветаСтиля.ФактическийПоказатель;
	
	КоличествоСерий                    = МассивПараметров.Количество();
	ПараметрыОтчета.Периодичность       = 2;
	
	
	ДиаграммаГантаРисунок = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.ДиаграммаГанта);
	ДиаграммаГантаРисунок.Имя  = "ДиаграммаГанта";
	ДиаграммаГантаРисунок.Объект.ОтображатьЗаголовок             = ложь;
	ДиаграммаГантаРисунок.Объект.ОтображатьЛегенду               = ложь;
	ДиаграммаГантаРисунок.Объект.ЕдиницаПериодическогоВарианта   = ТипЕдиницыШкалыВремени.Месяц;
	ДиаграммаГантаРисунок.Объект.ОтображениеИнтервала            = ОтображениеИнтервалаДиаграммыГанта.Плоский;
	ДиаграммаГантаРисунок.Объект.АвтоОпределениеПолногоИнтервала = ложь;
	ДиаграммаГантаРисунок.Объект.УстановитьПолныйИнтервал(НачалоПериода, КонецПериода);
	УправлениеОтчетамиЗК.СформироватьДиаграмму(ДиаграммаГантаРисунок.Объект, ПараметрыОтчета);
	// установим формат шкалы
	
	ДиаграммаГантаРисунок.Объект.ОбластьПостроения.ШкалаВремени.Элементы[1].Формат = "ДФ = МММ";
	
	ДиаграммаГантаРисунок.Объект.ЦветФона = Новый Цвет(255,255,255);
	ДиаграммаГантаРисунок.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
	
	КоличествоКолонок = 1;
	ШиринаДиаграммы = 115;
	ШиринаКолонки = ТабличныйДокумент.Область(, КоличествоКолонок, , КоличествоКолонок).ШиринаКолонки;
	ШиринаДиаграммы = ШиринаДиаграммы - ?(ШиринаКолонки = 0, 9, ШиринаКолонки);
	Пока ШиринаДиаграммы > 0 Цикл
		КоличествоКолонок = КоличествоКолонок + 1;
		ШиринаКолонки = ТабличныйДокумент.Область(, КоличествоКолонок, , КоличествоКолонок).ШиринаКолонки;
		ШиринаДиаграммы = ШиринаДиаграммы - ?(ШиринаКолонки = 0, 9, ШиринаКолонки);
	КонецЦикла;
	
	ТаблицаДанных = ПараметрыОтчета.ПостроительОтчета.Результат.Выгрузить();
	ТаблицаДанных.Колонки.Удалить("НачалоИнтервала");
	ТаблицаДанных.Колонки.Удалить("КонецИнтервала");
	ТаблицаДанных.Колонки.Удалить("Регистратор");
	СверткиТекст = Лев(СверткиТекст, СтрДлина(СверткиТекст) - 2);
	
	ТаблицаДанных.Свернуть(СверткиТекст);
	КоличествоСтрок = ТаблицаДанных.Количество();
	КоличествоСтрок = МассивПараметров.Количество() * КоличествоСтрок;
	ОбластьЯчеек        = ТабличныйДокумент.Область(ТабличныйДокумент.ВысотаТаблицы + 3, 1, Окр(ТабличныйДокумент.ВысотаТаблицы + 3 + 1.3*(КоличествоСтрок)+2), КоличествоКолонок + 3);
	ОбластьЯчеек.Защита = Ложь;
	ДиаграммаГантаРисунок.Расположить(ОбластьЯчеек);
	ДиаграммаГантаРисунок.Защита = ложь;
	
	ДиаграммаГанта = ДиаграммаГантаРисунок.Объект;
	
КонецПроцедуры


#Если Клиент Тогда
	
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры

#КонецЕсли

Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	
	НастрокаПриВыводеОтчета = КомпоновщикНастроек.ПолучитьНастройки();
КонецПроцедуры

Функция ПолучитьВидСравнения(ВидСравненияКД)
	Если ВидСравненияКД = ВидСравненияКомпоновкиДанных.Равно или ВидСравненияКД = ВидСравненияКомпоновкиДанных.Содержит тогда 
		возврат ВидСравнения.Равно
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеРавно или ВидСравненияКД = ВидСравненияКомпоновкиДанных.Содержит тогда 
		возврат ВидСравнения.НеРавно
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.ВСписке тогда 
		возврат ВидСравнения.ВСписке
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии тогда 
		возврат ВидСравнения.ВСпискеПоИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.ВИерархии тогда 
		возврат ВидСравнения.ВИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВИерархии тогда 
		возврат ВидСравнения.НеВИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии тогда 
		возврат ВидСравнения.НеВСпискеПоИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке тогда 
		возврат ВидСравнения.НеВСписке
	Иначе 
		возврат Неопределено
	КонецЕсли;
КонецФункции

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	СписокПолейПодстановкиОтборовПоУмолчанию.Вставить("Организация", "ОсновнаяОрганизация");
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	СписокНастроек = Новый СписокЗначений;
	Если ИспользоватьУправленческийУчетЗарплаты Тогда
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ГрафикОтпусков);
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.Отпуска);
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ОтпускаРуководителей);
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ФактическиеОтпуска);
	КонецЕсли;	

	СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ГрафикОтпусковОрганизации);
	СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ОтпускаОрганизации);
	СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ОтпускаРуководителейОрганизации);
	СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ФактическиеОтпускаОрганизации);
	
	Возврат Новый Структура("ДополнительныеНастройкиОтчета, ИспользоватьСобытияПриФормированииОтчета,
	|ПриВыводеЗаголовкаОтчета,
	|ПослеВыводаПанелиПользователя,
	|ПослеВыводаПериода,
	|ПослеВыводаПараметра,
	|ПослеВыводаГруппировки,
	|ПослеВыводаОтбора,
	|ДействияПанелиИзменениеФлажкаДопНастроек,
	|ПриПолучениеНастроекПользователя, 
	|ЗаполнитьОтборыПоУмолчанию, 
	|СписокПолейПодстановкиОтборовПоУмолчанию,
	|СписокДоступныхПредопределенныхНастроек", 
	истина, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, истина, СписокПолейПодстановкиОтборовПоУмолчанию, СписокНастроек);
	
КонецФункции

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если КомпоновщикНастроек = Неопределено Тогда
	КомпоновщикНастроек =  Новый КомпоновщикНастроекКомпоновкиДанных;
КонецЕсли;

ДиаграммаГанта = Новый ДиаграммаГанта;

ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
Если ИспользоватьУправленческийУчетЗарплаты тогда
	
	ПолеПодразделение = СхемаКомпоновкиДанных.НаборыДанных.РаботникиОрганизации.Поля.Найти("Подразделение");
	ПолеПодразделение.ОграничениеИспользования.Группировка = ложь;
	ПолеПодразделение.ОграничениеИспользования.Поле        = ложь;
	ПолеПодразделение.ОграничениеИспользования.Порядок     = ложь;
	ПолеПодразделение.ОграничениеИспользования.Условие     = ложь;
	
	ПолеДолжность = СхемаКомпоновкиДанных.НаборыДанных.РаботникиОрганизации.Поля.Найти("Должность");
	ПолеДолжность.ОграничениеИспользования.Группировка = ложь;
	ПолеДолжность.ОграничениеИспользования.Поле        = ложь;
	ПолеДолжность.ОграничениеИспользования.Порядок     = ложь;
	ПолеДолжность.ОграничениеИспользования.Условие     = ложь;
	
Иначе 
	
	ПолеПодразделение = СхемаКомпоновкиДанных.НаборыДанных.РаботникиОрганизации.Поля.Найти("Подразделение");
	ПолеПодразделение.ОграничениеИспользования.Группировка = истина;
	ПолеПодразделение.ОграничениеИспользования.Поле        = истина;
	ПолеПодразделение.ОграничениеИспользования.Порядок     = истина;
	ПолеПодразделение.ОграничениеИспользования.Условие     = истина;
	
	ПолеДолжность = СхемаКомпоновкиДанных.НаборыДанных.РаботникиОрганизации.Поля.Найти("Должность");
	ПолеДолжность.ОграничениеИспользования.Группировка = истина;
	ПолеДолжность.ОграничениеИспользования.Поле        = истина;
	ПолеДолжность.ОграничениеИспользования.Порядок     = истина;
	ПолеДолжность.ОграничениеИспользования.Условие     = истина;
	
КонецЕсли;

КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
