﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мДлинаСуток;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если Клиент Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
// Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//	НазваниеМакета - строка, название макета.
//
Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	// Получить экземпляр документа на печать
	Если Лев(ИмяМакета,2) = "Т7" Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("ДатаДокумента", Дата);
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница",Организация);
		
		Запрос.Текст = ФормированиеПечатныхФормЗК.ПолучитьТекстЗапросаПоОтветственнымЛицам(
			"ДатаДокумента",
			"ОтветственноеЛицо В (ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель), ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы))
			|И СтруктурнаяЕдиница = &СтруктурнаяЕдиница");
		Запрос.Выполнить();
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГрафикОтпусковОрганизации.Дата,
		|	ГрафикОтпусковОрганизации.Номер,
		|	ВЫРАЗИТЬ(ГрафикОтпусковОрганизации.Организация.НаименованиеПолное КАК СТРОКА(300)) КАК Организация,
		|	ГрафикОтпусковОрганизации.Организация.Префикс,
		|	ГрафикОтпусковОрганизации.Организация.КодПоОКПО КАК КодПоОКПО,
		|	ОтветственныеЛицаОрганизаций.Должность КАК ДолжностьРуководителя,
		|	ОтветственныеЛицаОрганизаций.ОтветственноеЛицо,
		|	ОтветственныеЛицаОрганизаций.НаименованиеОтветственногоЛица КАК ФИОРуководителя
		|ИЗ
		|	Документ.ГрафикОтпусковОрганизаций КАК ГрафикОтпусковОрганизации
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОбОтветственномЛице КАК ОтветственныеЛицаОрганизаций
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ГрафикОтпусковОрганизации.Ссылка = &ТекущийДокумент";
		
		РезультатДляШапкиИПодвала = Запрос.Выполнить();
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.УстановитьПараметр("ДатаДокумента", Дата);

		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник КАК Сотрудник,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник.Код,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник.Наименование,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.ДатаНачала,
		|	СУММА(КалендарьДнейВсего.КалендарныеДни) КАК Продолжительность,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.ДатаОкончания,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.НомерСтроки
		|ПОМЕСТИТЬ ВТДанныеДокумента
		|ИЗ
		|	Документ.ГрафикОтпусковОрганизаций.РаботникиОрганизации КАК ГрафикОтпусковОрганизацииРаботникиОрганизации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК КалендарьДнейВсего
		|		ПО (КалендарьДнейВсего.ВидДня <> ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Праздник))
		|			И (КалендарьДнейВсего.ДатаКалендаря МЕЖДУ ГрафикОтпусковОрганизацииРаботникиОрганизации.ДатаНачала И ГрафикОтпусковОрганизацииРаботникиОрганизации.ДатаОкончания)
		|ГДЕ
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Ссылка = &ТекущийДокумент
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник.Физлицо,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник.Код,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.ДатаНачала,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.ДатаОкончания,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.НомерСтроки,
		|	ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник.Наименование
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РаботникиОрганизацииСрезПоследних.Сотрудник КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА РаботникиОрганизацииСрезПоследних.ПериодЗавершения <= &ДатаДокумента
		|				И РаботникиОрганизацииСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизацииЗавершения
		|		ИНАЧЕ РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации
		|	КОНЕЦ КАК ПодразделениеОрганизации,
		|	ВЫБОР
		|		КОГДА РаботникиОрганизацииСрезПоследних.ПериодЗавершения <= &ДатаДокумента
		|				И РаботникиОрганизацииСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА РаботникиОрганизацииСрезПоследних.ДолжностьЗавершения
		|		ИНАЧЕ РаботникиОрганизацииСрезПоследних.Должность
		|	КОНЕЦ КАК Должность,
		|	ВЫБОР
		|		КОГДА РаботникиОрганизацииСрезПоследних.ПериодЗавершения <= &ДатаДокумента
		|				И РаботникиОрганизацииСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизацииЗавершения.Наименование
		|		ИНАЧЕ РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации.Наименование
		|	КОНЕЦ КАК ПодразделениеОрганизацииНаименование,
		|	ВЫБОР
		|		КОГДА РаботникиОрганизацииСрезПоследних.ПериодЗавершения <= &ДатаДокумента
		|				И РаботникиОрганизацииСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА РаботникиОрганизацииСрезПоследних.ДолжностьЗавершения.Наименование
		|		ИНАЧЕ РаботникиОрганизацииСрезПоследних.Должность.Наименование
		|	КОНЕЦ КАК ДолжностьНаименование
		|ПОМЕСТИТЬ ВТДанныеОРаботниках
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
		|			&ДатаДокумента,
		|			Сотрудник В
		|				(ВЫБРАТЬ
		|					ГрафикОтпусковОрганизацииРаботникиОрганизации.Сотрудник
		|				ИЗ
		|					ВТДанныеДокумента КАК ГрафикОтпусковОрганизацииРаботникиОрганизации)) КАК РаботникиОрганизацииСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОтветственныеЛицаСрезПоследних.ФизическоеЛицо.Наименование КАК ФизическоеЛицоНаименование,
		|	ОтветственныеЛицаСрезПоследних.Должность.Наименование КАК Должность,
		|	ОтветственныеЛицаСрезПоследних.ОтветственноеЛицо,
		|	ОтветственныеЛицаСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ОтветственныеЛицаСрезПоследних.СтруктурнаяЕдиница,
		|	ФизическиеЛица.Комментарий
		|ПОМЕСТИТЬ ВТДанныеОбОтветственномЛице
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(
		|			&ДатаДокумента,
		|			СтруктурнаяЕдиница В
		|					(ВЫБРАТЬ
		|						РаботникиОрганизации.ПодразделениеОрганизации
		|					ИЗ
		|						ВТДанныеОРаботниках КАК РаботникиОрганизации)
		|				И ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)) КАК ОтветственныеЛицаСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ПО ОтветственныеЛицаСрезПоследних.ФизическоеЛицо = ФизическиеЛица.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизическоеЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГрафикОтпусковОрганизацииРаботники.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ФИОФизЛиц.Фамилия + "" "" + ФИОФизЛиц.Имя + "" "" + ФИОФизЛиц.Отчество, ГрафикОтпусковОрганизацииРаботники.СотрудникНаименование) КАК Работник,
		|	ГрафикОтпусковОрганизацииРаботники.ДатаНачала,
		|	ГрафикОтпусковОрганизацииРаботники.ДатаОкончания,
		|	ГрафикОтпусковОрганизацииРаботники.Продолжительность,
		|	ГрафикОтпусковОрганизацииРаботники.СотрудникКод КАК ТабельныйНомер,
		|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность КАК ДолжностьРуководителя,
		|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицоНаименование) КАК ФИОРуководителя,
		|	РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации,
		|	РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизацииНаименование,
		|	РаботникиОрганизацииСрезПоследних.ДолжностьНаименование,
		|	РаботникиОрганизацииСрезПоследних.Должность,
		|	ГрафикОтпусковОрганизацииРаботники.Сотрудник
		|ИЗ
		|	ВТДанныеДокумента КАК ГрафикОтпусковОрганизацииРаботники
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОРаботниках КАК РаботникиОрганизацииСрезПоследних
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОбОтветственномЛице КАК ОтветственныеЛицаОрганизацийСрезПоследних
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(
		|						&ДатаДокумента,
		|						ФизЛицо В
		|							(ВЫБРАТЬ
		|								Ответственные.ФизическоеЛицо
		|							ИЗ
		|								ВТДанныеОбОтветственномЛице КАК Ответственные)) КАК ФИОФизЛицСрезПоследних
		|				ПО ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо = ФИОФизЛицСрезПоследних.ФизЛицо
		|			ПО РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации = ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница
		|		ПО ГрафикОтпусковОрганизацииРаботники.Сотрудник = РаботникиОрганизацииСрезПоследних.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(
		|				&ДатаДокумента,
		|				Физлицо В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ГрафикОтпусковОрганизацииРаботникиОрганизации.Физлицо
		|					ИЗ
		|						ВТДанныеДокумента КАК ГрафикОтпусковОрганизацииРаботникиОрганизации)) КАК ФИОФизЛиц
		|		ПО ГрафикОтпусковОрганизацииРаботники.Физлицо = ФИОФизЛиц.ФизЛицо
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикОтпусковОрганизацииРаботники.НомерСтроки,
		|	ГрафикОтпусковОрганизацииРаботники.ДатаНачала,
		|	ГрафикОтпусковОрганизацииРаботники.ДатаОкончания,
		|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность,
		|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицоНаименование),
		|	РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизацииНаименование,
		|	РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации,
		|	РаботникиОрганизацииСрезПоследних.ДолжностьНаименование,
		|	РаботникиОрганизацииСрезПоследних.Должность,
		|	ГрафикОтпусковОрганизацииРаботники.Сотрудник,
		|	ГрафикОтпусковОрганизацииРаботники.СотрудникКод,
		|	ГрафикОтпусковОрганизацииРаботники.Продолжительность,
		|	ЕСТЬNULL(ФИОФизЛиц.Фамилия + "" "" + ФИОФизЛиц.Имя + "" "" + ФИОФизЛиц.Отчество, ГрафикОтпусковОрганизацииРаботники.СотрудникНаименование)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		РезультатРаботникиОрганизации = Запрос.Выполнить();
		
		Макет = ПолучитьМакет(ИмяМакета);
		
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.ПолеСлева = 0;
		ТабДокумент.ПолеСправа = 0;
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПланированиеОтпускаОрганизации_Т7";
		ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		// Шапка документа.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		// повторяющаяся шапка страницы
		ПовторятьПриПечатиСтроки = Макет.ПолучитьОбласть("ПовторятьПриПечати");
		// Начало подвала документа
		ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
		
		ВыборкаДляШапкиИПодвала = РезультатДляШапкиИПодвала.Выбрать();
		Если ВыборкаДляШапкиИПодвала.Следующий() Тогда // выводим данные о руководителях организации
			
			ОбластьМакета.Параметры.НазваниеОрганизации = ВыборкаДляШапкиИПодвала.Организация;
			ОбластьМакета.Параметры.КодПоОКПО 			= ВыборкаДляШапкиИПодвала.КодПоОКПО;
			ОбластьМакета.Параметры.НомерДок 			= ВыборкаДляШапкиИПодвала.Номер;
			ОбластьМакета.Параметры.ДатаДок 			= ВыборкаДляШапкиИПодвала.Дата;
			
			ВыборкаДляШапкиИПодвала = РезультатДляШапкиИПодвала.Выбрать();
			Если ВыборкаДляШапкиИПодвала.НайтиСледующий(Перечисления.ОтветственныеЛицаОрганизаций.Руководитель,"ОтветственноеЛицо") Тогда
				ОбластьМакета.Параметры.Заполнить(ВыборкаДляШапкиИПодвала);
			КонецЕсли;
			
			// Для подвала
			ВыборкаДляШапкиИПодвала = РезультатДляШапкиИПодвала.Выбрать();
			Если ВыборкаДляШапкиИПодвала.НайтиСледующий(Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы,"ОтветственноеЛицо") Тогда
				ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДляШапкиИПодвала);
			КонецЕсли;
			
		КонецЕсли;
		
		ВыборкаРаботники = РезультатРаботникиОрганизации.Выбрать();
		
		// Начинаем формировать выходной документ (шапка дока)
		ТабДокумент.Вывести(ОбластьМакета);
		
		ВсегоСтрокДокумента = ВыборкаРаботники.Количество();
		
		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаРаботник");
		
		// массив с двумя строками - для разбиения на страницы
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакета);
		
		ВыведеноСтрок = 0;
		// выводим строки по работникам
		ВыборкаРаботники = РезультатРаботникиОрганизации.Выбрать();
		Пока ВыборкаРаботники.Следующий() Цикл
		
			// Данные по работнику
			ОбластьМакета.Параметры.Заполнить(ВыборкаРаботники);
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабДокумент.Вывести(ПовторятьПриПечатиСтроки);
			КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;

		// если не было ни одного работника - выводим пустой бланк
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакета);
		ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
		Для Сч = 1 По ОбластьМакета.Параметры.Количество() Цикл
			ОбластьМакета.Параметры.Установить(Сч - 1,""); 
		КонецЦикла;
		ОбластьМакета.Параметры.Работник = " " + Символы.ПС + " ";
		Пока ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, Ложь) Цикл
			ТабДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
	
		// выводим предварительно подготовленный Подвал документа.
		ТабДокумент.Вывести(ОбластьМакетаПодвал);
		Возврат УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект,Метаданные().Синоним + " (форма Т-7)"));

	ИначеЕсли ИмяМакета = "ГрафикОтпусков" тогда
		
		Если НЕ Проведен Тогда
			РаботаСДиалогами.ВывестиПредупреждение("Документ можно распечатать только после его проведения!");
			Возврат Неопределено;
		КонецЕсли;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МАКСИМУМ(ПланированиеОтпускаОрганизацииРаботники.ДатаОкончания) КАК ДатаКон,
		|	МИНИМУМ(ПланированиеОтпускаОрганизацииРаботники.ДатаНачала) КАК ДатаНач
		|ИЗ
		|	Документ.ГрафикОтпусковОрганизаций.РаботникиОрганизации КАК ПланированиеОтпускаОрганизацииРаботники
		|
		|ГДЕ
		|	ПланированиеОтпускаОрганизацииРаботники.Ссылка = &Ссылка");

		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();	 
		
		Если Выборка.Следующий() Тогда
			Отчет = Отчеты.Отпуска.Создать();
			Форма = Отчет.ПолучитьФорму();
			ЗначениеНастройкиПользователя = ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователяОбъекта(Отчет, Форма);
			ЗначениеНастройкиПользователя.ВыводитьДиаграммуГанта = истина;
			ЗначениеНастройкиПользователя.ВыводитьЗаголовокОтчета = истина;
			Отчет.ЗначенияНастроекПанелиПользователя = Новый ХранилищеЗначения(ЗначениеНастройкиПользователя);
			ТиповыеОтчеты.УстановитьПараметр(Отчет.КомпоновщикНастроек, "НачалоПериода", ?(НЕ ЗначениеЗаполнено(Выборка.ДатаНач),НачалоГода(РабочаяДата),НачалоМесяца(Выборка.ДатаНач)));
			ТиповыеОтчеты.УстановитьПараметр(Отчет.КомпоновщикНастроек, "КонецПериода", ?(НЕ ЗначениеЗаполнено(Выборка.ДатаКон),КонецГода(РабочаяДата),КонецМесяца(Выборка.ДатаКон)));
			ТиповыеОтчеты.ДобавитьОтбор(Отчет.КомпоновщикНастроек, "Регистратор", Ссылка);
			ТабДокумент = Новый ТабличныйДокумент;
			Отчет.СформироватьОтчет(ТабДокумент);
			Возврат УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект,Метаданные().Синоним + " (диаграмма)"));
		Иначе
			РаботаСДиалогами.ВывестиПредупреждение("Ошибка исполнения запроса к т.ч.");
			Возврат Неопределено
		КонецЕсли;
		
	КонецЕсли;

КонецФункции // Печать()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//	Структура, каждая строка которой соответствует одному из вариантов печати
//
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураМакетов = Новый Структура;
	
	СтруктураМакетов.Вставить("Т7_от_5_1_2004",	"Форма Т-7");
	СтруктураМакетов.Вставить("ГрафикОтпусков", "График отпусков");
	
	Возврат СтруктураМакетов;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

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
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация" , Справочники.Организации.ПустаяСсылка());

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГрафикОтпусковОрганизаций.Дата,
	|	ГрафикОтпусковОрганизаций.Организация,
	|	ВЫБОР
	|		КОГДА ГрафикОтпусковОрганизаций.Организация.ГоловнаяОрганизация = &ПустаяОрганизация
	|			ТОГДА ГрафикОтпусковОрганизаций.Организация
	|		ИНАЧЕ ГрафикОтпусковОрганизаций.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	ГрафикОтпусковОрганизаций.Ссылка
	|ИЗ
	|	Документ.ГрафикОтпусковОрганизаций КАК ГрафикОтпусковОрганизаций
	|ГДЕ
	|	ГрафикОтпусковОрганизаций.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим	- режим проведения
//
// Возвращаемое значение:
//	Результат запроса
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",			Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",	ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);

	// Описание текста запроса:
	// 1. Выборка "ПерваяТаблица": 
	//		Представляет собой вложенный запрос, в котором:  
	//			- в выборке "РаботникиДокумента" выбираются строки документа
	//			- из основной таблицы регистра (выборка "ГрафикОтпусковОрганизации") 
	//			  присоединяются даты движений, непосредственно предшествующих
	//			  датам ДатаОкончания из строк документа
	// 2. Выборка "ГрафикОтпусковОрганизации": 
	//		Из основной таблицы регистра выбираются значения ресурсов на полученные  
	//		в первой выборке даты
	// 3. Выборка "ВтораяТаблица": 
	//		Среди строк документа ищем строки с пересекающимися периодами отпусков 
	//		для одного работника
	//
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПерваяТаблица.НомерСтроки КАК НомерСтроки,
	|	ПерваяТаблица.Сотрудник,
	|	ПерваяТаблица.ДатаНачала,
	|	ПерваяТаблица.ДатаОкончания,
	|	ВЫБОР
	|		КОГДА ПерваяТаблица.Сотрудник.Организация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	ВЫБОР
	|		КОГДА ГрафикОтпусковОрганизации.Состояние = ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.ОтпускЕжегодный)
	|				ИЛИ ПерваяТаблица.ДатаЗначения >= ПерваяТаблица.ДатаНачала
	|			ТОГДА ""Нельзя""
	|		ИНАЧЕ ""Можно""
	|	КОНЕЦ КАК ПроверяемоеЗначение,
	|	МИНИМУМ(ВтораяТаблица.НомерСтроки) КАК КонфликтнаяСтрока
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(ГрафикОтпусковОрганизации.Период) КАК ДатаЗначения,
	|		РаботникиДокумента.Сотрудник КАК Сотрудник,
	|		РаботникиДокумента.ДатаОкончания КАК ДатаОкончания,
	|		РаботникиДокумента.ДатаНачала КАК ДатаНачала,
	|		РаботникиДокумента.Ссылка КАК Ссылка,
	|		РаботникиДокумента.НомерСтроки КАК НомерСтроки
	|	ИЗ
	|		Документ.ГрафикОтпусковОрганизаций.РаботникиОрганизации КАК РаботникиДокумента
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикОтпусковОрганизаций КАК ГрафикОтпусковОрганизации
	|			ПО РаботникиДокумента.ДатаОкончания > ГрафикОтпусковОрганизации.Период
	|				И РаботникиДокумента.Сотрудник = ГрафикОтпусковОрганизации.Сотрудник
	|	ГДЕ
	|		РаботникиДокумента.Ссылка = &ДокументСсылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаботникиДокумента.Сотрудник,
	|		РаботникиДокумента.ДатаОкончания,
	|		РаботникиДокумента.ДатаНачала,
	|		РаботникиДокумента.Ссылка,
	|		РаботникиДокумента.НомерСтроки) КАК ПерваяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикОтпусковОрганизаций КАК ГрафикОтпусковОрганизации
	|		ПО ПерваяТаблица.ДатаЗначения = ГрафикОтпусковОрганизации.Период
	|			И ПерваяТаблица.Сотрудник = ГрафикОтпусковОрганизации.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ГрафикОтпусковОрганизаций.РаботникиОрганизации КАК ВтораяТаблица
	|		ПО ПерваяТаблица.Ссылка = ВтораяТаблица.Ссылка
	|			И ПерваяТаблица.НомерСтроки < ВтораяТаблица.НомерСтроки
	|			И (ПерваяТаблица.ДатаНачала <= ВтораяТаблица.ДатаНачала
	|					И ВтораяТаблица.ДатаНачала <= ПерваяТаблица.ДатаОкончания
	|				ИЛИ ПерваяТаблица.ДатаНачала <= ВтораяТаблица.ДатаОкончания
	|					И ВтораяТаблица.ДатаОкончания <= ПерваяТаблица.ДатаОкончания
	|				ИЛИ ВтораяТаблица.ДатаНачала <= ПерваяТаблица.ДатаНачала
	|					И ПерваяТаблица.ДатаОкончания <= ВтораяТаблица.ДатаОкончания)
	|			И ПерваяТаблица.Сотрудник = ВтораяТаблица.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ПерваяТаблица.НомерСтроки,
	|	ГрафикОтпусковОрганизации.Состояние,
	|	ПерваяТаблица.ДатаЗначения,
	|	ПерваяТаблица.ДатаНачала,
	|	ПерваяТаблица.ДатаОкончания,
	|	ПерваяТаблица.Сотрудник";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры:
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса("Не указана организация, для которой составляется график отпусков!"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//								  из результата запроса по работникам, 
//	Отказ 						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса(""" табл. части ""Сотрудники организации"": ");
	
	// Сотрудник
	НетСотрудника = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник);
	Если НетСотрудника Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаНачала
	НетДатыС = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаНачала);
	Если НетДатыС Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата начала отпуска!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаОкончания
	НетДатыПо = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаОкончания);
	Если НетДатыПо Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата окончания отпуска!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НетСотрудника ИЛИ НетДатыС ИЛИ НетДатыПо Тогда
		Возврат;
	КонецЕсли;
	
	// Организация сотрудника должна совпадать с организацией документа
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса("указанный сотрудник оформлен на другую организацию!"), Отказ, Заголовок);
	КонецЕсли;
	
	Если ВыборкаПоСтрокамДокумента.ДатаНачала > ВыборкаПоСтрокамДокумента.ДатаОкончания Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "дата начала отпуска не может превышать дату окончания отпуска!", Отказ, Заголовок);
	КонецЕсли;
	
	Если ВыборкаПоСтрокамДокумента.ПроверяемоеЗначение = "Нельзя" Тогда
		СтрокаПродолжениеСообщенияОбОшибке = " на указанный период ранее уже был запланирован другой отпуск!";
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока <> Null Тогда
		СтрокаПродолжениеСообщенияОбОшибке = " в строке №" + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока + " указан пересекающийся период отпуска!";
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ
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
	
	СтруктураПроведенияПоРегистрамСведений.Вставить("ГрафикОтпусковОрганизаций");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры:
//	ВыборкаПоШапкеДокумента					- выборка из результата запроса по шапке документа,
//	СтруктураПроведенияПоРегистрамСведений	- структура, содержащая имена регистров 
//											  сведений по которым надо проводить документ,
//	СтруктураПараметров						- структура параметров проведения,
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации,  
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ГрафикОтпусковОрганизаций";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		// отразим начало
		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период			= ВыборкаПоРаботникиОрганизации.ДатаНачала;

		// Измерения
		Движение.Сотрудник		= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация	= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;

		// Ресурсы
		Движение.Состояние		= Перечисления.ТипыПериодическихЗадачРаботника.ОтпускЕжегодный;
		
		// Реквизиты
		Движение.ДатаОкончания	= КонецДня(ВыборкаПоРаботникиОрганизации.ДатаОкончания);


		// и окончание отпуска
		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период			= ВыборкаПоРаботникиОрганизации.ДатаОкончания + мДлинаСуток - 1;

		// Измерения
		Движение.Сотрудник		= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация	= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
		
		// Ресурсы
		Движение.Состояние		= Перечисления.ТипыПериодическихЗадачРаботника.Свободен;
		
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров накопления по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
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

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);

			// получим реквизиты табличной части
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента);
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать();
			
			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);
				
				Если НЕ Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, СтруктураПроведенияПоРегистрамСведений);
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаЗаполнения(Основание)
	
	ГрафикОтпусковОрганизацийПереопределяемый.ОбработкаЗаполнения(ЭтотОбъект, Основание)

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	//
	//МассивТЧ = Новый Массив();
	//МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации);
	
КонецПроцедуры // ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;

