﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПРОВЕДЕНИЯ В СВЯЗАННЫЕ РЕГИСТРЫ

// Функция возвращает характер выплаты, соответствующий документу-регистратору
//
// Параметры:
//   ДокументСсылка - ДокументСсылка
//
Функция ХарактерВыплатыПоРегистратору(ДокументСсылка) Экспорт
	
	ХарактерВыплатыПоРегистратору = Новый Соответствие;
	ХарактерВыплатыПоРегистратору.Вставить(Тип("ДокументСсылка.НачислениеЗарплатыРаботникам"), Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
	ХарактерВыплатыПоРегистратору.Вставить(Тип("ДокументСсылка.ОтражениеВУчетеБухгалтерскихРасчетовСПерсоналом"), Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
	ХарактерВыплатыПоРегистратору.Вставить(Тип("ДокументСсылка.ПриходныйКассовыйОрдер"), Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
	
	ВзаиморасчетыСРаботникамиПереопределяемый.ДополнитьСоответствиеХарактерВыплатыПоРегистратору(ХарактерВыплатыПоРегистратору);
	
	Возврат ХарактерВыплатыПоРегистратору[ТипЗнч(ДокументСсылка)];
	
КонецФункции

Процедура СоздатьДвиженияПоЗарплатаЗаМесяц(Регистратор)
	
	ХарактерВыплатыПоРегистратору = ХарактерВыплатыПоРегистратору(Регистратор);
	
	НаборЗаписейЗарплатаЗаМесяц = РегистрыНакопления.ЗарплатаЗаМесяц.СоздатьНаборЗаписей();
	НаборЗаписейЗарплатаЗаМесяц.Отбор.Регистратор.Установить(Регистратор);
	
	НаборЗаписейЗарплатаЗаМесяц.Загрузить(Выгрузить());
	Для Каждого Запись Из НаборЗаписейЗарплатаЗаМесяц Цикл
		Если НЕ ЗначениеЗаполнено(Запись.ХарактерВыплаты) И ЗначениеЗаполнено(ХарактерВыплатыПоРегистратору) Тогда
			Запись.ХарактерВыплаты = ХарактерВыплатыПоРегистратору;
		КонецЕсли;
	КонецЦикла;	
	НаборЗаписейЗарплатаЗаМесяц.Записать();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;

	Регистратор = Отбор.Регистратор.Значение;
	Если Регистратор.Метаданные().Движения.Содержит(Метаданные.РегистрыНакопления.ЗарплатаЗаМесяц) Тогда
		СоздатьДвиженияПоЗарплатаЗаМесяц(Регистратор);	
	КонецЕсли;
	
КонецПроцедуры
