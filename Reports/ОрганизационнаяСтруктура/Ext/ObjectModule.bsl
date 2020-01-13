﻿Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета
Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю
Перем Организация, ПодразделениеОрганизации, ВидОтчета, ВысотаУровня;

//#Если Клиент Тогда
	
Функция ПолучитьДополнительныеНастройкиОтчета() Экспорт
	МассивДополнительныхНастроек = Новый Массив;
	МассивДополнительныхНастроек.Добавить(Новый Структура("Имя, Заголовок, ЗначениеПоУмолчанию", 
		"ВыводитьРуководителей", "Выводить руководителей", Истина));
	МассивДополнительныхНастроек.Добавить(Новый Структура("Имя, Заголовок, ЗначениеПоУмолчанию", 		
		"ВыводитьШтатПодразделений", "Выводить штат подразделений", Истина));
	МассивДополнительныхНастроек.Добавить(Новый Структура("Имя, Заголовок, ЗначениеПоУмолчанию", 		
		"ВыводитьСотрудников", "Выводить сотрудников подразделений", Ложь));
	МассивДополнительныхНастроек.Добавить(Новый Структура("Имя, Заголовок, ЗначениеПоУмолчанию", 		
		"ВыводитьФотографииСотрудников", "Выводить фотографии сотрудников", Ложь));
	Возврат МассивДополнительныхНастроек;
КонецФункции		
	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	ЗначениеПанелипользователя = ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователяОбъекта(ЭтотОбъект);
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);	
	Если ЗначениеПанелипользователя <> Неопределено тогда
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьРуководителей").Значение = ЗначениеПанелиПользователя["ВыводитьРуководителей"];
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьШтатПодразделений").Значение = ЗначениеПанелиПользователя["ВыводитьШтатПодразделений"];
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьСотрудников").Значение = ЗначениеПанелиПользователя["ВыводитьСотрудников"];
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьФотографииСотрудников").Значение = ЗначениеПанелиПользователя["ВыводитьФотографииСотрудников"];
	Иначе
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьРуководителей").Значение = ложь;
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьШтатПодразделений").Значение = ложь;
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьСотрудников").Значение = ложь;
		КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьФотографииСотрудников").Значение = ложь;
	КонецЕсли;
	
	Если ВыводВФормуОтчета Тогда
		Результат.Очистить();
	КонецЕсли;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ДоработатьТиповойОтчетПередВыводом(ЭтотОбъект);
	ДоработатьКомпоновщикПередВыводом();
	
	ПараметрыИсполненияОтчета = Неопределено;
	
	Попытка
		ПараметрыИсполненияОтчета = ПолучитьПараметрыИсполненияОтчета();
	Исключение
    КонецПопытки;
	КомпоновщикНастроек.Восстановить();
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);
	
	//Сгенерируем макет компоновки данных при помощи компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Попытка
		
		МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, КомпоновщикНастроек.Настройки, ?(ВыводВФормуОтчета, ДанныеРасшифровки, Неопределено), , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		//Создадим и инициализируем процессор компоновки
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ?(ВыводВФормуОтчета, ДанныеРасшифровки, Неопределено), Истина);
		ИспользоватьСобытия = ПараметрыИсполненияОтчета <> Неопределено И (ВыводВФормуОтчета И ПараметрыИсполненияОтчета.Свойство("ИспользоватьСобытияПриФормированииОтчета") И ПараметрыИсполненияОтчета.ИспользоватьСобытияПриФормированииОтчета ИЛИ НЕ ВыводВФормуОтчета И ПараметрыИсполненияОтчета.ИспользоватьСобытияПриФормированииОтчета);
		Если ИспользоватьСобытия Тогда
			ПередВыводомОтчета(МакетКомпоновки, ПроцессорКомпоновки);
		КонецЕсли;
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ДеревоЗначений = Новый ДеревоЗначений();
		ПроцессорВывода.УстановитьОбъект(ДеревоЗначений);
		ДанныеОтчета = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
	Исключение
	#Если Клиент Тогда
		РаботаСДиалогами.ВывестиПредупреждение("Отчет не сформирован!" + Символы.ПС + ТиповыеОтчеты.ПолучитьОписаниеРодительскойПричиныИнформацииОбОшибке(ИнформацияОбОшибке()));
	#КонецЕсли
	КонецПопытки;
		
	ДеревоВыводаОтчета = ПостроитьДеревоВыводаОтчета(ДанныеОтчета);
	ВывестиОтчет(ДеревоВыводаОтчета, Результат, Ложь);
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Если ВыводВФормуОтчета Тогда
	#Если Клиент Тогда
		ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ЭтотОбъект, Результат);
	#КонецЕсли
	КонецЕсли;		
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
	Возврат Результат;
	
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
	ОрганизационнаяСтруктураПереопределяемый.ЗадатьТипПоляПодразделенияВСКД(ЭтотОбъект);

КонецПроцедуры

Процедура ПередВыводомЭлементРезультата(МакетКомпоновки, ПроцессорКомпоновки, ЭлементРезультата) Экспорт
	
КонецПроцедуры

Процедура ПередВыводомОтчета(МакетКомпоновки, ПроцессорКомпоновки) Экспорт
	
	
КонецПроцедуры

Процедура ПриВыводеЗаголовкаОтчета(ОбластьЗаголовок) Экспорт
КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	СписокПолейПодстановкиОтборовПоУмолчанию.Вставить("Организация", "ОсновнаяОрганизация");
	
	СписокНастроек = Новый СписокЗначений;
	
    ОрганизационнаяСтруктураПереопределяемый.ЗаполнитьСписокДоступныхНастроек(СписокНастроек);
	
	Возврат Новый Структура("ИспользоватьСобытияПриФормированииОтчета,
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
	ложь, ложь, ложь, ложь, ложь, ложь, истина, ложь, ложь, истина, СписокПолейПодстановкиОтборовПоУмолчанию, СписокНастроек);
	
КонецФункции

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
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеПараметра.Значение = '00010101' Тогда
		ЗначениеПараметра.Значение = КонецДня(ТекущаяДата());
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

Функция СоздатьТаблицуШтатаПодразделения()
	
	Таблица = Новый ТаблицаЗначений();                                                              	
	
	МассивТиповДолжностей = Новый Массив;
	МассивТиповДолжностей.Добавить(Тип("СправочникСсылка.ДолжностиОрганизаций"));
	
	ОрганизационнаяСтруктураПереопределяемый.ДополнитьСоставТиповДолжности(МассивТиповДолжностей);
	
	Таблица.Колонки.Добавить("Должность", Новый ОписаниеТипов(МассивТиповДолжностей));
	Таблица.Колонки.Добавить("КоличествоСтавок", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ЗанятоСтавок", Новый ОписаниеТипов("Число"));
	
	Возврат Таблица;
	
КонецФункции

Функция СоздатьТаблицуСотрудников()
	Таблица = Новый ТаблицаЗначений();                                                              	
	Таблица.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	Таблица.Колонки.Добавить("Должность", Новый ОписаниеТипов("СправочникСсылка.ДолжностиОрганизаций"));
	Таблица.Колонки.Добавить("ТабельныйНомер", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ЗанимаемыхСтавок", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ВидЗанятости", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыЗанятостиВОрганизации"));
	Таблица.Колонки.Добавить("Пол", Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическихЛиц"));
	Таблица.Колонки.Добавить("ДатаРождения", Новый ОписаниеТипов("Дата"));
	Если ВыводитьФотографииСотрудников() Тогда
		Таблица.Колонки.Добавить("Фотография", Новый ОписаниеТипов("ХранилищеЗначения"));
	КонецЕсли;
	Возврат Таблица;
КонецФункции

Процедура ВывестиПодразделение(Макет, ОбластьВывода, СтрокаДанных)
	
	ОбластьПодразделениеНаименование = Макет.ПолучитьОбласть("ПодразделениеНаименование");	
	ОбластьПодразделениеНаименование.Параметры.Название = СтрокаДанных.Подразделение.Наименование;
	ОбластьВывода.Вывести(ОбластьПодразделениеНаименование); 
	Если ВыводитьРуководителей() Тогда
		ОбластьРуководитель = Макет.ПолучитьОбласть("ПодразделениеРуководитель"); 
		Если ЗначениеЗаполнено(СтрокаДанных.Руководитель) Тогда
			ОбластьРуководитель.Параметры.ФИО = СтрокаДанных.Руководитель.Наименование;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаДанных.ДолжностьРуководителя) Тогда
			ОбластьРуководитель.Параметры.Должность = СтрокаДанных.ДолжностьРуководителя.Наименование;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаДанных.Руководитель) Тогда
			ОбластьВывода.Вывести(ОбластьРуководитель); 	
		КонецЕсли;
	КонецЕсли;
	Если ВыводитьШтатПодразделений() И СтрокаДанных.ШтатПодразделения.Количество() > 0 Тогда
		Если ЗначениеЗаполнено(СтрокаДанных.ШтатПодразделения) Тогда
			ОбластьВывода.Вывести(Макет.ПолучитьОбласть("РазделительСекций"));
			ОбластьВывода.Вывести(Макет.ПолучитьОбласть("ШтатнаяЕдиницаЛегенда"));
		КонецЕсли;
		ОбластьШтатнойЕдиницы = Макет.ПолучитьОбласть("ПодразделениеШтатнаяЕдиница");
		Для Каждого СтрокаШтата Из СтрокаДанных.ШтатПодразделения Цикл
			ОбластьШтатнойЕдиницы.Параметры.Должность 			= СтрокаШтата.Должность.Наименование;
			ОбластьШтатнойЕдиницы.Параметры.КоличествоСтавок 	= СтрокаШтата.КоличествоСтавок;
			ОбластьШтатнойЕдиницы.Параметры.ЗанятоСтавок 		= СтрокаШтата.ЗанятоСтавок;
			ОбластьВывода.Вывести(ОбластьШтатнойЕдиницы); 
		КонецЦикла;
	КонецЕсли;
	ОбластьВывода.Вывести(Макет.ПолучитьОбласть("ПодразделениеНиз")); 
	
КонецПроцедуры

Процедура ВывестиСвойствоСотрудника(ОбластьМакета, ОбластьВывода, ИмяСвойства, ЗначениеСвойства)
	ОбластьМакета.Параметры.ИмяСвойства = ИмяСвойства;
	ОбластьМакета.Параметры.ЗначениеСвойства = ЗначениеСвойства;
	ОбластьВывода.Вывести(ОбластьМакета); 
КонецПроцедуры

Процедура ВывестиСотрудника(Макет, ОбластьВывода, СтрокаДанных)
	
	ОбластьСотрудникЗаголовок = Макет.ПолучитьОбласть("СотрудникЗаголовок");	
	ОбластьСотрудникЗаголовок.Параметры.ФИО = СтрокаДанных.Сотрудник.Наименование;
	ОбластьСотрудникЗаголовок.Параметры.Должность = СтрокаДанных.Должность.Наименование;
	ОбластьВывода.Вывести(ОбластьСотрудникЗаголовок); 
	Если ВыводитьФотографииСотрудников() Тогда
		ОбластьФото = Макет.ПолучитьОбласть("СотрудникФото");	
		ДанныеДляФото = СтрокаДанных.Фотография;
		Если ДанныеДляФото <> Null Тогда
			Фото = ДанныеДляФото.Получить();
			Если Фото <> Неопределено Тогда
				ОбластьФото.Рисунки.Фото.Картинка = Фото;
			КонецЕсли;
		Иначе
			ОбластьФото.Рисунки.Фото.Картинка = Новый Картинка();
		КонецЕсли;	
		ОбластьВывода.Вывести(ОбластьФото);
	КонецЕсли;
	ОбластьСотрудникСвойство = Макет.ПолучитьОбласть("СотрудникСвойство");	
	ВывестиСвойствоСотрудника(ОбластьСотрудникСвойство, ОбластьВывода, "Табельный номер:", СтрокаДанных.ТабельныйНомер);
	ВывестиСвойствоСотрудника(ОбластьСотрудникСвойство, ОбластьВывода, "Занимаемых ставок:", Строка(СтрокаДанных.ЗанимаемыхСтавок));
	ВывестиСвойствоСотрудника(ОбластьСотрудникСвойство, ОбластьВывода, "Вид занятости:", Строка(СтрокаДанных.ВидЗанятости));
	ВывестиСвойствоСотрудника(ОбластьСотрудникСвойство, ОбластьВывода, "Пол:", Строка(СтрокаДанных.Пол));
	ВывестиСвойствоСотрудника(ОбластьСотрудникСвойство, ОбластьВывода, "Дата рождения:", Формат(СтрокаДанных.ДатаРождения, "ДФ=""дд.ММ.гггг"""));
	ОбластьВывода.Вывести(Макет.ПолучитьОбласть("СотрудникНиз")); 
	
КонецПроцедуры

Процедура ВывестиОрганизацию(Макет, ОбластьВывода, Наименование)
	ОбластьПодразделение = Макет.ПолучитьОбласть("Организация");
	ОбластьПодразделение.Параметры.Название = Наименование;
	ОбластьВывода.Вывести(ОбластьПодразделение); 
КонецПроцедуры

Процедура ВывестиИерархиюПодразделения(Макет, ОбластьВывода, СтрокаДанных, Уровень, ПоследнееПодразделение = Ложь, ОбластиВыводаГоризонтальногоСмещения)
	
	ОбластьВертикальноеСоединение 		= Макет.ПолучитьОбласть("ВертСоединение");
	ОбластьВертикальноеСоединениеПустое = Макет.ПолучитьОбласть("ВертСоединениеПустое");
	ОбластьУзел 						= Макет.ПолучитьОбласть("ВертУзел");
	ОбластьПоследнийУзел 				= Макет.ПолучитьОбласть("ВертУзелПоследний");
	ОбластьВертикальноеСмещение 		= Макет.ПолучитьОбласть("ВертСмещение");
	
	// область уровня: данных подразделения, подчиненных элементов и соединений
	ОбластьВыводаУровня = Новый ТабличныйДокумент;	
	
	// формируем область данных о подразделениии
	ОбластьВыводаПодразделения = Новый ТабличныйДокумент;	
	Если Уровень > 0 Тогда
		ОбластьВыводаПодразделения.Вывести(ОбластьВертикальноеСмещение);
	КонецЕсли;
	ВывестиПодразделение(Макет, ОбластьВыводаПодразделения, СтрокаДанных);			
	
	// рисуем соединительные линии
	Если Уровень > 0 Тогда
		ОбластьВыводаСмещения = Новый ТабличныйДокумент;	
		Если ПоследнееПодразделение Тогда
			Область = ОбластьПоследнийУзел;
		Иначе
			Область = ОбластьУзел;
		КонецЕсли;
		ОбластьВыводаСмещения.Вывести(Область);
		Если Не ПоследнееПодразделение Тогда
			Для Индекс = 0 По ОбластьВыводаПодразделения.ВысотаТаблицы - 6 Цикл
				ОбластьВыводаСмещения.Вывести(ОбластьВертикальноеСоединение);
			КонецЦикла;
		КонецЕсли;
		ОбластьВыводаУровня.Присоединить(ОбластьВыводаСмещения);
	КонецЕсли;     		
	
	ОбластьВыводаУровня.Присоединить(ОбластьВыводаПодразделения);	
	ОбластьВывода.Вывести(ОбластьВыводаУровня);
	
	// добавляем области сотрудников, если требуется
	ОбластьВыводаСотрудников = Новый ТабличныйДокумент;	
	Если ВыводитьСотрудников() И СтрокаДанных.Сотрудники.Количество() > 0 Тогда	
		
		ОбластьСоединениеСотрудника 	= Макет.ПолучитьОбласть("СоединениеСотрудника");
		ОбластьУзелСотрудника 			= Макет.ПолучитьОбласть("УзелСотрудника");
		ОбластьУзелСотрудникаПоследний 	= Макет.ПолучитьОбласть("УзелСотрудникаПоследний");
		ОбластьГоризонтальноеСмещение 	= Макет.ПолучитьОбласть("ГоризСмещение");
		
		Для ИндексСотрудника = 0 По СтрокаДанных.Сотрудники.Количество() - 1 Цикл			
			ОбластьВыводаУровня = Новый ТабличныйДокумент;	
			ОбластьВыводаСотрудника = Новый ТабличныйДокумент;	
			ОбластьВыводаСотрудника.Вывести(ОбластьВертикальноеСмещение);
			ВывестиСотрудника(Макет, ОбластьВыводаСотрудника, СтрокаДанных.Сотрудники[ИндексСотрудника]);		
		
			ОбластьВыводаСмещения = Новый ТабличныйДокумент;	
			Если ИндексСотрудника = СтрокаДанных.Сотрудники.Количество() - 1 Тогда
				Область = ОбластьУзелСотрудникаПоследний;
			Иначе
				Область = ОбластьУзелСотрудника;
			КонецЕсли;
			ОбластьВыводаСмещения.Вывести(Область);
			Если Не ИндексСотрудника = СтрокаДанных.Сотрудники.Количество() - 1 Тогда
				Для Индекс = 0 По ОбластьВыводаСотрудника.ВысотаТаблицы - 6 Цикл
					ОбластьВыводаСмещения.Вывести(ОбластьСоединениеСотрудника);
				КонецЦикла;
			КонецЕсли;
			ОбластьВыводаУровня.Присоединить(ОбластьВыводаСмещения);
			ОбластьВыводаУровня.Присоединить(ОбластьВыводаСотрудника);
			ОбластьВыводаСотрудников.Вывести(ОбластьВыводаУровня);
		КонецЦикла;

		ОбластьВыводаСотрудниковСоСмещением = Новый ТабличныйДокумент;
		
		ОбластьВыводаСмещения = Новый ТабличныйДокумент;
		Если СтрокаДанных.Строки.Количество() > 0 Или Уровень > 0 И Не ПоследнееПодразделение Тогда			
			Для Индекс = 0 По ОбластьВыводаСотрудников.ВысотаТаблицы - 1 Цикл
				ОбластьВыводаСмещения.Вывести(ОбластьВертикальноеСоединение);
			КонецЦикла;								
		Иначе
			ОбластьВыводаСмещения.Вывести(ОбластьГоризонтальноеСмещение);			
			Если Уровень > 0 Тогда
				ОбластьВыводаСмещения.Присоединить(ОбластьГоризонтальноеСмещение);
			КонецЕсли;
		КонецЕсли;
		Если Уровень > 0 И СтрокаДанных.Строки.Количество() = 0 Тогда
			ОбластьВыводаСмещения.Присоединить(ОбластьГоризонтальноеСмещение);
		КонецЕсли;
		
		Если ПоследнееПодразделение Тогда
			ОбластьВыводаСотрудниковСоСмещением.Присоединить(ОбластьГоризонтальноеСмещение);
			ОбластьВыводаСотрудниковСоСмещением.Присоединить(ОбластьГоризонтальноеСмещение);
		КонецЕсли;
		
		ОбластьВыводаСотрудниковСоСмещением.Присоединить(ОбластьВыводаСмещения);
		ОбластьВыводаСотрудниковСоСмещением.Присоединить(ОбластьВыводаСотрудников);
		ОбластьВывода.Вывести(ОбластьВыводаСотрудниковСоСмещением);
	КонецЕсли;
	
	// заполняем созданные на верхних уровнях области
	Для Каждого ОбластьВыводаГоризонтальногоСмещения Из ОбластиВыводаГоризонтальногоСмещения Цикл
		Для Индекс = 0 По (ОбластьВыводаПодразделения.ВысотаТаблицы + ОбластьВыводаСотрудников.ВысотаТаблицы) - 1 Цикл
			Если ОбластьВыводаГоризонтальногоСмещения.ПоследнееПодразделение Тогда
				ОбластьВыводаГоризонтальногоСмещения.Область.Вывести(ОбластьВертикальноеСоединениеПустое);
			Иначе
				ОбластьВыводаГоризонтальногоСмещения.Область.Вывести(ОбластьВертикальноеСоединение);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;		
	
	// обрабатываем дочерние элементы дерева
	Если СтрокаДанных.Строки.Количество() > 0 Тогда
		
		ОбластьВыводаУровня = Новый ТабличныйДокумент;
		Если Уровень > 0 Тогда			
			ОбластьВыводаГоризонтальногоСмещения = Новый ТабличныйДокумент;
			НоваяОбласть = ОбластиВыводаГоризонтальногоСмещения.Добавить();
			НоваяОбласть.Область = ОбластьВыводаГоризонтальногоСмещения;
			НоваяОбласть.ПоследнееПодразделение = ПоследнееПодразделение;
		КонецЕсли;
		
		ОбластьВыводаПодразделения = Новый ТабличныйДокумент;
		Для Индекс = 0 По СтрокаДанных.Строки.Количество() - 1 Цикл
			ВывестиИерархиюПодразделения(Макет, ОбластьВыводаПодразделения, СтрокаДанных.Строки[Индекс], Уровень + 1, Индекс = СтрокаДанных.Строки.Количество() - 1, ОбластиВыводаГоризонтальногоСмещения);
		КонецЦикла;
		
		Если Уровень > 0 Тогда
			ОбластьВыводаУровня.Присоединить(ОбластьВыводаГоризонтальногоСмещения);
			ОбластиВыводаГоризонтальногоСмещения.Удалить(ОбластиВыводаГоризонтальногоСмещения.Количество() - 1);
		КонецЕсли;
		
		ОбластьВыводаУровня.Присоединить(ОбластьВыводаПодразделения);	
		ОбластьВывода.Вывести(ОбластьВыводаУровня);
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВывестиОтчет(Дерево, ТабДокумент, ПоказыватьЗаголовок)

	//Создание табличного документа и загрузка необходимых областей из макета
	ТабДокумент.Очистить();
	Макет		=	ПолучитьМакет("МакетВывода");
	
	ОбластьЗаголовок         	=	Макет.ПолучитьОбласть("Заголовок");
	ОбластьЛевыйКорневойУзел    =	Макет.ПолучитьОбласть("ЛевыйКорневойУзел");
	ОбластьПравыйКорневойУзел   =	Макет.ПолучитьОбласть("ПравыйКорневойУзел");
	ОбластьСреднийКорневойУзел	=	Макет.ПолучитьОбласть("СреднийКорневойУзел");		
	ОбластьВертикальноеСоединениеШирокое 	=	Макет.ПолучитьОбласть("ВертСоединениеШирокое");
	ОбластьВертикальноеСмещение 	=	Макет.ПолучитьОбласть("ВертСмещение");
	ОбластьГоризонтальноеСоединение = 	Макет.ПолучитьОбласть("ГоризСоединение"); 
	
	ОбластьЗаголовок.Параметры.ВидДиаграммы = "Организационная структура учреждения";
	ОбластьЗаголовок.Параметры.Дата = Формат(КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период").Значение, "ДФ=""дд ММММ гггг""");
	ТабДокумент.Вывести(ОбластьЗаголовок);
	ВысотаЗаголовка = ОбластьЗаголовок.ВысотаТаблицы;
	ТабДокумент.Область("R1:R" + ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	
	ОбластьВывода = Новый ТабличныйДокумент;
	ОбластьВывода.Вывести(ОбластьВертикальноеСмещение);
	
	ЗначениеПараметра = ОрганизационнаяСтруктураПереопределяемый.ПолучитьНаименованиеКорневогоЭлементаДерева(КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы);
	
	ВывестиОрганизацию(Макет, ОбластьВывода, ЗначениеПараметра);
	
	ОбластьВывода.Вывести(ОбластьВертикальноеСоединениеШирокое);
	ТабДокумент.Присоединить(ОбластьВывода);
	
	Подразделения = Новый ТабличныйДокумент;	
	ОбластиСмещения = Новый ТаблицаЗначений;
	ОбластиСмещения.Колонки.Добавить("Область");
	ОбластиСмещения.Колонки.Добавить("ПоследнееПодразделение");
	
	Для ИндексСтроки = 0 По Дерево.Строки.Количество() - 1 Цикл
		
		ОбластьВыводаПодразделения = Новый ТабличныйДокумент;
		
		ОбластиСмещения.Очистить();
		ВывестиИерархиюПодразделения(Макет, ОбластьВыводаПодразделения, Дерево.Строки[ИндексСтроки], 0, , ОбластиСмещения);
		
		ОбластьВывода = Новый ТабличныйДокумент;
		Если ИндексСтроки = 0 Тогда
			Если  ИндексСтроки <> Дерево.Строки.Количество() - 1 Тогда
				ОбластьВывода.Вывести(ОбластьЛевыйКорневойУзел);
			Иначе
				ОбластьВывода.Вывести(ОбластьВертикальноеСоединениеШирокое);
			КонецЕсли;	
		ИначеЕсли ИндексСтроки = Дерево.Строки.Количество() - 1 Тогда
			ОбластьВывода.Вывести(ОбластьПравыйКорневойУзел);
		Иначе
			ОбластьВывода.Вывести(ОбластьСреднийКорневойУзел);
		КонецЕсли;
		
		Если ИндексСтроки <> Дерево.Строки.Количество() - 1 Тогда
			Для Индекс = 0 По ОбластьВыводаПодразделения.ШиринаТаблицы - 16 Цикл
				ОбластьВывода.Присоединить(ОбластьГоризонтальноеСоединение);
			КонецЦикла;
		КонецЕсли;
		
		ОбластьВывода.Вывести(ОбластьВыводаПодразделения);
		Подразделения.Присоединить(ОбластьВывода);		
		
	КонецЦикла;
	
	ТабДокумент.Вывести(Подразделения);	
	
КонецПроцедуры 

Функция ДобавитьПодразделениеКВыводу(Дерево, СтрокаДанных, СтрокаРодитель = Неопределено, Уровень = 0)
	
	Если СтрокаРодитель <> Неопределено И СтрокаРодитель.Подразделение = СтрокаДанных.Подразделение Тогда
		СтрокаДерева = СтрокаРодитель;
		МаксимальныйУровень = СтрокаРодитель.МаксимальныйУровень;
	Иначе
		Если СтрокаРодитель <> Неопределено Тогда 
			СтрокаДерева = СтрокаРодитель.Строки.Добавить();
		Иначе
			СтрокаДерева = Дерево.Строки.Добавить();
		КонецЕсли;
		
		СтрокаДерева.Подразделение = СтрокаДанных.Подразделение;
		Если ВыводитьРуководителей() Тогда
			СтрокаДерева.Руководитель = СтрокаДанных.ПодразделениеРуководитель;
			СтрокаДерева.ДолжностьРуководителя = СтрокаДанных.ПодразделениеДолжностьРуководителя;
		КонецЕсли;
		
		Если ВыводитьШтатПодразделений() Тогда		
			СтрокаДерева.ШтатПодразделения = СоздатьТаблицуШтатаПодразделения();
		КонецЕсли;
		
		Если ВыводитьСотрудников() Тогда		
			СтрокаДерева.Сотрудники = СоздатьТаблицуСотрудников();
		КонецЕсли;
		
		МаксимальныйУровень = Уровень;
	КонецЕсли;		
	
	Для Каждого ВложеннаяСтрока Из СтрокаДанных.Строки Цикл
		Если ЗначениеЗаполнено(ВложеннаяСтрока.ШтатноеРасписаниеДолжность) Тогда
			СтрокаШтата = СтрокаДерева.ШтатПодразделения.Добавить();
			СтрокаШтата.Должность = ВложеннаяСтрока.ШтатноеРасписаниеДолжность;
			СтрокаШтата.КоличествоСтавок = ВложеннаяСтрока.ШтатноеРасписаниеКоличествоСтавок;
			СтрокаШтата.ЗанятоСтавок = ВложеннаяСтрока.ШтатноеРасписаниеЗанятоСтавок;
		ИначеЕсли ЗначениеЗаполнено(ВложеннаяСтрока.Сотрудник) Тогда
			СтрокаСотрудника = СтрокаДерева.Сотрудники.Добавить();
			СтрокаСотрудника.Сотрудник = ВложеннаяСтрока.Сотрудник;
			СтрокаСотрудника.Должность = ВложеннаяСтрока.СотрудникДолжность;
			СтрокаСотрудника.ТабельныйНомер = ВложеннаяСтрока.СотрудникТабельныйНомер;
			СтрокаСотрудника.ЗанимаемыхСтавок = ВложеннаяСтрока.СотрудникЗанимаемыхСтавок;
			СтрокаСотрудника.ВидЗанятости = ВложеннаяСтрока.СотрудникВидЗанятости;
			СтрокаСотрудника.Пол = ВложеннаяСтрока.СотрудникПол;
			СтрокаСотрудника.ДатаРождения = ВложеннаяСтрока.СотрудникДатаРождения;
			Если ВыводитьФотографииСотрудников() Тогда
				СтрокаСотрудника.Фотография = ВложеннаяСтрока.СотрудникФотография;
			КонецЕсли;
		Иначе
			МаксУровеньВложеннойСтроки = ДобавитьПодразделениеКВыводу(Дерево, ВложеннаяСтрока, СтрокаДерева, Уровень + 1);
			Если МаксУровеньВложеннойСтроки > МаксимальныйУровень Тогда
				МаксимальныйУровень = МаксУровеньВложеннойСтроки; 
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
	СтрокаДерева.МаксимальныйУровень = МаксимальныйУровень;
	
	Возврат МаксимальныйУровень;
	
КонецФункции

Функция ПостроитьДеревоВыводаОтчета(ДанныеОтчета) Экспорт
	
	ДеревоОтчета = Новый ДеревоЗначений();
	
	МассивТиповПодразделений = Новый Массив;
	МассивТиповПодразделений.Добавить(Тип("СправочникСсылка.ПодразделенияОрганизаций"));
	
	ОрганизационнаяСтруктураПереопределяемый.ДополнитьСоставТиповПодразделения(МассивТиповПодразделений);
	
	ДеревоОтчета.Колонки.Добавить("Подразделение", Новый ОписаниеТипов(МассивТиповПодразделений)); 	
	Если ВыводитьРуководителей() Тогда
		ДеревоОтчета.Колонки.Добавить("Руководитель", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица")); 	
		ДеревоОтчета.Колонки.Добавить("ДолжностьРуководителя", Новый ОписаниеТипов("СправочникСсылка.ДолжностиОрганизаций")); 	
	КонецЕсли;
	ДеревоОтчета.Колонки.Добавить("Уровень", Новый ОписаниеТипов("Число"));
	ДеревоОтчета.Колонки.Добавить("МаксимальныйУровень", Новый ОписаниеТипов("Число"));
	Если ВыводитьШтатПодразделений() Тогда
		ДеревоОтчета.Колонки.Добавить("ШтатПодразделения", Новый ОписаниеТипов("ТаблицаЗначений")); 	
	КонецЕсли;
	Если ВыводитьСотрудников() Тогда
		ДеревоОтчета.Колонки.Добавить("Сотрудники", Новый ОписаниеТипов("ТаблицаЗначений")); 	
	КонецЕсли;
	
	Для Каждого СтрокаДанных Из ДанныеОтчета.Строки Цикл
		ДобавитьПодразделениеКВыводу(ДеревоОтчета, СтрокаДанных);
	КонецЦикла;
	
	Возврат ДеревоОтчета;

КонецФункции // ПостроитьДеревоВыводаОтчета()

Функция ВыводитьРуководителей()
	Возврат КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьРуководителей").Значение;
КонецФункции

Функция ВыводитьШтатПодразделений()
	Возврат КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьШтатПодразделений").Значение;
КонецФункции

Функция ВыводитьСотрудников()
	Возврат КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьСотрудников").Значение;
КонецФункции

Функция ВыводитьФотографииСотрудников()
	Возврат КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВыводитьФотографииСотрудников").Значение;
КонецФункции

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если КомпоновщикНастроек = Неопределено Тогда
	КомпоновщикНастроек =  Новый КомпоновщикНастроекКомпоновкиДанных;
КонецЕсли;

УправлениеОтчетами.ЗаменитьНазваниеПолейСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
