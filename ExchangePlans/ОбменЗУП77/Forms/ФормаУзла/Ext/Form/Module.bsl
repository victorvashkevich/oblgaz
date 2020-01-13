﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациям(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	
	Если Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" 
		И Объект.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		
		Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
		
	КонецЕсли;

	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	Объект.ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
	
	ОткрытьФорму("ПланОбмена.ОбменЗУП77.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	//Страница правила отправки данных
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументов",
		"Доступность",
		Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументы.ПодчиненныеЭлементы,
		"ГруппаРежимОтправкиДокументов",
		"Доступность",
		Не Объект.ПравилаОтправкиСправочников = "НеСинхронизировать");
		
	//Видимость отбора по организациям
	Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = Элементы.ГруппаСтраницаОтборПоОрганизациямПустая;
	Иначе
		
		Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = Элементы.ГруппаСтраницаОтборПоОрганизациям;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОткрытьСписокВыбранныхОрганизаций",
			"Видимость",
			Объект.ИспользоватьОтборПоОрганизациям);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПереключательДокументыНеОтправлять",
			"Доступность",
			Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОписаниеДокументыНеОтправлять",
			"Доступность",
			Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	//Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		НовыйЗаголовокОрганизаций = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация"));
	Иначе
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	Возврат Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения].Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения).ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
КонецФункции

