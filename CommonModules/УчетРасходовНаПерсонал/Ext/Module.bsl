﻿
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ УПРАВЛЕНИЯ ПОЛЯМИ ВВОДА АНАЛИТИКИ В ДОКУМЕНТАХ

Функция ПоляВводаАналитикиСозданы(Форма)
	
	Возврат Форма.Элементы.Найти("ГруппаКолонокАналитикаРасходов") <> Неопределено;
	
КонецФункции // ПоляВводаАналитикиСозданы

Функция ТипыАналитикиДокумента(ДанныеФормыОбъект, ИмяТабличнойЧасти)
	
	ТипыАналитики = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ДанныеФормыОбъект[ИмяТабличнойЧасти] Цикл
		ТипАналитики = ТипЗнч(СтрокаТаблицы.АналитикаРасходов);
		Если ТипыАналитики.Найти(ТипАналитики) = Неопределено Тогда
			ТипыАналитики.Добавить(ТипАналитики);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТипыАналитики;
	
КонецФункции // ТипыАналитикиДокумента

Функция РеквизитыВводаАналитикиРасходов(ДанныеДокумента, ИмяТабличнойЧасти) Экспорт
	
	РеквизитыАналитики = Новый Массив;
	
	НастройкиИспользованияАналитики = РегистрыСведений.ИспользованиеАналитикиРасходовНаПерсонал.СоздатьНаборЗаписей();
	НастройкиИспользованияАналитики.Прочитать();
	
	ТипыАналитики = ТипыАналитикиДокумента(ДанныеДокумента, ИмяТабличнойЧасти);
	
	// добавление реквизитов формы
	Для Каждого ТипАналитики Из Метаданные.ПланыВидовХарактеристик.СтатьиРасходов.Тип.Типы() Цикл
		МетаданныеАналитики = Метаданные.НайтиПоТипу(ТипАналитики);
		// реквизит добавляем в случае если:
		// - его использование включено в настройках
		// - в документе уже есть объект аналитики такого типа
		СтрокаНабораЗаписей = ОбщегоНазначенияЗКПереопределяемый.НайтиСтрокуВКоллекции(НастройкиИспользованияАналитики, МетаданныеАналитики.ПолноеИмя(), "ТипАналитики");
		Если (СтрокаНабораЗаписей <> Неопределено И СтрокаНабораЗаписей.Использование) Или ТипыАналитики.Найти(ТипАналитики) <> Неопределено  Тогда
			РеквизитыАналитики.Добавить(Новый Структура("Имя, Тип, ОписаниеТипов, Заголовок", МетаданныеАналитики.Имя, ТипАналитики, Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипАналитики)), ?(ПустаяСтрока(МетаданныеАналитики.ПредставлениеОбъекта), МетаданныеАналитики.Синоним, МетаданныеАналитики.ПредставлениеОбъекта)));
		КонецЕсли;
	КонецЦикла;
	
	Возврат РеквизитыАналитики;
	
КонецФункции // РеквизитыВводаАналитикиРасходов

Функция СоответствиеТиповАналитикиРасходов(РеквизитыАналитики) Экспорт
	
	СоответствиеТиповПолейВводаАналитики = Новый Соответствие;
	
	Для Каждого РеквизитАналитики Из РеквизитыАналитики Цикл
		СоответствиеТиповПолейВводаАналитики.Вставить(РеквизитАналитики.Тип, РеквизитАналитики.Имя);
	КонецЦикла;
	
	Возврат СоответствиеТиповПолейВводаАналитики;
	
КонецФункции // СоответствиеТиповАналитикиРасходов

Процедура СоздатьУсловноеОформлениеПолейВводаАналитикиРасходов(Форма, ПоляВводаАналитики, ИмяТабличнойЧасти)
	
	// для каждого поля аналитики создаем элемент условного оформления:
	// поле доступно только на просмотр, если хотя бы одно из других полей аналитики заполнено
	Для Каждого ПолеВводаАналитики Из ПоляВводаАналитики Цикл
		
		ЭлементУсловногоОформления = Форма.УсловноеОформление.Элементы.Добавить();
	
		ЭлементОформленияТолькоПросмотр = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ТолькоПросмотр");
		ЭлементОформленияТолькоПросмотр.Значение = Истина;
		ЭлементОформленияТолькоПросмотр.Использование = Истина;
		
		// добавляем группу "Или"
		ГруппаИли = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		// добавляем в группу отбора все поля кроме текущего
		Для Каждого ОформляемоеПолеВводаАналитики Из ПоляВводаАналитики Цикл
			Если ОформляемоеПолеВводаАналитики.Значение <> ПолеВводаАналитики.Значение Тогда
				ЭлементОтбораДанных = ГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект." + ИмяТабличнойЧасти + "." + ОформляемоеПолеВводаАналитики.Значение);
				ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
				ЭлементОтбораДанных.Использование = Истина;
			КонецЕсли;
		КонецЦикла;
		
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ПолеВводаАналитики.Значение);
		ОформляемоеПоле.Использование = Истина;
		
	КонецЦикла;
	
КонецПроцедуры // СоздатьУсловноеОформлениеПолейВводаАналитикиРасходов

// Процедура выполняет создание отдельных реквизитов формы и полей ввода 
// для редактирования отдельных типов аналитики расходов 
//
Процедура СоздатьПоляВводаАналитикиРасходов(Форма, ИмяТаблицыФормы, ВставитьПередЭлементом, ИмяДействияПриИзмененииАналитики) Экспорт
	
	РеквизитыАналитики = РеквизитыВводаАналитикиРасходов(Форма.Объект, ИмяТаблицыФормы);
	
	РеквизитыФормы = Новый Массив;
	
	// добавление реквизитов формы
	Для Каждого РеквизитАналитики Из РеквизитыАналитики Цикл
		РеквизитыФормы.Добавить(Новый РеквизитФормы(РеквизитАналитики.Имя, РеквизитАналитики.ОписаниеТипов, "Объект." + ИмяТаблицыФормы, РеквизитАналитики.Заголовок, Истина));
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(РеквизитыФормы);
	
	// добавляем соответствие полей ввода аналитики и типов вводимых значений
	Форма.ИзменитьРеквизиты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый РеквизитФормы("ПоляВводаАналитики", Новый ОписаниеТипов())));
	Форма.ПоляВводаАналитики = Новый ФиксированноеСоответствие(СоответствиеТиповАналитикиРасходов(РеквизитыАналитики));
	
	// добавление группы колонок
	Если ВставитьПередЭлементом <> Неопределено Тогда
		ГруппаКолонок = Форма.Элементы.Вставить("ГруппаКолонокАналитикаРасходов", Тип("ГруппаФормы"), Форма.Элементы[ИмяТаблицыФормы], ВставитьПередЭлементом);
	Иначе
		ГруппаКолонок = Форма.Элементы.Добавить("ГруппаКолонокАналитикаРасходов", Тип("ГруппаФормы"), Форма.Элементы[ИмяТаблицыФормы]);
	КонецЕсли;
	ГруппаКолонок.Вид = ВидГруппыФормы.ГруппаКолонок;
	
	// добавление полей формы
	Для Каждого Реквизит Из РеквизитыФормы Цикл
		ПолеАналитики = Форма.Элементы.Добавить(Реквизит.Имя, Тип("ПолеФормы"), ГруппаКолонок);
		ПолеАналитики.ПутьКДанным = Реквизит.Путь + "." + Реквизит.Имя;
		ПолеАналитики.Вид = ВидПоляФормы.ПолеВвода;
		ПолеАналитики.ОтображатьВПодвале = Ложь;
		ПолеАналитики.УстановитьДействие("ПриИзменении", ИмяДействияПриИзмененииАналитики);
	КонецЦикла;
	
	// добавление правил условного оформления
	СоздатьУсловноеОформлениеПолейВводаАналитикиРасходов(Форма, Форма.ПоляВводаАналитики, ИмяТаблицыФормы);
	
КонецПроцедуры // СоздатьПоляВводаАналитикиРасходов

// Процедура заполняет отдельные поля, созданные для отдельного редактирования 
// объектов аналитики расходов разных типов
//
Процедура ЗаполнитьПоляВводаАналитикиРасходов(ДокументОбъект, Форма, ИмяТабличнойЧасти) Экспорт
	
	Если НЕ ПоляВводаАналитикиСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаКоллекции Из Форма.Объект[ИмяТабличнойЧасти] Цикл
		СтрокаДокумента = ДокументОбъект[ИмяТабличнойЧасти][СтрокаКоллекции.ИсходныйНомерСтроки - 1];
		Если ЗначениеЗаполнено(СтрокаДокумента.АналитикаРасходов) Тогда
			ИмяПоляВвода = Форма.ПоляВводаАналитики.Получить(ТипЗнч(СтрокаДокумента.АналитикаРасходов));
			Если ИмяПоляВвода <> Неопределено Тогда
				СтрокаКоллекции[ИмяПоляВвода] = СтрокаДокумента.АналитикаРасходов;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоляВводаАналитикиРасходов
