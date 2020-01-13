﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)
	Если ПустаяСтрока(Наименование) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено наименование свойства.", Отказ);
		Возврат;
	ИначеЕсли НазначениеСвойства.Пустая() Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указано назначение свойства.", Отказ);
		Возврат;
	КонецЕсли;

	Если НЕ ЭтоНовый() 
	   И НазначениеСвойства <> Ссылка.НазначениеСвойства 
	   И ЭтотОбъект.СуществуютСсылки() Тогда
	   
	    ОбщегоНазначения.СообщитьОбОшибке("Существуют объекты, которым назначено свойство """ + Наименование + """.
		         |Назначение свойства не может быть изменено, элемент не записан.", Отказ);
		Возврат;
	КонецЕсли;

	Если СуществуютПересечения() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

// Обработчик события ПередУдалением объекта.
//
Процедура ПередУдалением(Отказ)

	Если Предопределенный Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не допускается удаление предопределенных элементов!", Отказ);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, используется ли свойство для задания значений 
// или назначения каким-либо объектам.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина, если используется, Ложь, если нет.
//
Функция СуществуютСсылки() Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.НазначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.НазначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.НазначенияСвойствОбъектов.Свойство = &Свойство
	|";

	Запрос.УстановитьПараметр("Свойство", Ссылка);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции

// Функция проверяет, есть ли другие свойства с таким же наименованием
// и пересекающимся набором назначений свойств
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   Истина, если есть другие свойства, Ложь, если нет.
//
Функция СуществуютПересечения()
	НазначенияОбъекта = Новый Соответствие;
	Для Каждого Назначение Из НазначениеСвойства.ТипЗначения.Типы() Цикл
		НазначенияОбъекта.Вставить(Назначение, Истина);
	КонецЦикла;
	
	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СвойстваОбъектов.Код,
	|	СвойстваОбъектов.НазначениеСвойства
	|ИЗ
	|	ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
	|ГДЕ
	|	СвойстваОбъектов.Наименование = &Наименование
	|	И СвойстваОбъектов.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НазначениеСвойстваПроверяемого = Выборка.НазначениеСвойства;
		Если Не НазначениеСвойстваПроверяемого.Пустая() И ЗначениеЗаполнено(НазначениеСвойстваПроверяемого.ТипЗначения) Тогда
			Для Каждого Назначение Из НазначениеСвойстваПроверяемого.ТипЗначения.Типы() Цикл
				Если НазначенияОбъекта.Получить(Назначение) <> Неопределено Тогда
					СтрОшибки = "Уже существует свойство с наименованием " + Наименование + " (" + Выборка.Код + ") для '" + Назначение + "'. Свойства с одинаковыми наименованиями недопустимо задавать для одинаковых элементов!";
					ОбщегоНазначения.СообщитьОбОшибке(СтрОшибки);
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции // СуществуютПересечения()
