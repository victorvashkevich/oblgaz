﻿
Процедура НастройкаВнутригрупповогоПорядкаЭлементовПередЗаписью(Источник, Отказ, ИмяРеквизитаГруппыВЭлементе, ИмяРеквизитаПорядка) Экспорт
	
	// Если в обработчике был установлен отказ новые порядок не вычисляем
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Проверим, есть ли у объекта реквизит доп. упорядочивания
	Информация = НастройкаВнутригрупповогоПорядкаЭлементов.ПолучитьИнформациюДляПеремещенияОМетаданных(Источник.Ссылка, ИмяРеквизитаПорядка);
	Если Не УОбъектаЕстьРеквизитДопУпорядочивания(Источник, Информация) Тогда
		Возврат;
	КонецЕсли;
	
	// Вычислим новое значение для порядка элемента
	Если Источник[ИмяРеквизитаПорядка] = 0 Тогда
		Источник[ИмяРеквизитаПорядка] = НастройкаВнутригрупповогоПорядкаЭлементов.ПолучитьНовоеЗначениеРеквизитаДопУпорядочивания(Информация, Источник[ИмяРеквизитаГруппыВЭлементе], Источник.Владелец, ИмяРеквизитаГруппыВЭлементе, ИмяРеквизитаПорядка);
	КонецЕсли;
	
КонецПроцедуры

Процедура НастройкаВнутригрупповогоПорядкаЭлементовПриКопировании(Источник, ОбъектКопирования, ИмяРеквизитаПорядка) Экспорт
	
	Информация = НастройкаВнутригрупповогоПорядкаЭлементов.ПолучитьИнформациюДляПеремещенияОМетаданных(Источник.Ссылка, ИмяРеквизитаПорядка);
	Если УОбъектаЕстьРеквизитДопУпорядочивания(Источник, Информация) Тогда
		Источник[ИмяРеквизитаПорядка] = 0;
	КонецЕсли;
	
КонецПроцедуры

// Проверить, есть ли у объекта ИмяРеквизитаПорядка
Функция УОбъектаЕстьРеквизитДопУпорядочивания(Объект, Информация)
	
	Если Не Информация.ЕстьРодитель Тогда
		// Справочник неиерархический, значит реквизит есть
		Возврат Истина;
		
	ИначеЕсли Объект.ЭтоГруппа И Не Информация.ДляГрупп Тогда
		// Это группа, но для группа порядок не назначается
		Возврат Ложь;
		
	ИначеЕсли Не Объект.ЭтоГруппа И Не Информация.ДляЭлементов Тогда
		// Это элемент, но для элементов порядок не назначается
		Возврат Ложь;
		
	Иначе
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции
