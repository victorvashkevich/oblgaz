﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;

#Если Клиент ИЛИ ВнешнееСоединение Тогда

Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	Возврат ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
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

#КонецЕсли

#Если Клиент Тогда
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	ТиповыеОтчеты.ИнициализацияТиповогоОтчета(ЭтотОбъект);
	
	ТиповыеОтчеты.ИнициализацияТиповогоОтчета(ЭтотОбъект);
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = НачалоМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = КонецМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = КонецМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		
	КонецЕсли;
	
	СервисныеПроцедурыИФункции.УстановитьЗначениеОтбора(КомпоновщикНастроек.Настройки.Отбор.Элементы,"ОбособленноеПодразделение",УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"));
	
КонецПроцедуры

Расшифровки = Новый СписокЗначений;

// Структура содержит 
// ИмяОтчета - имя отчета в конфигурации
// Поля - Путь к данным к полям, которые должны расшифровываться
//Элемент = Новый Структура;
//Элемент.Вставить("ИмяОтчета", "ШаблонТиповогоОтчета");
//Элемент.Вставить("Поля", "СуммаВзаиморасчетов.СуммаВзаиморасчетовПриход");
//Расшифровки.Добавить(Элемент, "Шаблон типового отчета");

//Расшифровки.Добавить("ИмяОтчетаВКонфигурации", "Представление отчета для пользователя");

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли