﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем глОбщиеЗначения Экспорт;

// Параметры внешних регламентированных отчетов.
Перем ПараметрыВнешнихРегламентированныхОтчетов Экспорт;

Перем КонтекстОнлайнСервисовРегламентированнойОтчетности Экспорт;
Перем ОбменСНалоговымиОрганами Экспорт;
Перем ИспользоватьВнешнююФормуСамообслуживанияСотрудников;

// ПодключаемоеОборудование
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
Перем глПоддерживаемыеТипыВО Экспорт;
// Конец ПодключаемоеОборудование

// СтандартныеПодсистемы

// СтандартныеПодсистемы.БазоваяФункциональность

// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт; 
// Признак того, что в данном сеансе не нужно повторно предлагать установку
Перем ПредлагатьУстановкуРасширенияРаботыСФайлами Экспорт;
// Признак того, что в данном сеансе не нужно запрашивать стандартное подтверждение при выходе
Перем ПропуститьПредупреждениеПередЗавершениемРаботыСистемы Экспорт;
// Структура параметров для клиентской логики по завершению работы в программе.
Перем ПараметрыРаботыКлиентаПриЗавершении Экспорт;
// Структура, содержащая в себе время начала и окончания обновления программы.
Перем ПараметрыРаботыКлиентаПриОбновлении Экспорт;

// Конец СтандартныеПодсистемы.БазоваяФункциональность

// Конец СтандартныеПодсистемы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередНачаломРаботыСистемы(Отказ)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы
	
	МодульУправляемогоПриложенияПереопределяемый.ПередНачаломРаботыСистемыДополнительно(Отказ, ИспользоватьВнешнююФормуСамообслуживанияСотрудников);
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПриНачалеРаботыСистемы(Истина);
	// Конец СтандартныеПодсистемы
	
	// отработка параметров запуска системы
	Если ОбработатьПараметрыЗапуска(ПараметрЗапуска) Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеСоединениямиИБКлиент.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();
	
	Если ИспользоватьВнешнююФормуСамообслуживанияСотрудников Тогда
		
		ОкнаКлиентскогоПриложения = ПолучитьОкна();
		ОсновноеОкно = Неопределено;
		Для Каждого ОкноПриложения Из ОкнаКлиентскогоПриложения Цикл
			Если ОкноПриложения.Основное Тогда
				ОсновноеОкно = ОкноПриложения;
			КонецЕсли;
		КонецЦикла;
		
		ОткрытьФорму("ВнешняяОбработка.ФормаСамообслуживанияСотрудников.Форма", , , , ОсновноеОкно);
		
	КонецЕсли;
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	Если МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		ОписаниеОшибки = "";
		
		Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу("Конфигурация", глПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
			ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:
										|""%ОписаниеОшибки%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПередЗавершениемРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу("Конфигурация", глПоддерживаемыеТипыВО);
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// ПодключаемоеОборудование
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные
	Если Источник = "СканерШтрихкода" И Событие = "ПолученШтрихкод" Тогда
		Если ЗаявкиКандидатовПереопределяемый.ЭтоQRКодКонтакта(ОписаниеСобытия) Тогда
			Результат = ЗаявкиКандидатовПереопределяемый.ОбработатьСобытиеОтСканераШтрихкода(ОписаниеСобытия, ОписаниеОшибки)
			
		ИначеЕсли НачислениеПоБольничномуЛистуСервис.ЭтоДвумерныйШтрихкодБольничного(ОписаниеСобытия) Тогда
			Результат = НачислениеПоБольничномуЛистуСервис.ОбработатьСобытиеОтСканераШтрихкода(ОписаниеСобытия, ОписаниеОшибки)
			
		Иначе
			ОписаниеОшибки	= НСтр("ru = 'Данная конфигурация умеет обрабатывать только двумерный штрихкод, находящийся в левом верхнем углу листка нетрудоспособности!'");
			Результат		= Ложь;
			
		КонецЕсли;
		
	Иначе
		Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
		
	КонецЕсли;
	
	// Проверить результат
	Если Не Результат Тогда
		ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
		ОбработкаКомментариев.УдалитьСообщения();
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОписаниеОшибки, , НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'"));
		ОбработкаКомментариев.ПоказатьСообщения();
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

// Функция возвращает значение экспортных переменных модуля приложенийа
//
// Параметры
//  Имя - строка, содержит имя переменной целиком 
//
// Возвращаемое значение:
//   значение соответствующей экспортной переменной
Функция глЗначениеПеременной(Имя) Экспорт

	Возврат ОбщегоНазначенияЗК.ПолучитьЗначениеПеременной(Имя, глОбщиеЗначения);
	
КонецФункции

// Процедура установки значения экспортных переменных модуля приложения
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
// 	Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	ОбщегоНазначенияЗК.УстановитьЗначениеПеременной(Имя, глОбщиеЗначения, Значение, ОбновлятьВоВсехКэшах);
	
КонецПроцедуры

Функция ОпределитьЭтаИнформационнаяБазаФайловая(СтрокаСоединенияСБД = "") Экспорт
			
	СтрокаСоединенияСБД = ?(ПустаяСтрока(СтрокаСоединенияСБД), СтрокаСоединенияИнформационнойБазы(), СтрокаСоединенияСБД);
	
	// в зависимости от того файловый это вариант БД или нет немного по-разному путь в БД формируется
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");
	
	Возврат ПозицияПоиска = 1;	
	
КонецФункции

// Обработать параметр запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ПараметрЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//								с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(Знач ПараметрЗапуска)

	// есть ли параметры запуска
	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Параметр может состоять из частей, разделенных символом ";".
	// Первая часть - главное значение параметра запуска. 
	// Наличие дополнительных частей определяется логикой обработки главного параметра.
	ПараметрыЗапуска = ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска,";");
	ЗначениеПараметраЗапуска = Врег(ПараметрыЗапуска[0]);
	
	Результат = ОбъектыПереносаДанныхКлиент.ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска);
	
	Возврат Результат;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

// ПодключаемоеОборудование
глПоддерживаемыеТипыВО = Новый Массив;
глПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
// Конец ПодключаемоеОборудование