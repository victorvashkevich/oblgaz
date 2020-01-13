﻿
// Функция возвращает номер версии универсального механизма, с которой совместим отчет.
//
Функция ВерсияСтандартныхФункцийОтчетов() Экспорт
	Возврат "1";
КонецФункции

// Функция возвращает структуру настроек отчета
//
Функция ПолучитьНастройкиОтчета() Экспорт
	
	Возврат НастройкиФункцийОтчетовПереопределяемый.ПолучитьНастройкиОтчетаПоУмолчанию();  // получим настройки по умолчанию
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПользовательскиеНастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки;
	ОтображатьКадровыеПереводы = ФункцииОтчетовКлиентСервер.ПолучитьПараметр(
			ПользовательскиеНастройкиОтчета, "ОтображатьКадровыеПереводы");
	
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.Настройки;
	ВыбранныеПоля = ФункцииОтчетовКлиентСервер.ПолучитьВыбранныеПоля(НастройкиОтчета);
	Для Каждого ВыбранноеПоле Из ВыбранныеПоля Цикл
		Если ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("КадровыеПереводы") Тогда
			Если ОтображатьКадровыеПереводы <> Неопределено И ОтображатьКадровыеПереводы.Значение Тогда
				ВыбранноеПоле.Использование = Истина;
			Иначе
				ВыбранноеПоле.Использование = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
