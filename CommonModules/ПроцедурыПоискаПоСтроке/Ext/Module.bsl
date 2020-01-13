﻿// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЕСПЕЧЕНИЯ ПодбораПоСтроке В ПОЛЕ ВВОДА

// Процедура инициализирует параметры обработки поиска по строке
Процедура ИнициализироватьПараметрыОбработкиПоискаПоСтроке(ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, ПоследнееЗначениеЭлементаПоискаПоСтроке) Экспорт
	
	ОбработкаПоискаПоСтроке                 = Ложь;
	ТекстПоискаПоСтроке                     = "";
	ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено;
    	
КонецПроцедуры

// Функция формирует ограничение для запроса по полю 
Функция СформироватьОграничениеПоПолюВхождениеВНачало(ИмяПоля, ТипЗначенияПоиска) Экспорт
	
	Ограничение = ИмяПоля + ?(ТипЗначенияПоиска = Тип("Строка"), (" ПОДОБНО &ТекстАвтоПодбора СПЕЦСИМВОЛ ""~"""), (" =  &ТекстАвтоПодбораЧисло"));
	Возврат "(" + Ограничение + ") ";
	
КонецФункции

//Функция Определяет тип ограничений по полю
Функция ОпределитьТипОграниченийПоПолю(ИмяЭлемента, МетаданныеОбъекта, ДляСправочника = Истина)
	
	Если ДляСправочника Тогда
		
		Если ИмяЭлемента <> "Наименование" И ИмяЭлемента <> "Код" Тогда
	    	ТипЗначенияПоиска = МетаданныеОбъекта.Реквизиты[ИмяЭлемента].Тип.Типы()[0];
		Иначе
			Если ИмяЭлемента = "Наименование" Тогда
				ТипЗначенияПоиска = Тип("Строка");
			Иначе
				Если МетаданныеОбъекта.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
					ТипЗначенияПоиска = Тип("Строка");
				Иначе
					ТипЗначенияПоиска = Тип("Число");
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
		
	Иначе
		// тип определяем для регистра сведений
		Объект = МетаданныеОбъекта.Измерения.Найти(ИмяЭлемента);
		Если Объект = Неопределено Тогда
			Объект = МетаданныеОбъекта.Ресурсы.Найти(ИмяЭлемента);
		КонецЕсли;
		Если Объект = Неопределено Тогда
			Объект = МетаданныеОбъекта.Реквизиты.Найти(ИмяЭлемента);
			Если Объект = Неопределено Тогда
				ТипЗначенияПоиска = Тип("Строка");
			КонецЕсли;	
		КонецЕсли;
		ТипЗначенияПоиска = Объект.Тип.Типы()[0];
		
	КонецЕсли;
	
	Возврат  ТипЗначенияПоиска;
	
КонецФункции

// Функция создает объект запрос и устанавливает у него параметры ТекстАвтоПодбора и ТекстАвтоПодбораЧисло
// убирает лишние символы в строке поиска
Функция  СоздатьЗапросДляСпискаАвтоподбора(СтрокаПоиска, СтрокаОтборовПоСтруктуре, СтруктураПараметров, ИмяТаблицыОграничений)
	
	Запрос = Новый Запрос;
	
	СтрокаПоиска = ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(СтрокаПоиска);
		
	Запрос.УстановитьПараметр("ТекстАвтоПодбора"     , (СтрокаПоиска + "%"));
	Попытка
		Запрос.УстановитьПараметр("ТекстАвтоПодбораЧисло", Число(СтрокаПоиска));
	Исключение
		Запрос.УстановитьПараметр("ТекстАвтоПодбораЧисло", Неопределено);
	КонецПопытки;
	
	// Устанавливает ограничения
	СтрокаОтборовПоСтруктуре = "";
	Для Каждого ЭлементСтруктуры Из СтруктураПараметров Цикл
		Ключ 	 = ЭлементСтруктуры.Ключ;
        Значение = ЭлементСтруктуры.Значение;

		Запрос.УстановитьПараметр(Ключ, Значение);
		СтрокаОтборовПоСтруктуре = СтрокаОтборовПоСтруктуре + "
		|		И
		|		" + ИмяТаблицыОграничений + "." + Ключ + " В (&"+ Ключ + ")";
	КонецЦикла; 
	
	Возврат Запрос;
	
КонецФункции

//Функция Строит запрос автоподбора для регистра
Функция ПолучитьРезультатЗапросаАвтоподбораДляРегистра(Знач Текст, СтруктураПараметров, ИмяРегистра, ПоляДляПоиска, КоличествоЭлементов) Экспорт
	
	Если (ПоляДляПоиска = Неопределено) ИЛИ ПоляДляПоиска.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Объект = Метаданные.РегистрыСведений[ИмяРегистра];
    	
	СтрокаОтборовПоСтруктуре = "";
	
	Запрос = СоздатьЗапросДляСпискаАвтоподбора(Текст, СтрокаОтборовПоСтруктуре, СтруктураПараметров, "ТаблицаРегистра");
	
	СтрокаПолей = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ " + Строка(КоличествоЭлементов) + "
				  	|	ТаблицаРегистра.* ";
	
	Запрос.Текст = СтрокаПолей + "
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК ТаблицаРегистра
		|ГДЕ ";

	
	// формируем ограничения по полям для поиска
	ОграничениеПоПолю = "";
	Для Каждого ПолеПоиска из ПоляДляПоиска Цикл
		
		ТипЗначенияПоиска = ОпределитьТипОграниченийПоПолю(ПолеПоиска, Объект, Ложь);
		Если (ОграничениеПоПолю <> "") Тогда
			ОграничениеПоПолю = ОграничениеПоПолю + "
				| ИЛИ ";
		КонецЕсли;
		ОграничениеПоПолю = ОграничениеПоПолю + СформироватьОграничениеПоПолюВхождениеВНачало("ТаблицаРегистра." + ПолеПоиска, ТипЗначенияПоиска);

	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст +"
		|	(" + ОграничениеПоПолю + ") " + СтрокаОтборовПоСтруктуре;

	Возврат Запрос.Выполнить();
 	
КонецФункции

// функция по типу возвращает наименование ветки метаданных
Функция ПолучитьВеткуМетаданныхПоТипу(ТипДанных)
	
	ВеткаМетаданных = "";
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "Справочник"
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "ПланВидовРасчета"
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "ПланВидовХарактеристик"
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипДанных) Тогда
		ВеткаМетаданных = "ПланСчетов"
	КонецЕсли;
	
	Возврат ВеткаМетаданных;

КонецФункции

// Функция выполняет запрос при автоподборе текста  и при окончании ввода текста в поле ввода.
//
// Параметры
//  Текст - Строка, текст введенный в поле ввода видв контактной информации, по которому необходимо строить поиск
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ТипСправочника - Тип, тип справочника автоподбора текста
//  КоличествоЭлементов - Число, количество элементов в результирующей таблице запроса
//
// Возвращаемое значение
//  РезультатЗапроса
//
Функция ПолучитьРезультатЗапросаАвтоподбора(Знач Текст, СтруктураПараметров, ТипСправочника, КоличествоЭлементов) Экспорт
	
	ВеткаМетаданных = ПолучитьВеткуМетаданныхПоТипу(ТипСправочника);
	Если ВеткаМетаданных = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПустаяСсылкаТипа = Новый(ТипСправочника);

	МетаданныеОбъекта = ПустаяСсылкаТипа.Метаданные();
	
	КоллекцияПоискаПоПодстроке = МетаданныеОбъекта.ВводПоСтроке;
	Если КоллекцияПоискаПоПодстроке.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ИмяТаблицыСправочника = МетаданныеОбъекта.Имя;
	ИмяТаблицыОграничений = ?(КоллекцияПоискаПоПодстроке.Количество() = 1, "ТаблицаВложенногоЗапроса", "ТаблицаСправочника");
	СтрокаОтборовПоСтруктуре = "";
	
	Запрос = СоздатьЗапросДляСпискаАвтоподбора(Текст, СтрокаОтборовПоСтруктуре, СтруктураПараметров, ИмяТаблицыОграничений);
	
	СтрокаПолей = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ " + Строка(КоличествоЭлементов) + "
	|	ТаблицаВложенногоЗапроса.Ссылка КАК Ссылка,
	|";
	
	Если МетаданныеОбъекта.ДлинаНаименования > 0 Тогда
		СтрокаПолей = СтрокаПолей + "
		|	ТаблицаВложенногоЗапроса.Ссылка.Наименование КАК Наименование,";
	КонецЕсли;
	
	Если МетаданныеОбъекта.ДлинаКода > 0 Тогда
		СтрокаПолей = СтрокаПолей + "
		|	ТаблицаВложенногоЗапроса.Ссылка.Код КАК Код,";
	КонецЕсли; 
	
	Если КоллекцияПоискаПоПодстроке.Количество() = 1 Тогда
		
		ЭлементКоллекции = КоллекцияПоискаПоПодстроке[0];
		ТипЗначенияПоиска = ОпределитьТипОграниченийПоПолю(ЭлементКоллекции.Имя, МетаданныеОбъекта);
		
		Если ЭлементКоллекции.Имя <> "Наименование" И ЭлементКоллекции.Имя <> "Код" Тогда
			СтрокаПолей = СтрокаПолей + "
			|	ТаблицаВложенногоЗапроса.Ссылка." + ЭлементКоллекции.Имя + " КАК " + ЭлементКоллекции.Имя;
		КонецЕсли;
		
		Запрос.Текст = Лев(СтрокаПолей, (СтрДлина(СтрокаПолей) - 1)) + "
		|ИЗ
		|	" + ВеткаМетаданных + "." + ИмяТаблицыСправочника + " КАК ТаблицаВложенногоЗапроса
		|ГДЕ ";
		
		ОграничениеПоПолю = СформироватьОграничениеПоПолюВхождениеВНачало("ТаблицаВложенногоЗапроса." + ЭлементКоллекции.Имя, ТипЗначенияПоиска);
		
		ОграничениеПоПолю = ОграничениеПоПолю + "
		|	И НЕ ТаблицаВложенногоЗапроса.ПометкаУдаления ";
		
		Запрос.Текст = Запрос.Текст +"
		|	" + ОграничениеПоПолю + СтрокаОтборовПоСтруктуре;
	
	Иначе
		
		ПервыйЭлемент = Истина;
		СтрокаТаблиц = "";
		Для Каждого ЭлементКоллекции Из КоллекцияПоискаПоПодстроке Цикл
			
			ТипЗначенияПоиска = ОпределитьТипОграниченийПоПолю(ЭлементКоллекции.Имя, МетаданныеОбъекта);
			
			Если ЭлементКоллекции.Имя <> "Наименование" И ЭлементКоллекции.Имя <> "Код" Тогда
				СтрокаПолей = СтрокаПолей + "
				|	ТаблицаВложенногоЗапроса.Ссылка." + ЭлементКоллекции.Имя + " КАК " + ЭлементКоллекции.Имя + ",";
			КонецЕсли;
			
			Если НЕ ПервыйЭлемент Тогда
				СтрокаТаблиц = СтрокаТаблиц + "
				|
				|	ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли; 
			ПервыйЭлемент = Ложь;
			
			СтрокаТаблиц = СтрокаТаблиц + "
			|	ВЫБРАТЬ  ПЕРВЫЕ " + Строка(КоличествоЭлементов) + "
			|		ТаблицаСправочника.Ссылка КАК Ссылка
			|	ИЗ
			|		" + ВеткаМетаданных + "." + ИмяТаблицыСправочника + " КАК ТаблицаСправочника
			|	ГДЕ ";

			
			ОграничениеПоПолю = СформироватьОграничениеПоПолюВхождениеВНачало("ТаблицаСправочника." + ЭлементКоллекции.Имя, ТипЗначенияПоиска);
			
			ОграничениеПоПолю = ОграничениеПоПолю + "
			|	И НЕ ТаблицаСправочника.ПометкаУдаления ";
			
			СтрокаТаблиц = СтрокаТаблиц +"
			|	" + ОграничениеПоПолю + СтрокаОтборовПоСтруктуре;		
		КонецЦикла; 
		
		Запрос.Текст = Лев(СтрокаПолей, (СтрДлина(СтрокаПолей) - 1)) + "
		|ИЗ
		|
		|	(
		|" + СтрокаТаблиц + "
		|	) КАК ТаблицаВложенногоЗапроса";
	
	КонецЕсли; 
	
	Возврат Запрос.Выполнить();

КонецФункции

// Функция подбирает значения по выборке
Функция ПолучитьАвтоподборПоВыборке(РезультатЗапроса, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПоляПоиска, Знач ПолеВыбора = "") 
	
	СтруктураНайденногоЭлемента = Новый Структура;
	
	Если РезультатЗапроса = Неопределено Тогда
		Возврат СтруктураНайденногоЭлемента;
	КонецЕсли; 
	
	СтандартнаяОбработка = Ложь;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат СтруктураНайденногоЭлемента;
	КонецЕсли;
	
	ВрегТекст =	ВРег(Текст);
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Количество() <> 1 Тогда
		Возврат СтруктураНайденногоЭлемента;
	КонецЕсли;

	// выбран только один элемент - его и подставляем
	Выборка.Следующий();
	Для Каждого ИмяПоляПоиска Из ПоляПоиска Цикл
		ВрегЗначение = Врег(Выборка[ИмяПоляПоиска]);
		
		Если Лев(ВрегЗначение, СтрДлина(ВрегТекст)) = ВрегТекст Тогда
			Если ВрегТекст <> ВрегЗначение Тогда
				
				Если ПустаяСтрока(ПолеВыбора) Тогда
					ТекстАвтоподбора = Выборка[ИмяПоляПоиска];
				Иначе
					ТекстАвтоподбора = Выборка[ПолеВыбора];
				КонецЕсли;
				
				УправлениеКонтактнойИнформацией.ПеренестиСтрокуВыборкиВСтруктуру(РезультатЗапроса, Выборка, СтруктураНайденногоЭлемента);
			КонецЕсли;
			
			Возврат СтруктураНайденногоЭлемента;
		КонецЕсли; 
		
	КонецЦикла; 
		
КонецФункции

// Функция формирует массив имен полей по которым организованн ввод по строке
Функция СформироватьМассивПоКоллекцииВводаПоСтроке(ТипСправочника) 
	
	ПоляПоиска = Новый Массив();
	ПустаяСсылка = Новый(ТипСправочника);
	КоллекцияЭлементовПоиска = ПустаяСсылка.Метаданные().ВводПоСтроке;
	Для Каждого ЭлементКоллекции Из КоллекцияЭлементовПоиска Цикл
		ПоляПоиска.Добавить(ЭлементКоллекции.Имя)
	КонецЦикла;
	
	Возврат ПоляПоиска;
	
КонецФункции

// Процедура обслуживает событие АвтоПодборТекста элемента управления ПолеВвода для подмены автопоиска по тексту.
//
// Параметры
//  Элемент - поле ввода
//  Текст - текст введенный в поле ввода Вид
//  ТекстАвтоПодбора - текст автоподбора в поле Вид
//  СтандартнаяОбработка - булево, флаг стандартной обработки события автоподбора
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ТипСправочника - Тип, тип справочника автоподбора текста
//
Процедура АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, СтруктураПараметров, ТипСправочника) Экспорт

	РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбора(Текст, СтруктураПараметров, ТипСправочника, 2);
	ПоляПоиска = СформироватьМассивПоКоллекцииВводаПоСтроке(ТипСправочника);
	ПолучитьАвтоподборПоВыборке(РезультатЗапроса, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПоляПоиска);
	
КонецПроцедуры

// Функция обслуживает событие АвтоПодборТекста элемента управления ПолеВвода для подмены автопоиска по тексту.
//
// Параметры
//  Элемент - поле ввода
//  Текст - текст введенный в поле ввода Вид
//  ТекстАвтоПодбора - текст автоподбора в поле Вид
//  СтандартнаяОбработка - булево, флаг стандартной обработки события автоподбора
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ТипСправочника - строка, имя регистра в котором ищется информация
//	ПоляПоиска - массивы полей для Поиска
//
Функция АвтоПодборТекстаВЭлементеУправленияПоРегистру(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, СтруктураПараметров, 
														ИмяРегистра, ПоляПоиска, ПолеВыбора) Экспорт

	РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбораДляРегистра(Текст, СтруктураПараметров, ИмяРегистра, ПоляПоиска, 2);
	СтруктураНайденногоЭлемента = ПолучитьАвтоподборПоВыборке(РезультатЗапроса, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПоляПоиска, ПолеВыбора);
	Возврат СтруктураНайденногоЭлемента;
	
КонецФункции

// Функция формирует список выбора значений, для АдресногоКлассификатора
Функция СформироватьСписокВыбораАдресногоКлассификатора(ТаблицаЗапроса, Знач Текст, НачальныйУровеньДетализации, КонечныйУровеньДетализации)

	КЧ = Новый КвалификаторыЧисла(12,2);
	Массив = Новый Массив;
	Массив.Добавить(Тип("Число"));
	ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,КЧ);
	
	ТаблицаЗапроса.Колонки.Добавить("УникальныйНомерСтроки", ОписаниеТиповЧ);
	
	СписокВозврата = Новый СписокЗначений;
	
	Текст = ВРег(Текст);
	ДлинаТекста = СтрДлина(Текст);
	
	НомерЭлемента = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаЗапроса Цикл
		
		СтрокаТаблицы.УникальныйНомерСтроки = НомерЭлемента;
		НомерЭлемента = НомерЭлемента + 1;
				
		Если ВРег(Лев(СтрокаТаблицы.Наименование, ДлинаТекста)) = Текст Тогда
			
			// Нужно сформировать полное наименование адресного элемента
			// Смотрим какой уровень детализации и такое наименование и строим
			НаименованиеЭлемента = УправлениеКонтактнойИнформацией.ПолучитьПолноеНазвание(СтрокаТаблицы.Код, НачальныйУровеньДетализации, КонечныйУровеньДетализации);
			НаименованиеТекущегоУровня = СтрокаТаблицы.Наименование + " " + СтрокаТаблицы.Сокращение;
			ПолноеНаименованиеЭлемента = ?(НЕ ЗначениеЗаполнено(НаименованиеЭлемента), НаименованиеТекущегоУровня, 
											НаименованиеТекущегоУровня + " (" + НаименованиеЭлемента + ")");
			СписокВозврата.Добавить(СтрокаТаблицы["УникальныйНомерСтроки"], ПолноеНаименованиеЭлемента);
			
		КонецЕсли;
					
	КонецЦикла; 

	Возврат СписокВозврата;
	
КонецФункции

// функция возвращает был ли выбран пользователем элемент из выпадающего списка выбора
Функция ОпределитьВыборПользователяИзСписка(Элемент, ЭтаФорма, СписокВыбора, ТаблицаВыборки, Значение, ПолеВыбора, СтруктураВыбранногоЭлемента)
	
	// а содержит ли список строки
	Если СписокВыбора.Количество() > 0 Тогда
		// список отсортируем в алфавитном порядке
		СписокВыбора.СортироватьПоПредставлению();
		ВыбранныйЭлемент = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент);
	Иначе
		ВыбранныйЭлемент = Неопределено; // если список пустой - выбирать не из чего
	КонецЕсли;
		
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ВыбраннаяСтрока = ТаблицаВыборки.Найти(ВыбранныйЭлемент.Значение, "УникальныйНомерСтроки");
		Значение = ВыбраннаяСтрока[ПолеВыбора];
		// структуру надо вернуть
		УправлениеКонтактнойИнформацией.ПеренестиСтрокуТаблицыВСтруктуру(ТаблицаВыборки, ВыбраннаяСтрока, СтруктураВыбранногоЭлемента);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// процедура переносит значение из выборки в структуру
Процедура ОбработатьЕдинственныйЭлементВыбора(РезультатЗапроса, Выборка, Значение, ПолеВыбора, СтруктураВыбранногоЭлемента)
	
	Выборка.Следующий();
	Значение = Выборка[ПолеВыбора];
	УправлениеКонтактнойИнформацией.ПеренестиСтрокуВыборкиВСтруктуру(РезультатЗапроса, Выборка, СтруктураВыбранногоЭлемента);	
	
КонецПроцедуры

// Процедура предупреждает пользователя что найдено более 50 элементов для подбора
Процедура ПредупредитьНайденоБолееПятидесятиЭлементов()
	
	Предупреждение("Найдено более 50-ти значений, удовлетворяющих условиям выбора.
				   |Задайте более длинную строку или воспользуйтесь командой выбора (F4).");
				   
КонецПроцедуры

// Процедура организует выбор элементов по результату запроса
Процедура ВыбратьЭлементОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, РезультатЗапроса, ЭтаФорма, ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено, 
											ПриОтсутствииЗначенияОставлятьТекст = Истина, ПоляПоиска, ПолеВыбора, 
											СтруктураВыбранногоЭлемента = Неопределено, ОсновноеПредставлениеВВидеКода = Ложь,
											Знач СообщатьПользователюОбОшибкеВводаДанных = Истина)
	
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтандартнаяОбработка = Ложь;
	
	Если РезультатЗапроса.Пустой() И ПриОтсутствииЗначенияОставлятьТекст Тогда
		Значение = Текст;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	ТаблицаВыборки = РезультатЗапроса.Выгрузить();
	Значение = СформироватьСписокВыбораЗначенийПоискаПоСтроке(ТаблицаВыборки, Текст, ПоляПоиска, ОсновноеПредставлениеВВидеКода);
	
КонецПроцедуры

// Процедура организует выбор элементов по результату запроса
Процедура ВыбратьЭлементОкончаниеВводаАдресногоКлассификатора(Элемент, Текст, Значение, СтандартнаяОбработка, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, РезультатЗапроса, ЭтаФорма, ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено, 
											ПриОтсутствииЗначенияОставлятьТекст = Истина, ПоляПоиска, ПолеВыбора, 
											СтруктураВыбранногоЭлемента = Неопределено, НачальныйУровеньДетализации = 0, КонечныйУровеньДетализации = 5)
	
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтандартнаяОбработка = Ложь;
	
	Если РезультатЗапроса.Пустой() И ПриОтсутствииЗначенияОставлятьТекст Тогда
		Значение = Текст;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	КоличествоЭлементовВыборки = Выборка.Количество();
	
	Если КоличествоЭлементовВыборки = 1 Тогда
		
		// единственный элемент в выборке - переносим значение в стуктуру
		ОбработатьЕдинственныйЭлементВыбора(РезультатЗапроса, Выборка, Значение, ПолеВыбора, СтруктураВыбранногоЭлемента);	
		Возврат;
		
	ИначеЕсли КоличествоЭлементовВыборки > 50 Тогда
		
		ПредупредитьНайденоБолееПятидесятиЭлементов();
		// то что пользователь ввел то и оставляем
		Значение = Текст;
        Возврат;
		
	ИначеЕсли КоличествоЭлементовВыборки = 0 Тогда
		ЭлементВыбран = Ложь;
	Иначе
		
		// из выпадающего списка предлагаем выбрать элемент
		ТаблицаВыборки = РезультатЗапроса.Выгрузить();
		СписокВыбора = СформироватьСписокВыбораАдресногоКлассификатора(ТаблицаВыборки, Текст, 
																			НачальныйУровеньДетализации, КонечныйУровеньДетализации);
		
		ЭлементВыбран = ОпределитьВыборПользователяИзСписка(Элемент, ЭтаФорма, СписокВыбора, ТаблицаВыборки, Значение, ПолеВыбора, СтруктураВыбранногоЭлемента);
		
	КонецЕсли; 
	
	Если ЭлементВыбран Тогда
		Возврат;
	КонецЕсли;
	
	// то что пользователь ввел то и оставляем
	Значение = Текст;
		
КонецПроцедуры

// Процедура обслуживает событие ОкончаниеВводаТекста элемента управления Вид в форме записи регистра
// сведений Контактная информация.
//
// Параметры
//  Элемент - поле ввода
//  Текст - текст введенный в поле ввода Вид
//  Значение - данные элемента управления поле ввода
//  СтандартнаяОбработка - булево, флаг стандартной обработки события автоподбора
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ЭтаФорма - форма записи регистра сведений контактная информация
//  ТипСправочника - Тип, тип справочника автоподбора текста
//
Процедура ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, СтруктураПараметров, ЭтаФорма, ТипСправочника,
	ОбработкаПоискаПоСтроке = Неопределено, ТекстПоискаПоСтроке = Неопределено, ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено,
	ПриОтсутствииЗначенияОставлятьТекст = Истина, Знач СообщатьПользователюОбОшибкеВводаДанных = Истина) Экспорт

	Если ПустаяСтрока(Текст) Тогда
		Значение = Новый(ТипСправочника);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли; 
	
	ПоляПоиска = СформироватьМассивПоКоллекцииВводаПоСтроке(ТипСправочника);

	РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбора(Текст, СтруктураПараметров, ТипСправочника, 51);
	
	// определим способ основного представления справочника
	ОсновноеПредставлениеВВидеКода = Ложь;
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипСправочника);
	Если ОбъектМетаданных <> Неопределено Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеСправочника.ВВидеКода Тогда
			ОсновноеПредставлениеВВидеКода = Истина;
		КонецЕсли;
	КонецЕсли;

	ВыбратьЭлементОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, РезультатЗапроса, ЭтаФорма, ПоследнееЗначениеЭлементаПоискаПоСтроке, 
										ПриОтсутствииЗначенияОставлятьТекст, ПоляПоиска, "Ссылка", , ОсновноеПредставлениеВВидеКода,
										СообщатьПользователюОбОшибкеВводаДанных);
	
КонецПроцедуры

// Процедура обслуживает событие ОкончаниеВводаТекста элемента управления По Адресному Классификатору
Процедура ОкончаниеВводаТекстаВЭлементеУправленияПоАдресномуКлассификатору(Элемент, Текст, Значение, СтандартнаяОбработка, СтруктураПараметров, ЭтаФорма, 
															ОбработкаПоискаПоСтроке = Неопределено, ТекстПоискаПоСтроке = Неопределено, 
															ПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено, ПриОтсутствииЗначенияОставлятьТекст = Истина,
															СтруктураВыбранногоЭлемента = Неопределено, 
															НачальныйУровеньДетализацииАдреса, КонечныйУровеньДетализацииАдреса) Экспорт                                               

	Если ПустаяСтрока(Текст) Тогда
		Значение = "";
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли; 

	МассивПоиска = Новый Массив();
    МассивПоиска.Добавить("Наименование");

	СокращенныйТекстТерритории = СокрЛП(УправлениеКонтактнойИнформацией.ОбрезатьСокращение(Текст));
	СообщатьОбОшибкеПриОтсутствииЭлементов = (СокращенныйТекстТерритории = Текст);

  	// пробуем найти адресный элемент без обрезания потенциального сокращения
	РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбораДляРегистра(Текст, СтруктураПараметров, "АдресныйКлассификатор", МассивПоиска, 51);
	Если РезультатЗапроса.Пустой() И НЕ СообщатьОбОшибкеПриОтсутствииЭлементов Тогда
		
		// Ничего найти не удалось. Обрезаем сокращения и пытаемся еще раз
		РезультатЗапроса = ПолучитьРезультатЗапросаАвтоподбораДляРегистра(СокращенныйТекстТерритории, СтруктураПараметров, "АдресныйКлассификатор", МассивПоиска, 51);
		
	КонецЕсли;
	
	ВыбратьЭлементОкончаниеВводаАдресногоКлассификатора(Элемент, Текст, Значение, СтандартнаяОбработка, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке, РезультатЗапроса, 
										ЭтаФорма, ПоследнееЗначениеЭлементаПоискаПоСтроке, ПриОтсутствииЗначенияОставлятьТекст, 
										МассивПоиска, "Наименование", СтруктураВыбранногоЭлемента, НачальныйУровеньДетализацииАдреса, КонечныйУровеньДетализацииАдреса);
	
КонецПроцедуры

// Функция формирует список выбора значений, для события ОкончаниеВводаТекста.
//
// Параметры
//  РезультатЗапроса - РезультатЗапроса при поиске по строке
//  Текст - Строка, текст поиска по строке
//  ТипСправочника - Тип, тип справочника автоподбора текста
//  ОсновноеПредставлениеВВидеКода - Булево, является ли представление в виде кода основным для справочника
//
// Возвращаемое значение:
//   Список значений
//
Функция СформироватьСписокВыбораЗначенийПоискаПоСтроке(ТаблицаЗапроса, Знач Текст, ПоляПоиска, ОсновноеПредставлениеВВидеКода)

	СписокВозврата = Новый СписокЗначений;
	
	Текст = ВРег(Текст);
	ДлинаТекста = СтрДлина(Текст);
	
	ЕстьНаименование = (ТаблицаЗапроса.Колонки.Найти("Наименование") <> Неопределено);
	ЕстьКод          = (ТаблицаЗапроса.Колонки.Найти("Код") <> Неопределено);
	
	НужноИскатьПоКоду 		  = (ОбщегоНазначения.ВернутьИндексВМассиве(ПоляПоиска, "Код") <> -1);
	НужноИскатьПоНаименованию = (ОбщегоНазначения.ВернутьИндексВМассиве(ПоляПоиска, "Наименование") <> -1);

	Для Каждого СтрокаТаблицы Из ТаблицаЗапроса Цикл
		
		Если ЕстьНаименование И НужноИскатьПоНаименованию И ВРег(Лев(СтрокаТаблицы.Наименование, ДлинаТекста)) = Текст Тогда
			Если ОсновноеПредставлениеВВидеКода И ЕстьКод Тогда
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, СтрокаТаблицы.Код + " (" + Строка(СтрокаТаблицы.Наименование) + ")");
			Иначе
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, (СтрокаТаблицы.Наименование + ?(ЕстьКод, (" (" + Строка(СтрокаТаблицы.Код) + ")"), "")));
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Если ЕстьКод И НужноИскатьПоКоду И ВРег(Лев(СтрокаТаблицы.Код, ДлинаТекста)) = Текст Тогда
			Если ЕстьНаименование Тогда
				Если ОсновноеПредставлениеВВидеКода И ЕстьКод Тогда
					СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, СтрокаТаблицы.Код + " (" + Строка(СтрокаТаблицы.Наименование) + ")");
				Иначе
					СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, (СтрокаТаблицы.Наименование + " (" + Строка(СтрокаТаблицы.Код) + ")"));
				КонецЕсли;
			Иначе
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, Строка(СтрокаТаблицы.Код));
			КонецЕсли; 
			Продолжить;
		КонецЕсли;
		
		Для Каждого Колонка Из ТаблицаЗапроса.Колонки Цикл
		
			Если Колонка.Имя = "Наименование" ИЛИ Колонка.Имя = "Код" ИЛИ Колонка.Имя = "Ссылка" Тогда
				Продолжить;
			КонецЕсли; 
		
			Если ВРег(Лев(СтрокаТаблицы[Колонка.Имя], ДлинаТекста)) = Текст Тогда
				СписокВозврата.Добавить(СтрокаТаблицы.Ссылка, ("" + СтрокаТаблицы[Колонка.Имя] + ?(ЕстьНаименование, (" (" + Строка(СтрокаТаблицы.Наименование) + ")"), "")));
				Прервать;
			КонецЕсли
			
		КонецЦикла; 
	
	КонецЦикла;	 

	Возврат СписокВозврата;
	
КонецФункции

// Процедура обслуживает событие ОбновлениеОтображения в форме, где расположен ЭУ поиска по строке.
//
// Параметры
//  ЭтаФорма - Форма записи регистра сведений КонтактнаяИнформация
//  Элемент - элемент управления в котором происводится поиск по строке
//
Процедура ОбновлениеОтображенияВФормеПриПоискеПоСтроке(ЭтаФорма, Элемент, ОбработкаПоискаПоСтроке, ТекстПоискаПоСтроке) Экспорт

	Если ОбработкаПоискаПоСтроке Тогда
		ЭтаФорма.ТекущийЭлемент = Элемент;
		Элемент.ВыделенныйТекст = ТекстПоискаПоСтроке;
		ОбработкаПоискаПоСтроке = Ложь;
		ТекстПоискаПоСтроке = "";
	КонецЕсли; 
	
	Если ТипЗнч(Элемент.Значение) = Тип("Строка") Тогда
		Элемент.ЦветТекстаПоля = ЦветаСтиля.ТекстИнформационнойНадписи;
	Иначе
		Элемент.ЦветТекстаПоля = Новый Цвет;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// По плану видов расчета выполняет поиск элементов по первым символам имени с применением шаблона
// Параметры:
//     	СтрокаПервыеСимволы - Строка - первые символы имени расчета
// 	   	ИмяПланаВидовРасчета - Строка - имя плана видов расчета
//	   	СтрокаДопУсловие - Строка - дополнительное условие для отбора видов расчетов
//		СписокДопПараметры - Структура - параметры запроса, необходимые для вычисления доп. условия
//		СтандартнаяОбработка - Булево - признак стандартной обработки события окончания ввода текста
// Возвращает:
//		Удовлетворяющий шаблону имени и условиям отбора вид расчета, если таких несколько - то список значений
Функция ПолучитьСписокВидовРасчетаПоПервымСимволамИмениРасчета(СтрокаПервыеСимволы, ИмяПланаВидовРасчета, СтрокаДопУсловие, СтруктураДопПараметры, СтандартнаяОбработка) Экспорт
	Если ПустаяСтрока(СтрокаПервыеСимволы) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 51
	               |	ОсновныеНачисленияОрганизаций.Ссылка КАК Ссылка,
	               |	ОсновныеНачисленияОрганизаций.Наименование + "" ("" + ОсновныеНачисленияОрганизаций.Код + "")"" КАК СтрокаПредставления
	               |ИЗ
	               |	ПланВидовРасчета." + ИмяПланаВидовРасчета + " КАК ОсновныеНачисленияОрганизаций
	               |
	               |ГДЕ
	               |	ОсновныеНачисленияОрганизаций.Наименование ПОДОБНО &парамШаблонИмени
				   | " + ?(СтрокаДопУсловие = "" , "", " И " + СтрокаДопУсловие);
				   
	// Параметры, требуемые для вычисления дополнительного условия
    Для Каждого Элемент ИЗ СтруктураДопПараметры  Цикл
        Запрос.УстановитьПараметр(Элемент.Ключ , Элемент.Значение);
    КонецЦикла; 
	
	// заменим спецсимволы
	СтрокаПервыеСимволы = СтрЗаменить(СтрокаПервыеСимволы, "~", "~~");
	СтрокаПервыеСимволы = СтрЗаменить(СтрокаПервыеСимволы, "%", "~%");
	СтрокаПервыеСимволы = СтрЗаменить(СтрокаПервыеСимволы, "_", "~_");
	СтрокаПервыеСимволы = СтрЗаменить(СтрокаПервыеСимволы, "[", "~[");
	СтрокаПервыеСимволы = СтрЗаменить(СтрокаПервыеСимволы, "-", "~-");
	
	Запрос.УстановитьПараметр("парамШаблонИмени", СтрокаПервыеСимволы + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Значение = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		Значение.Добавить(Выборка.Ссылка, Выборка.СтрокаПредставления);
	КонецЦикла;
	
	СтандартнаяОбработка = (Значение.Количество() > 50);
	
	Возврат Значение;
	
КонецФункции

