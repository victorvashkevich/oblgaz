﻿&НаСервере
Функция НайтиНастройкуПоИмени(ИмяСохраняемойНастройки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВариантыОтчетов.КлючВарианта КАК КлючВарианта
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.КлючОбъекта   = &КлючОбъекта
	|	И (НЕ ВариантыОтчетов.ПометкаУдаления)
	|	И ВариантыОтчетов.Ссылка = &Ссылка";
	
	Если ЕстьПравоИзменения и НЕ ЕстьПравоДобавления тогда
		Запрос.Текст = "
		|	И (ВариантыОтчетов.Администратор = &Пользователь)";
	КонецЕсли;

				   
	Запрос.Параметры.Вставить("КлючОбъекта",  КлючОбъекта);
	Запрос.Параметры.Вставить("Ссылка", Вариант);
	Запрос.Параметры.Вставить("Пользователь", ТекущийПользователь);
	
	УстановитьПривилегированныйРежим(истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		УстановитьПривилегированныйРежим(истина);
		Выборка = РезультатЗапроса.Выбрать();
		УстановитьПривилегированныйРежим(ложь);
		Выборка.Следующий();
		Возврат Выборка.КлючВарианта;
	КонецЕсли;
		
КонецФункции

&НаСервере
Функция СоздатьНовуюНастройку(ИмяНастройки)
	
	УстановитьПривилегированныйРежим(истина);
	Элемент = Справочники.ВариантыОтчетов.СоздатьЭлемент();
	Элемент.Наименование      = ИмяНастройки;
	Элемент.Описание          = Описание;
	Элемент.Администратор     = ТекущийПользователь;
	Элемент.КлючОбъекта       = КлючОбъекта;
	Элемент.КлючВарианта      = Строка(Новый УникальныйИдентификатор());
	Элемент.ТипВариантаОтчета = Перечисления.ТипыВариантовОтчетов.Пользовательский;
	
	ИмяОтчета = СтрЗаменить(КлючОбъекта, "Отчет.", "");
	МетаданныеОтчета = Метаданные.Отчеты.Найти(ИмяОтчета);
	Если МетаданныеОтчета <> Неопределено тогда
		Элемент.ПредставлениеОбъекта = МетаданныеОтчета.Синоним;
	КонецЕсли;
	
	Элемент.Видимость = Видимость;
	Для каждого ЭлементПользователи из НастройкаВидимости Цикл
		СтрокаПользователи           = Элемент.НастройкаВидимости.Добавить();
		СтрокаПользователи.Пользователь      = ЭлементПользователи.Пользователь;
	КонецЦикла;
	
	Элемент.Подсистемы.Очистить();
	Для каждого ЭлементПользователи из Подсистемы Цикл
		СтрокаПользователи                 = Элемент.Подсистемы.Добавить();
		СтрокаПользователи.Подсистема      = ЭлементПользователи.Подсистема;
		СтрокаПользователи.Название        = ЭлементПользователи.Название;
		СтрокаПользователи.Предопределенная = ЭлементПользователи.Предопределенная;
	КонецЦикла;

	Элемент.Записать();
	Возврат Элемент.КлючВарианта;
	УстановитьПривилегированныйРежим(ложь);
	
КонецФункции

&НаСервере
Функция РазрешеноИзменять(КодСохраняемойНастройки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Ссылка КАК ССылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.КлючОбъекта = &КлючОбъекта
	|	И ВариантыОтчетов.КлючВарианта = &КодСохраняемойНастройки
	|	И ВариантыОтчетов.Администратор = &Пользователь
	|	И НЕ ВариантыОтчетов.ПометкаУдаления
	|	И ВариантыОтчетов.ТипВариантаОтчета <> ЗНАЧЕНИЕ(Перечисление.ТипыВариантовОтчетов.Предопределенный)";
	
	Запрос.Параметры.Вставить("КлючОбъекта", КлючОбъекта);
	Запрос.Параметры.Вставить("КодСохраняемойНастройки", КодСохраняемойНастройки);
	Запрос.Параметры.Вставить("Пользователь", ТекущийПользователь);
	УстановитьПривилегированныйРежим(истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(ложь);
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

&НаКлиенте
Процедура СохранитьВыполнить()
	
	Если ИмяСохраняемойНастройки = "" тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не задано название варианта отчета.'"), ,"НазваниеВараинтаОтчета");
		Возврат;
	КонецЕсли;
	
	Если НовыеИлиСохранитьСуществ = 1 тогда
		
		КодСохраняемойНастройки = НайтиНастройкуПоИмени(ИмяСохраняемойНастройки);
		
		Если КодСохраняемойНастройки <> Неопределено Тогда
			// Уже была настройка с таким именем. Спросим у пользователя, нужно ли перезаписать старую настройку.
			Если Не РазрешеноИзменять(КодСохраняемойНастройки) тогда
				Предупреждение(НСтр("ru = 'Вам запрещено менять данный вариант отчета!'"));
				Возврат;
			КонецЕсли;
			
			ОбновитьНастройку(КодСохраняемойНастройки);
		КонецЕсли;
	Иначе
		// Еще не было настройки с таким именем - сделаем новую
		КодСохраняемойНастройки = СоздатьНовуюНастройку(ИмяСохраняемойНастройки);
		Если КодСохраняемойНастройки = Неопределено тогда
			Предупреждение(НСтр("ru = 'Вам запрещено сохранять свои варианты отчета.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Закрыть(Новый ВыборНастроек(КодСохраняемойНастройки));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройку(КодСохраняемойНастройки)
	
	ТЗ = "ВЫБРАТЬ
	     |	ВариантыОтчетов.Ссылка
	     |ИЗ
	     |	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	     |ГДЕ
	     |	ВариантыОтчетов.КлючВарианта = &КлючВарианта
	     |	И ВариантыОтчетов.КлючОбъекта = &КлючОбъекта";
		 
	Запрос = Новый Запрос(ТЗ);
	Запрос.УстановитьПараметр("КлючВарианта", КодСохраняемойНастройки);
	Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
 	УстановитьПривилегированныйРежим(истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() тогда
		Элемент              = Выборка.Ссылка.ПолучитьОбъект();
		Элемент.Описание     = Описание;
		Элемент.Наименование = ИмяСохраняемойНастройки;
		
		Элемент.Видимость = Видимость;
		Элемент.НастройкаВидимости.Очистить();
		Для каждого ЭлементПользователи из НастройкаВидимости Цикл
			СтрокаПользователи           = Элемент.НастройкаВидимости.Добавить();
			СтрокаПользователи.Пользователь      = ЭлементПользователи.Пользователь;
		КонецЦикла;
		
		Элемент.Подсистемы.Очистить();
		Для каждого ЭлементПользователи из Подсистемы Цикл
			СтрокаПользователи                       = Элемент.Подсистемы.Добавить();
			СтрокаПользователи.Подсистема            = ЭлементПользователи.Подсистема;
			СтрокаПользователи.Название              = ЭлементПользователи.Название;
			СтрокаПользователи.Предопределенная = ЭлементПользователи.Предопределенная;
		КонецЦикла;
		
		Элемент.Записать();
 	УстановитьПривилегированныйРежим(ложь);
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
//                                                         

&НаСервере
Процедура ПриСоздании(Отказ, СтандартнаяОбработка)
	
	Перем КлючТекущихНастроек;
	ЕстьПравоИзменения  = ПравоДоступа("Добавление", Метаданные.Справочники.ВариантыОтчетов);
	ЕстьПравоДобавления = ПравоДоступа("Изменение", Метаданные.Справочники.ВариантыОтчетов);
	
	Элементы.ФормаДалее.Доступность = Истина;
	Элементы.ФормаНазад.Доступность = Ложь;
	
	
	ТипВариантаОтчета = Перечисления.ТипыВариантовОтчетов.Предопределенный;
	
	НовыеИлиСохранитьСуществ = 1;
	
	КлючОбъекта = Параметры.КлючОбъекта;                            
	КлючТекущихНастроек = Параметры.КлючТекущихНастроек;
	ТекущийПользователь = ВариантыОтчетов.ТекущийПользователь();
	
	ЗаполнитьСписок();
	
	СтрокиТаблицы = ВариантыОтчетовТ.НайтиСтроки(Новый Структура("КлючОбъекта", КлючТекущихНастроек));
	Если СтрокиТаблицы.Количество() > 0 тогда
		СтрокаСписка = СтрокиТаблицы[0];
		Элементы.ВариантыОтчета.ТекущаяСтрока = СтрокаСписка.ПолучитьИдентификатор();
		
		Вариант = СтрокаСписка.Ссылка;
		
		ИмяСохраняемойНастройки = СтрокаСписка.Представление;
		Описание = СтрокаСписка.Описание;
		
		ТЗ = "ВЫБРАТЬ
		|	ВариантыОтчетовПодсистемы.Подсистема,
		|	ВариантыОтчетовПодсистемы.Название,
		|	ВариантыОтчетовПодсистемы.Предопределенная
		|ИЗ
		|	Справочник.ВариантыОтчетов.Подсистемы КАК ВариантыОтчетовПодсистемы
		|ГДЕ
		|	ВариантыОтчетовПодсистемы.Ссылка = &Вариант";
		
		Запрос = Новый Запрос(ТЗ);
		Запрос.УстановитьПараметр("Вариант", СтрокаСписка.Ссылка);
	 	УстановитьПривилегированныйРежим(истина);
		Выборка = Запрос.Выполнить().Выбрать();
	 	УстановитьПривилегированныйРежим(ложь);
		
		Пока Выборка.Следующий() Цикл
			СтрокаПодсистемы                 = Подсистемы.Добавить();
			СтрокаПодсистемы.Подсистема      = Выборка.Подсистема;
			СтрокаПодсистемы.Название        = Выборка.Название;
			СтрокаПодсистемы.Предопределенная = Выборка.Предопределенная;
		КонецЦикла;
		
		ТЗ = "ВЫБРАТЬ
		|	ВариантыОтчетовПодсистемы.Подсистема,
		|	ВариантыОтчетовПодсистемы.Название,
		|	ВариантыОтчетовПодсистемы.Предопределенная,
		|	ВариантыОтчетовПодсистемы.Ссылка.КлючОбъекта + ""\"" + ВариантыОтчетовПодсистемы.Ссылка.КлючВарианта КАК Ключ
		|ИЗ
		|	Справочник.ВариантыОтчетов.Подсистемы КАК ВариантыОтчетовПодсистемы
		|ГДЕ
		|	ВариантыОтчетовПодсистемы.Ссылка.КлючОбъекта В(&КлючОбъекта)";
		
		Запрос = Новый Запрос(ТЗ);
		Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	 	УстановитьПривилегированныйРежим(истина);
		Выборка = Запрос.Выполнить().Выбрать();
	 	УстановитьПривилегированныйРежим(ложь);
		
		Пока Выборка.Следующий() Цикл
			СтрокаПодсистемы                       = ПодсистемыВариантов.Добавить();
			СтрокаПодсистемы.Подсистема            = Выборка.Подсистема;
			СтрокаПодсистемы.Название              = Выборка.Название;
			СтрокаПодсистемы.Предопределенная = Выборка.Предопределенная;
			СтрокаПодсистемы.Ключ                  = Выборка.Ключ;
		КонецЦикла;
		
		
		ТЗ = "ВЫБРАТЬ
		|	ВариантыОтчетовНастройкаВидимости.Пользователь,
		|	(НЕ ВариантыОтчетовНастройкаВидимости.Ссылка.Видимость) КАК Видимость,
		|	ВариантыОтчетовНастройкаВидимости.Ссылка.Видимость КАК ВидимостьОбщая,
		|	ВариантыОтчетовНастройкаВидимости.Ссылка.КлючОбъекта + ""\"" + ВариантыОтчетовНастройкаВидимости.Ссылка.КлючВарианта КАК Ключ
		|ИЗ
		|	Справочник.ВариантыОтчетов.НастройкаВидимости КАК ВариантыОтчетовНастройкаВидимости
		|ГДЕ
		|	ВариантыОтчетовНастройкаВидимости.Ссылка.КлючОбъекта В(&КлючОбъекта)";
		
		Запрос = Новый Запрос(ТЗ);
		Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	 	УстановитьПривилегированныйРежим(истина);
		Выборка = Запрос.Выполнить().Выбрать();
	 	УстановитьПривилегированныйРежим(ложь);
	
		Пока Выборка.Следующий() Цикл
			СтрокаПодсистемы              = ВидимостьНастройкиВариантов.Добавить();
			СтрокаПодсистемы.Пользователь = Выборка.Пользователь;
			СтрокаПодсистемы.Видимость    = Выборка.Видимость;
			СтрокаПодсистемы.Ключ         = Выборка.Ключ;
		КонецЦикла;
		
		Элементы.ВариантыОтчета.ТекущаяСтрока = СтрокаСписка.ПолучитьИдентификатор();
	КонецЕсли;

	ЗаполнитьПодсистемы();
	
	СтрокаУО = ЭтаФорма.УсловноеОформление.Элементы[0];
	
	ЗначениеОтбора = СтрокаУО.Отбор.Элементы[0];
	ЗначениеОтбора.ПравоеЗначение = ТекущийПользователь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодсистемы()
	
	Для каждого Подсистема из Метаданные.Подсистемы Цикл
		
		Если Не Подсистема.ВключатьВКомандныйИнтерфейс тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПодсистемы = ДеревоПодсистем.ПолучитьЭлементы().Добавить();
		
		СтрокаПодсистемы.ПутьКПодсистеме = Подсистема.Имя;
		СтрокаПодсистемы.Название        = Подсистема.Синоним;
		
		МассивСтрок                              = Подсистемы.НайтиСтроки(Новый Структура("Подсистема", СтрокаПодсистемы.ПутьКПодсистеме + "\" + Подсистема.Имя));
		СтрокаПодсистемы.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемы.Использование тогда
			СтрокаПодсистемы.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		
		
		ДобавитьДеревоПодсистем(Подсистема, СтрокаПодсистемы);
		
	КонецЦикла;
	
	ВиртуальныеПодсистемы = ВариантыОтчетов.ПолучитьВиртуальныеПодсистемы(Подсистема);
	
	Для каждого Подсистема из ВиртуальныеПодсистемы Цикл
		
		СтрокаПодсистемы = ДеревоПодсистем.Строки.Добавить();
		
		СтрокаПодсистемы.ПутьКПодсистеме = Подсистема.Значение;
		СтрокаПодсистемы.Название        = Подсистема.Представлени;
		
		МассивСтрок                              = Подсистемы.НайтиСтроки(Новый Структура("Подсистема", Подсистема.Значение));
		СтрокаПодсистемы.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемы.Использование тогда
			СтрокаПодсистемы.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		
		ДобавитьДеревоВиртуальныхПодсистем(Подсистема.Значение, СтрокаПодсистемы);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьДеревоПодсистем(Подсистема, СтрокаПодсистемы)
	
	Для каждого ПодсистемаПодчиненная из Подсистема.Подсистемы Цикл
		
		Если Не ПодсистемаПодчиненная.ВключатьВКомандныйИнтерфейс тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПодсистемыПодчиненой               = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		СтрокаПодсистемыПодчиненой.Название      = ПодсистемаПодчиненная.Синоним;
		МассивСтрок                              = Подсистемы.НайтиСтроки(Новый Структура("Подсистема", СтрокаПодсистемы.ПутьКПодсистеме + "\" + ПодсистемаПодчиненная.Имя));
		СтрокаПодсистемыПодчиненой.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемыПодчиненой.Использование тогда
			СтрокаПодсистемыПодчиненой.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		СтрокаПодсистемыПодчиненой.ПутьКПодсистеме = СтрокаПодсистемы.ПутьКПодсистеме + "\" + ПодсистемаПодчиненная.Имя;
		ДобавитьДеревоПодсистем(ПодсистемаПодчиненная, СтрокаПодсистемыПодчиненой);
		
	КонецЦикла;
	
	ВиртуальныеПодсистемы = ВариантыОтчетов.ПолучитьВиртуальныеПодсистемы(СтрокаПодсистемы.ПутьКПодсистеме);
	
	Для каждого ПодсистемаПодчиненная из ВиртуальныеПодсистемы Цикл
		
		СтрокаПодсистемыПодчиненой               = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		СтрокаПодсистемыПодчиненой.Название      = ПодсистемаПодчиненная.Представление;
		МассивСтрок                              = Подсистемы.НайтиСтроки(Новый Структура("Подсистема", ПодсистемаПодчиненная.Значение));
		СтрокаПодсистемыПодчиненой.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемыПодчиненой.Использование тогда
			СтрокаПодсистемыПодчиненой.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		СтрокаПодсистемыПодчиненой.ПутьКПодсистеме = ПодсистемаПодчиненная.Значение;
		ДобавитьДеревоВиртуальныхПодсистем(ПодсистемаПодчиненная.Значение, СтрокаПодсистемыПодчиненой);
		
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьДеревоВиртуальныхПодсистем(Подсистема, СтрокаПодсистемы)
	
	ВиртуальныеПодсистемы = ВариантыОтчетов.ПолучитьВиртуальныеПодсистемы(Подсистема);
	
	Для каждого ПодсистемаПодчиненная из ВиртуальныеПодсистемы Цикл
		
		СтрокаПодсистемыПодчиненой               = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		СтрокаПодсистемыПодчиненой.Название      = ПодсистемаПодчиненная.Представление;
		МассивСтрок                              = Подсистемы.НайтиСтроки(Новый Структура("Подсистема", ПодсистемаПодчиненная.Значение));
		СтрокаПодсистемыПодчиненой.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемыПодчиненой.Использование тогда
			СтрокаПодсистемыПодчиненой.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		СтрокаПодсистемыПодчиненой.ПутьКПодсистеме = ПодсистемаПодчиненная.Значение;
		ДобавитьДеревоВиртуальныхПодсистем(ПодсистемаПодчиненная.Значение, СтрокаПодсистемыПодчиненой);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок()
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВариантыОтчетов.Ссылка КАК Ссылка,
	|	ВариантыОтчетов.Наименование КАК Наименование,
	|	ВариантыОтчетов.КлючОбъекта,
	|	ВариантыОтчетов.Администратор,
	|	ВариантыОтчетов.Администратор.Наименование КАК ОтветственныйПредставление,
	|	ВариантыОтчетов.КлючВарианта,
	|	ВариантыОтчетов.Описание,
	|	ВариантыОтчетов.Видимость,
	|	ВариантыОтчетов.ТипВариантаОтчета
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.КлючОбъекта = &КлючОбъекта
	|	И (НЕ ВариантыОтчетов.ПометкаУдаления)";
	
	Если ЕстьПравоИзменения и НЕ ЕстьПравоДобавления тогда
		Запрос.Текст = "
		|	И (ВариантыОтчетов.Администратор = &Пользователь)";
	КонецЕсли;

	Запрос.Параметры.Вставить("КлючОбъекта",          КлючОбъекта);
	Запрос.Параметры.Вставить("Пользователь", ТекущийПользователь);
	
 	УстановитьПривилегированныйРежим(истина);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
 	УстановитьПривилегированныйРежим(ложь);

	ВариантыОтчетовТ.Очистить();
	Пока Выборка.Следующий() Цикл
		Строкаварианта               	 = ВариантыОтчетовТ.Добавить();
		Строкаварианта.КлючОбъекта  	 = Выборка.КлючВарианта;
		Строкаварианта.Представление	 = Выборка.Наименование;
		Строкаварианта.Ответственный  	 = Выборка.Администратор;
		Строкаварианта.Ссылка        	 = Выборка.Ссылка;
		Строкаварианта.Описание      	 = Выборка.Описание;
		Строкаварианта.Видимость     	 = Выборка.Видимость;
		Строкаварианта.ТипВариантаОтчета = Выборка.ТипВариантаОтчета;
		Строкаварианта.ОтветственныйПредставление = Выборка.ОтветственныйПредставление;
	КонецЦикла;                                                       
	
	ВариантыОтчетовТ.Сортировать("Представление");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПриАктивизацииСтроки(Элемент)
	Если Элементы.Конструктор.ТекущаяСтраница = Элементы.Новый тогда
		Возврат;
	КонецЕсли;
	Если НовыеИлиСохранитьСуществ = 1 Тогда
		Если ТекущийПользователь <> Элемент.ТекущиеДанные.Ответственный тогда
			Элементы.ФормаГотово.Доступность = ложь;
			Элементы.ФормаДалее.Доступность = ложь;
		Иначе
			Элементы.ФормаГотово.Доступность = истина;
			Элементы.ФормаДалее.Доступность = истина;
		КонецЕсли;
	Иначе
		Элементы.ФормаГотово.Доступность = ложь;
		Элементы.ФормаДалее.Доступность = истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СохранитьВыполнить();	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВидимостьВариантаУПользователя(Команда)
	
	СписокПользователей = Новый СписокЗначений;
	Для каждого СтрокаПользователь из НастройкаВидимости Цикл
		СписокПользователей.Добавить(СтрокаПользователь.Пользователь, , Не Видимость);
	КонецЦикла;
	ПараметрыФормы = Новый Структура("Видимость, Пользователи", Видимость, СписокПользователей);
	
	Структура = ОткрытьФормуМодально("Справочник.ВариантыОтчетов.Форма.РедактированиеВидимости", ПараметрыФормы, ЭтаФорма);
	Если Структура = Неопределено тогда
		Возврат;
	КонецЕсли;
	                        
	СписокПользователей = Структура.Пользователи;
	
	НастройкаВидимости.Очистить();
	
	Видимость = Структура.Видимость;
	Для каждого ЭлементПользователи из СписокПользователей Цикл
		СтрокаПользователи              = НастройкаВидимости.Добавить();
		СтрокаПользователи.Пользователь = ЭлементПользователи.Значение;
		СтрокаПользователи.Видимость    = ЭлементПользователи.Пометка;
	КонецЦикла;

 	Элементы.Использование.Заголовок = ОписаниеПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если НовыеИлиСохранитьСуществ = 2 тогда
		НастройкаВидимости.Очистить();
		ИмяСохраняемойНастройки = "";
		Видимость = Ложь;
		Описание = "";
		Автор = ТекущийПользователь; 
		СтрокаПользователя              = НастройкаВидимости.Добавить();
		СтрокаПользователя.Пользователь = ТекущийПользователь;
		СтрокаПользователя.Видимость    = истина;
		Подсистемы.Очистить();
		Для каждого СтрокаПодсистемы из ДеревоПодсистем.ПолучитьЭлементы() Цикл
			СтрокаПодсистемы.Использование = СтрокаПодсистемы.Предопределенная;
			УстановитьГруппировкуПоУмолчанию(СтрокаПодсистемы, истина);
			Если СтрокаПодсистемы.Использование тогда
				СтрокаПодсистем = Подсистемы.Добавить();
				СтрокаПодсистем.Подсистема = СтрокаПодсистемы.ПутьКПодсистеме;
				СтрокаПодсистем.Название = СтрокаПодсистемы.Название;
				СтрокаПодсистем.Предопределенная = СтрокаПодсистемы.Предопределенная;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли НовыеИлиСохранитьСуществ = 1 тогда
		ИмяСохраняемойНастройки = Элементы.ВариантыОтчета.ТекущиеДанные.Представление;
		Описание                = Элементы.ВариантыОтчета.ТекущиеДанные.Описание;
		Автор                   = Элементы.ВариантыОтчета.ТекущиеДанные.Ответственный;
		Вариант                 = Элементы.ВариантыОтчета.ТекущиеДанные.Ссылка;
		Если ТипВариантаОтчета = Элементы.ВариантыОтчета.ТекущиеДанные.ТипВариантаОтчета тогда
			Элементы.Описание.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		// устновить текущих пользователей
		Видимость = Элементы.ВариантыОтчета.ТекущиеДанные.Видимость;
		Для каждого СтрокаПодсистемы из ДеревоПодсистем.ПолучитьЭлементы() Цикл
			МассивСтрок = ПодсистемыВариантов.НайтиСтроки(Новый Структура("Ключ, Подсистема", Элементы.ВариантыОтчета.ТекущиеДанные.КлючОбъекта, СтрокаПодсистемы.ПутьКПодсистеме));
			Если МассивСтрок.Количество() > 0 тогда
				СтрокаПодсистемы.Использование = истина;
			КонецЕсли;
			УстановитьГруппировкуПоУмолчанию(СтрокаПодсистемы, ложь);
		КонецЦикла;
		
		МассивСтрок = ВидимостьНастройкиВариантов.НайтиСтроки(Новый Структура("Ключ", КлючОбъекта + "\" + Элементы.ВариантыОтчета.ТекущиеДанные.КлючОбъекта));
		
		НастройкаВидимости.Очистить();
		
		Для каждого СтрокаПользователя из МассивСтрок Цикл
			НоваяСтрока              = НастройкаВидимости.Добавить();
			НоваяСтрока.Пользователь = СтрокаПользователя.Пользователь;
			НоваяСтрока.Видимость    = НЕ Видимость;
		КонецЦикла;
		
		
		
	КонецЕсли;
	
	Элементы.Конструктор.ТекущаяСтраница = Элементы.Новый;
	Элементы.ФормаДалее.Доступность  = Ложь;
	Элементы.ФормаНазад.Доступность  = Истина;
	Элементы.ФормаГотово.Доступность = Истина;
	
	Элементы.Подсистемы.Заголовок = ОписаниеПодсистем();
	Элементы.Использование.Заголовок = ОписаниеПользователей();
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеПользователей()
	
	ОписаниеПользователя = "";
	Если Видимость тогда
		ОписаниеПользователя = "все" + ?(НастройкаВидимости.Количество() > 0, " кроме: ", "  ");
	Иначе
		ОписаниеПользователя = "";
	КонецЕсли;
	Для каждого СтрокаПользователя из НастройкаВидимости Цикл
		ОписаниеПользователя = ОписаниеПользователя + СтрокаПользователя.Пользователь + ", ";
	КонецЦикла;
	ОписаниеПользователя = Лев(ОписаниеПользователя, СтрДлина(ОписаниеПользователя)-2);
	
	Возврат ОписаниеПользователя;
	
КонецФункции

&НаКлиенте
Функция ОписаниеПодсистем()
	
	СписокПодсистем = "";
	
	Для каждого Подсистема из Подсистемы Цикл
		СписокПодсистем = СписокПодсистем + Подсистема.Название + ", ";
	КонецЦикла;
	
	Возврат Лев(СписокПодсистем, СтрДлина(СписокПодсистем)-2)
	
КонецФункции

&НаКлиенте
Процедура УстановитьГруппировкуПоУмолчанию(СтрокаПодсистемы, Предопределенная = истина)
	
	Для каждого СтрокаПодсистемыПодчиненной из СтрокаПодсистемы.ПолучитьЭлементы() Цикл
		Если НЕ Предопределенная тогда
			МассивСтрок = ПодсистемыВариантов.НайтиСтроки(Новый Структура("Ключ, Подсистема", Элементы.ВариантыОтчета.ТекущиеДанные.КлючОбъекта, СтрокаПодсистемы.ПутьКПодсистеме));
			Если МассивСтрок.Количество() > 0 тогда
				СтрокаПодсистемыПодчиненной.Использование = истина;
			КонецЕсли;
		Иначе
			СтрокаПодсистемыПодчиненной.Использование = СтрокаПодсистемыПодчиненной.Предопределенная;
		КонецЕсли;
		Если СтрокаПодсистемыПодчиненной.Использование тогда
			СтрокаПодсистем = Подсистемы.Добавить();
			СтрокаПодсистем.Подсистема = СтрокаПодсистемыПодчиненной.ПутьКПодсистеме;
			СтрокаПодсистем.Название = СтрокаПодсистемыПодчиненной.Название;
			СтрокаПодсистем.Предопределенная = СтрокаПодсистемыПодчиненной.Предопределенная;
		КонецЕсли;

		УстановитьГруппировкуПоУмолчанию(СтрокаПодсистемыПодчиненной);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.Конструктор.ТекущаяСтраница = Элементы.СохранениеСущ;
	Элементы.ФормаДалее.Доступность = Истина;
	Элементы.ФормаНазад.Доступность = Ложь;
	Элементы.Описание.ТолькоПросмотр = ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	СохранитьВыполнить();	
КонецПроцедуры

&НаКлиенте
Процедура НовыеИлиСохранитьСуществПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если НовыеИлиСохранитьСуществ = 1 Тогда
		Если ТекущийПользователь <> ТекущиеДанные.Ответственный тогда
			Элементы.ФормаГотово.Доступность = ложь;
			Элементы.ФормаДалее.Доступность = ложь;
		Иначе
			Элементы.ФормаГотово.Доступность = Истина;
			Элементы.ФормаДалее.Доступность = истина;
		КонецЕсли;
		Элементы.ВариантыОтчета.Доступность = истина;
	Иначе
		Элементы.ФормаГотово.Доступность    = ложь;
		Элементы.ФормаДалее.Доступность     = истина;
		Элементы.ВариантыОтчета.Доступность = ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодсистемы(Команда)
	
	ПараметрыФормы = Новый Структура("ДеревоПодсистем", ДеревоПодсистем);
	
	ВозвращаемыеПараметры = ОткрытьФормуМодально("Справочник.ВариантыОтчетов.Форма.РедактированиеПодсистемы", ПараметрыФормы, ЭтаФорма);
	
	Если ВозвращаемыеПараметры <> Неопределено тогда
		Подсистемы.Очистить();
		Для каждого ОписаниеПодсистема из ВозвращаемыеПараметры.СписокПодсистем Цикл
			СтрокаПодсистемы = Подсистемы.Добавить();
			СтрокаПодсистемы.Подсистема            = ОписаниеПодсистема.Подсистема;
			СтрокаПодсистемы.Название              = ОписаниеПодсистема.Название;
			СтрокаПодсистемы.Предопределенная = ОписаниеПодсистема.Предопределенная;
		КонецЦикла;
		
		Элементы.Подсистемы.Заголовок = ОписаниеПодсистем();
		
		ПоместитьДеревоЗначенийВформу(ВозвращаемыеПараметры.ДеревоПодсистем);
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоместитьДеревоЗначенийВформу(ДеревоПодсистем)
	
	ДеревоПодсистемЗначение = ДанныеФормыВЗначение(ДеревоПодсистем, Тип("ДеревоЗначений"));
	ЗначениеВРеквизитФормы(ДеревоПодсистемЗначение, "ДеревоПодсистем");
	
КонецПроцедуры 


