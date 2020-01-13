﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

//vvv
перем мУчебноеЗаведение, мКурсОбучения;
//
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
	|	КурсОбучения,
	//vvv
	|	УчебноеЗаведение,
	|	Организация,
	|	ДатаЗавершенияКурса,
	|	ДатаНачалаКурса,
	|	ДлительностьКурса,
	|	ТипКурса,
	//
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
	|	Док.ФизЛицо,
	|	Док.НомерСтроки КАК НомерСтроки,
	|	Док.ДатаПолученияДокумента,
	|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрокаНомер,
	|	Док.РеквизитыДокумента
	|ИЗ
	|	Документ.ПрохождениеКурсаОбучения.ОбучающиесяРаботники КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПрохождениеКурсаОбучения.ОбучающиесяРаботники КАК ПересекающиесяСтроки
	|		ПО Док.Ссылка = ПересекающиесяСтроки.Ссылка
	|			И Док.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
	|			И Док.Сотрудник.Физлицо = ПересекающиесяСтроки.Сотрудник.Физлицо
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Док.НомерСтроки,
	|	Док.ФизЛицо,
	|	Док.ДатаПолученияДокумента,
	|	Док.РеквизитыДокумента";
	
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
	
	// Заполнение Курса
	Если НЕ ЗначениеЗаполнено(КурсОбучения) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не выбран курс обучения! Выбирете курс обучения.", Отказ, Заголовок);
	КонецЕсли;

    Если ФактЗавершенияКурса И НЕ ЗначениеЗаполнено(ДатаЗавершенияКурса) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Установлен флаг завершения курса, но дата завершения курса не выбрана!", Отказ, Заголовок);
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
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран работник!", Отказ, Заголовок);
	КонецЕсли;

	// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		СтрокаСообщениеОбОшибке = "Работник не может быть указан в документе дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;	
		
		
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
	
	СтруктураПроведенияПоРегистрамСведений.Вставить("ПройденныеУчебныеКурсы");
	

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

// Создает и заполняет структуру, содержащую имена регистров накопления
// документа. В дальнейшем движения заносятся только по тем регистрам накопления, для которых в 
// данной процедуре заданы ключи
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамНакопления)

	СтруктураПроведенияПоРегистрамНакопления = Новый Структура();
	СтруктураПроведенияПоРегистрамНакопления.Вставить("ПотребностиВОбучении");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления

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
	ИмяРегистра = "ПройденныеУчебныеКурсы";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		//vvv комментируем, переписываем, чтобы была возможность вносить изменения вручную
		//Движение = Движения[ИмяРегистра].Добавить();

		//// Свойства
		//Движение.Период						= ДатаЗавершенияКурса;
		//
		//// Измерения
		//Движение.Физлицо					= ВыборкаПоСтрокамДокумента.ФизЛицо;

		//// Ресурсы
		//Движение.КурсОбучения				= КурсОбучения;
		//	
		//// Реквизиты
		//
		//Если ЗначениеЗаполнено(КурсОбучения.ВидДокументаОбОбразовании) 
		//   И ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаПолученияДокумента) Тогда
		//		
		//	Движение.ДокументОбОбразовании	= КурсОбучения.ВидДокументаОбОбразовании;
		//	Движение.НомерДокумента			= ВыборкаПоСтрокамДокумента.РеквизитыДокумента;
		//	Движение.ДатаДокумента			= ВыборкаПоСтрокамДокумента.ДатаПолученияДокумента;
		//
		//КонецЕсли;
		
		НаборПройденныхКурсов = РегистрыСведений.ПройденныеУчебныеКурсы.СоздатьНаборЗаписей();
		НаборПройденныхКурсов.Отбор.УчебноеЗаведение.Установить(ВыборкаПоШапкеДокумента.УчебноеЗаведение);
		НаборПройденныхКурсов.Отбор.КурсОбучения.Установить(ВыборкаПоШапкеДокумента.КурсОбучения);
		НаборПройденныхКурсов.Отбор.ФизЛицо.Установить(ВыборкаПоСтрокамДокумента.ФизЛицо);
		НаборПройденныхКурсов.Отбор.Период.Установить(ВыборкаПоШапкеДокумента.ДатаЗавершенияКурса);
		
		НаборПройденныхКурсов.Прочитать();
			
		ЗаписьПройденногоКурса = НаборПройденныхКурсов.Добавить();
		ЗаписьПройденногоКурса.УчебноеЗаведение = ВыборкаПоШапкеДокумента.УчебноеЗаведение;
		ЗаписьПройденногоКурса.КурсОбучения = ВыборкаПоШапкеДокумента.КурсОбучения;
		ЗаписьПройденногоКурса.ФизЛицо = ВыборкаПоСтрокамДокумента.ФизЛицо;
		ЗаписьПройденногоКурса.Период = ВыборкаПоШапкеДокумента.ДатаЗавершенияКурса;
		ЗаписьПройденногоКурса.Документ = Ссылка;
		ЗаписьПройденногоКурса.ДлительностьКурса = ВыборкаПоШапкеДокумента.ДлительностьКурса;
		ЗаписьПройденногоКурса.ДатаНачала = ВыборкаПоШапкеДокумента.ДатаНачалаКурса;
		ЗаписьПройденногоКурса.ТипКурса = ВыборкаПоШапкеДокумента.ТипКурса;
		ЗаписьПройденногоКурса.Организация = ВыборкаПоШапкеДокумента.Организация;
		
		Если ЗначениеЗаполнено(КурсОбучения.ВидДокументаОбОбразовании) 
		   И ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаПолученияДокумента) Тогда
				
			ЗаписьПройденногоКурса.ДокументОбОбразовании	= ВыборкаПоШапкеДокумента.КурсОбучения.ВидДокументаОбОбразовании;
			ЗаписьПройденногоКурса.НомерДокумента			= ВыборкаПоСтрокамДокумента.РеквизитыДокумента;
			ЗаписьПройденногоКурса.ДатаДокумента			= ВыборкаПоСтрокамДокумента.ДатаПолученияДокумента;
		
		КонецЕсли;
		
		НаборПройденныхКурсов.Записать();
		//

			
	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                  - выборка из результата запроса по шапке документа
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//  СтруктураПараметров                      - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокам, 
	СтруктураПроведенияПоРегистрамНакопления, СтруктураПараметров = "")
	
	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ПотребностиВОбучении";
	Если СтруктураПроведенияПоРегистрамНакопления.Свойство(ИмяРегистра) Тогда
		
		Движение = Движения[ИмяРегистра].Добавить();
		
		Движение.Период = ДатаЗавершенияКурса;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		
		// Измерения
		Движение.КурсОбучения = ВыборкаПоСтрокам.КурсОбучения;
		Движение.ДокументПланирования = ВыборкаПоСтрокам.ДокументПланирования;
		
		// Ресурсы
		Движение.КоличествоРаботников = СтруктураПараметров.КоличествоРаботников;
		
		// Ревизиты
	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамНакопления

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
    Перем СтруктураПроведенияПоРегистрамНакопления;
	
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
			ЗаполнитьСтруктуруПроведенияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамНакопления);
		
			// Учтем факт прохождения обучения.
			Если ФактЗавершенияКурса Тогда

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
				
				НадоСписать = ОбучающиесяРаботники.Количество();
				Если НЕ Отказ и НадоСписать > 0 Тогда
					
					СтруктураПараметров = Новый Структура("КоличествоРаботников");
					Запрос = Новый Запрос;
					Запрос.УстановитьПараметр("КурсОбучения",КурсОбучения);
					Запрос.УстановитьПараметр("Дата",КонецДня(ДатаЗавершенияКурса));
					
					Запрос.Текст = 
					"ВЫБРАТЬ
					|	ПотребностиВОбученииОстатки.КоличествоРаботниковОстаток,
					|	ПотребностиВОбученииОстатки.ДокументПланирования КАК ДокументПланирования,
					|	ПотребностиВОбученииОстатки.КурсОбучения
					|ИЗ
					|	РегистрНакопления.ПотребностиВОбучении.Остатки(&Дата, КурсОбучения = &КурсОбучения) КАК ПотребностиВОбученииОстатки
					|
					|УПОРЯДОЧИТЬ ПО
					|	ПотребностиВОбученииОстатки.ДокументПланирования.Дата";
					
					Выборка = Запрос.Выполнить().Выбрать();
					
					Пока Выборка.Следующий() И НадоСписать > 0 Цикл
						
						СтруктураПараметров.КоличествоРаботников = Мин(Выборка.КоличествоРаботниковОстаток,НадоСписать);
						НадоСписать = НадоСписать - СтруктураПараметров.КоличествоРаботников;
						ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, Выборка,СтруктураПроведенияПоРегистрамНакопления,СтруктураПараметров);
						
					КонецЦикла;
				КонецЕсли;
				
			КонецЕсли; // Проводка результатов обучения
			
		КонецЕсли; 

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	
			
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаявкаНаОбучение") Тогда
		// Заполним реквизиты из стандартного набора.
		ОбщегоНазначения.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		Если Основание.Проведен Тогда
			// Заполнение шапки
			ДатаЗавершенияКурса = Основание.ДатаЗавершенияКурса;
			КурсОбучения = Основание.КурсОбучения;
			// Заполнение табличной части. 
			Для Каждого ТекСтрокаОбучающиесяРаботники Из Основание.ОбучающиесяРаботники Цикл
				ЗаполнитьЗначенияСвойств(ОбучающиесяРаботники.Добавить(), ТекСтрокаОбучающиесяРаботники);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//vvv
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Проведен Тогда
		
		ОбъектВБазе = Ссылка.ПолучитьОбъект();
		мУчебноеЗаведение = ОбъектВБазе.УчебноеЗаведение;
		мКурсОбучения = ОбъектВБазе.КурсОбучения;
		ОбработкаУдаленияПроведения(Ложь);
		
	КонецЕсли;
	//
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(ОбучающиесяРаботники, , "Физлицо");
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	НаборПройденныхКурсов = РегистрыСведений.ПройденныеУчебныеКурсы.СоздатьНаборЗаписей();

	НаборПройденныхКурсов.Отбор.УчебноеЗаведение.Установить(мУчебноеЗаведение);
	НаборПройденныхКурсов.Отбор.КурсОбучения.Установить(мКурсОбучения);
	НаборПройденныхКурсов.Прочитать();
	НомерЗаписиНабора = НаборПройденныхКурсов.Количество() - 1;
	Пока НомерЗаписиНабора >= 0 Цикл
		Если НаборПройденныхКурсов[НомерЗаписиНабора].Документ = Ссылка Тогда
			НаборПройденныхКурсов.Удалить(НомерЗаписиНабора);
		КонецЕсли;
		НомерЗаписиНабора = НомерЗаписиНабора - 1
	КонецЦикла;

	НаборПройденныхКурсов.Записать();
	
	ТекстПодтверждения = "";

	
КонецПроцедуры
