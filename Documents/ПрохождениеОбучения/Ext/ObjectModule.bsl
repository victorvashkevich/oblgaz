﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	Организация,
	|   Дата, 
	| 	Ссылка 
	|ИЗ 
	|	Документ." + Метаданные().Имя + "
	|ГДЕ 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Кандидаты" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса. В запросе данные документа дополняются значениями
//  проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоОбучающиесяРаботники(Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	// угловыми скобками выделены изменяющиеся фрагменты текста запроса
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.НомерСтроки КАК НомерСтроки,
	|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрокаНомер,
	|	Док.Сотрудник,
	|	Док.ДатаЗавершения,
	|	Док.ТипОбучения,
	|	Док.ДатаНачала,
	|	Док.ЗаГраницей,
	|	Док.УчебноеЗаведение
	|ИЗ
	|	Документ.ПрохождениеОбучения.ОбучающиесяРаботники КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПрохождениеОбучения.ОбучающиесяРаботники КАК ПересекающиесяСтроки
	|		ПО Док.Ссылка = ПересекающиесяСтроки.Ссылка
	|			И Док.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
	|			И Док.Сотрудник = ПересекающиесяСтроки.Сотрудник
	|			И Док.ДатаЗавершения = ПересекающиесяСтроки.ДатаЗавершения
	|			И Док.ТипОбучения = ПересекающиесяСтроки.ТипОбучения
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Док.НомерСтроки,
	|	Док.Сотрудник,
	|	Док.ДатаЗавершения,
	|	Док.ТипОбучения,
	|	Док.ДатаНачала,
	|	Док.ЗаГраницей,
	|	Док.УчебноеЗаведение";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоКандидаты()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация!", Отказ, Заголовок);
	КонецЕсли;

	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Кандидаты" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по кандидатам, 
//  Отказ 						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиКандидата(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Обучающиеся работники"": ";
	
	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран работник!", Отказ, Заголовок);
	КонецЕсли;

	 //Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		СтрокаСообщениеОбОшибке = "Работник не может быть указан в документе дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;	
	//	
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиКандидата()

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров сведений 
//                                           по которым надо проводить документ
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	
	СтруктураПроведенияПоРегистрамСведений.Вставить("ОбучениеИПереподготовка");
	

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ОбучениеИПереподготовка";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период						= ВыборкаПоСтрокамДокумента.ДатаЗавершения;
		
		// Измерения
		Движение.Сотрудник					= ВыборкаПоСтрокамДокумента.Сотрудник;
        Движение.ТипОбучения				= ВыборкаПоСтрокамДокумента.ТипОбучения;
			
		// Реквизиты
		
		Движение.ДатаНачала		            = ВыборкаПоСтрокамДокумента.ДатаНачала;
		Движение.ЗаГраницей		            = ВыборкаПоСтрокамДокумента.ЗаГраницей;
		Движение.УчебноеЗаведение		    = ВыборкаПоСтрокамДокумента.УчебноеЗаведение;
	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
  
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);
				
			// получим реквизиты табличной части
			РезультатЗапросаПоКандидаты = СформироватьЗапросПоОбучающиесяРаботники(Режим);
			ВыборкаПоКандидаты = РезультатЗапросаПоКандидаты.Выбрать();

			Пока ВыборкаПоКандидаты.Следующий() Цикл 

					// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиКандидата(ВыборкаПоШапкеДокумента, ВыборкаПоКандидаты, Отказ, Заголовок);

				Если НЕ Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоКандидаты, СтруктураПроведенияПоРегистрамСведений);
					
				КонецЕсли;
					
			КонецЦикла;
				
							
		КонецЕсли; // Проводка результатов обучения
			
	КонецЕсли; 

	

КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(ОбучающиесяРаботники, , "Физлицо");
	
КонецПроцедуры
