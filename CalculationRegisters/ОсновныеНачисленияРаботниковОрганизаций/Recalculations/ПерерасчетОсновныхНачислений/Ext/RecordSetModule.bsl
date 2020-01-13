﻿// Процедура - обработчик события "ПередЗаписью"

Процедура ПередЗаписью(Отказ, Замещение)
	// Очищаем набор если объект перерасчета - документ.Сторнирование.
	ТипЗначенияОтбора = ТипЗнч(Отбор.ОбъектПерерасчета.Значение);
	Если ТипЗначенияОтбора = Тип("ДокументСсылка.Сторнирование") 
		ИЛИ ТипЗначенияОтбора = Тип("ДокументСсылка.ТабельУчетаРабочегоВремениОрганизации") Тогда
		 Очистить();
	КонецЕсли;
КонецПроцедуры
