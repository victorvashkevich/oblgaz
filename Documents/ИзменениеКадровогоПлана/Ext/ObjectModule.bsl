﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Заполняет табличную часть документа "РабочиеМеста" по текущему состоянию работающих
//
Процедура ЗаполнитьТабличнуюЧастьРабочиеМестаПоТекущемуСостоянию() Экспорт

	РабочиеМеста.Очистить();
	
	МассивДолжностейСОшибками = Новый Массив;
	
	Выборка = ИзменениеКадровогоПланаПереопределяемый.СформироватьЗапросПоТекущемуСостоянию(ЭтотОбъект).Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДолжностьЗаполнена Тогда
			ЗаполнитьЗначенияСвойств(РабочиеМеста.Добавить(), Выборка);
		Иначе
			Если МассивДолжностейСОшибками.Найти(Выборка.ДолжностьОрганизации) = Неопределено Тогда
				МассивДолжностейСОшибками.Добавить(Выборка.ДолжностьОрганизации);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДолжностейСОшибками.Количество() > 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Для следующих должностей не указана должность для набора персонала! Рабочие места по этим должностям не могут быть заполнены:");
	КонецЕсли;
	Для Каждого ТекущийЭлемент Из МассивДолжностейСОшибками Цикл
		ОбщегоНазначения.СообщитьОбОшибке(ТекущийЭлемент);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет табличную часть документа "РабочиеМеста" по расхождению между 
// кадровым планом и фактическому состоянию работающих
//
Процедура ЗаполнитьТабличнуюЧастьРабочиеМестаПоРасхождениям() Экспорт

	РабочиеМеста.Загрузить(ИзменениеКадровогоПланаПереопределяемый.СформироватьЗапросПоРасхождениям(ЭтотОбъект).Выгрузить());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)
	
	// ДатаИзменений
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаИзменений) Тогда
		ОбщегоНазначения.ВывестиИнформациюОбОшибке("Не указана дата изменений!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Штатные единицы" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса по строке ТЧ, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРабочегоМеста(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Рабочие места"": ";

	Если ВыборкаПоСтрокамДокумента.ВидСтрокиЗапроса = "РабочиеМеста" Тогда
		
		// Подразделение
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Подразделение) Тогда
			ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрано подразделение!", Отказ, Заголовок);
		КонецЕсли;
		
		// Должность
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Должность) Тогда
			ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана должность!", Отказ, Заголовок);
		КонецЕсли;
		
		ИзменениеКадровогоПланаПереопределяемый.ПроверитьЗначенияРеквизитов(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, СтрокаНачалаСообщенияОбОшибке);
			
		Если Отказ Тогда
			ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке, Отказ, Заголовок);
		КонецЕсли;
	
	Иначе // "КонфликтныйДокумент"

		// противоречие другим документам "Изменение кадрового плана"
		Расшифровки = Новый Массив;
		Расшифровки.Добавить(Новый Структура("Представление, Расшифровка", ВыборкаПоСтрокамДокумента.КонфликтныйДокумент, ВыборкаПоСтрокамДокумента.КонфликтныйДокумент));
		СтрокаСообщениеОбОшибке = "дата изменения документа противоречит документу ";
		ОбщегоНазначения.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок, , Расшифровки);

	КонецЕсли
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРабочегоМеста()

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
Процедура ДобавитьСтрокуВШтатноеРасписание(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, СтруктураПараметров = "")

	Движение = Движения.КадровыйПлан.Добавить();
	
	// Свойства
	Движение.Период							= ВыборкаПоШапкеДокумента.ДатаИзменений;
	
	// Измерения
	Движение.Должность						= ВыборкаПоСтрокамДокумента.Должность;
	
	// Ресурсы
	Движение.Количество						= ВыборкаПоСтрокамДокумента.Количество;
	
	ИзменениеКадровогоПланаПереопределяемый.ДополнитьДвижение(Движение, ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента);
	
КонецПроцедуры // ДобавитьСтрокуВШтатноеРасписание

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	РезультатЗапросаПоШапке = ИзменениеКадровогоПланаПереопределяемый.СформироватьЗапросПоШапке(Режим, Ссылка);
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда

			РезультатЗапросаПоРабочиеМеста = ИзменениеКадровогоПланаПереопределяемый.СформироватьЗапросПоРабочиеМеста(ВыборкаПоШапкеДокумента, Режим, Ссылка);

			// В циклах по строкам табличных частей будем добавлять информацию в движения регистров
			ВыборкаПоРабочиеМеста = РезультатЗапросаПоРабочиеМеста.Выбрать();
			Пока ВыборкаПоРабочиеМеста.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРабочегоМеста(ВыборкаПоШапкеДокумента, ВыборкаПоРабочиеМеста, Отказ, Заголовок);

				// Движения стоит записывать, если в проведении еще не отказано (отказ =ложь)
				Если Не Отказ Тогда
					ДобавитьСтрокуВШтатноеРасписание(ВыборкаПоШапкеДокумента, ВыборкаПоРабочиеМеста);
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
	
	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
