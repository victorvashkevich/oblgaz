﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;

#Если Клиент ИЛИ ВнешнееСоединение Тогда

Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	Возврат ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
    //Копируем настройки выбранных полей
	Группа = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	
	//Для каждого ВыбранноеПоле из КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
	//	Если ВыбранноеПоле <> Группа тогда
	//		НовоеПолеВыбора = Группа.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	//		ЗаполнитьЗначенияСвойств(НовоеПолеВыбора, ВыбранноеПоле);
	//	КонецЕсли;
	//КонецЦикла;
	
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
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КоэффициентВыслуги"));

	ЗначениеПараметра.Значение=Справочники.КоэффициентыСтажа.НайтиПоНаименованию("Выслуга лет");
	
	СервисныеПроцедурыИФункции.УстановитьЗначениеОтбора(КомпоновщикНастроек.Настройки.Отбор.Элементы,"Организация",УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"));
	
КонецПроцедуры


Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли