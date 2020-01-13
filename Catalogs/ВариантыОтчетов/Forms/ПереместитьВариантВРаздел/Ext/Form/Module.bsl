﻿
&НаКлиенте
Процедура ДеревоПодсистемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.ДеревоПодсистем.ТекущиеДанные = Неопределено тогда
		Предупреждение("Не выбран раздел отчета");
		Возврат;
	КонецЕсли;
	
	Путь = Элементы.ДеревоПодсистем.ТекущиеДанные.Путь;
	Закрыть(Путь);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагузитьСтруктураПодсистем();

КонецПроцедуры

&НаСервере
Процедура ЗагузитьСтруктураПодсистем()
	
	ДеревоПодсистемДляКопирования = Новый ДеревоЗначений;
	ДеревоПодсистемДляКопирования.Колонки.Добавить("Подсистема");
	ДеревоПодсистемДляКопирования.Колонки.Добавить("Название");
	
	СписокПодсистем = Новый СписокЗначений;
	СписокПодсистем.Добавить("");
	
	// Сделаем список отчетов
	СписокПодсистем = ВариантыОтчетов.ПолучитьСписокПодсистем(СписокПодсистем, ДеревоПодсистемДляКопирования);

	СтрокаКонфигурации = ДеревоПодсистем.ПолучитьЭлементы().Добавить();
	СтрокаКонфигурации.Путь = "";
	СтрокаКонфигурации.Представление = "Конфигурация";
	СтрокаКонфигурации.Предопредленная = истина;
	
	СоответсвиеПодсистемИСтрок = Новый Соответствие;
	
	СкопироватьДеревоЗначений(СтрокаКонфигурации.ПолучитьЭлементы(), ДеревоПодсистемДляКопирования.Строки, СоответсвиеПодсистемИСтрок);

КонецПроцедуры

&НаСервере
Процедура СкопироватьДеревоЗначений(КолекцияПриемник, КолекцияИсточник, СоответсвиеПодсистемИСтрок)
	
	Для каждого Элемент из КолекцияИсточник Цикл
		СтрокаЗначение                 = КолекцияПриемник.Добавить();
		СтрокаЗначение.Путь            = Элемент.Подсистема;
		СтрокаЗначение.Представление   = Элемент.Название;
		СтрокаЗначение.Предопредленная = Метаданные.НайтиПоПолномуИмени("Подсистема." + СтрЗаменить(Элемент.Подсистема, "\", ".Подсистема.")) <> Неопределено;
		СоответсвиеПодсистемИСтрок.Вставить(СтрокаЗначение.Путь, СтрокаЗначение);
		СкопироватьДеревоЗначений(СтрокаЗначение.ПолучитьЭлементы(), Элемент.Строки, СоответсвиеПодсистемИСтрок);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.ДеревоПодсистем.ТекущиеДанные = Неопределено тогда
		Предупреждение("Не выбран раздел отчета");
		Возврат;
	КонецЕсли;
	
	Путь = Элементы.ДеревоПодсистем.ТекущиеДанные.Путь;
	Закрыть(Путь);
	
КонецПроцедуры


