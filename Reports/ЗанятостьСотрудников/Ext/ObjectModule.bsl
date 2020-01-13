﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;

#Если Клиент ИЛИ ВнешнееСоединение Тогда

Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	ДокументРезультат = ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	#Если Клиент Тогда
	Если ТипЗнч(Результат) = Тип("ТабличныйДокумент") ИЛИ ТипЗнч(Результат) = Тип("ПолеТабличногоДокумента") тогда
		Текст = Результат.Область(2,1,2,1).Текст;
		НомерКонца = Найти(Текст, Символы.ПС);
		ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
		ДатаПериода = ЗначениеПараметра.Значение;
		Если ДатаПериода = '00010101' тогда
			ДатаПериода = ОбщегоНазначения.ПолучитьРабочуюДату();
		КонецЕсли;
		Текст = "Период: " + Формат(ДатаПериода, "ДФ=dd.MM.yyyy") + Символы.ПС + Прав(Текст, СтрДлина(Текст)-НомерКонца);
		Результат.Область(2,1,2,1).Текст = Текст;
	КонецЕсли;
	#КонецЕсли

	Возврат ДокументРезультат;
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
	
КонецПроцедуры

#КонецЕсли

#Если Клиент Тогда
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры
             
Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли