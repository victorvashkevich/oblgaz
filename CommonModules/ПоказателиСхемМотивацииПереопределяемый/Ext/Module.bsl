﻿////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

Функция ДопустимыйТипПоказателя(ТипПоказателя) Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаПроцентная);
	Массив.Добавить(Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаЧисловая);
	
	Если Массив.Найти(ТипПоказателя) <> Неопределено Тогда
		Возврат Истина;	
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

Процедура ВыполнитьДополнительныеПроверки(Отказ, ЭтаФорма) Экспорт
	
	// В этой конфигурации дополнительных проверок не предусмотрено

КонецПроцедуры

Процедура ДополнитьСписокВозможностейИзменения(СписокВозможностейИзменения, ЭтаФорма) Экспорт
	
	Если ЭтаФорма.ВидПоказателя <> Перечисления.ВидыПоказателейСхемМотивации.ДляВсехОрганизаций Тогда
		СписокВозможностейИзменения.Добавить(Перечисления.ИзменениеПоказателейСхемМотивации.Ежемесячно);
	ИначеЕсли ЭтаФорма.ВозможностьИзменения <> Перечисления.ИзменениеПоказателейСхемМотивации.Периодически Тогда
		ЭтаФорма.ВозможностьИзменения = Перечисления.ИзменениеПоказателейСхемМотивации.Периодически;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет таблицу идентификаторов показателей схем мотивации
//
Процедура ЗаполнитьТаблицуПоказателей(ВидПВР, Переменные, ГенераторСлучайныхЧисел) Экспорт
	

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПоказателиСхемМотивации.Идентификатор КАК Идентификатор
	|ИЗ
	|	Справочник.ПоказателиСхемМотивации КАК ПоказателиСхемМотивации");
	Если ВидПВР = "ПлановыеУдержанияРаботниковОрганизаций" Или ВидПВР = "ПлановыеУдержанияРаботников" Или ВидПВР = "ПлановыеДополнительныеНачисленияРаботниковОрганизаций" Тогда
		Запрос.Текст = Запрос.Текст + "
		|ГДЕ Не ПоказателиСхемМотивации.Ссылка В (&ПарамПоказатели)";
		СписокПоказателей = Новый Массив;
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.ВремяВДнях);
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.ВремяВЧасах);
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.НормаВремениВДнях);
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.НормаВремениВЧасах);
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.СдельнаяВыработка);
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.ОтработаноВремениВДнях);
		СписокПоказателей.Добавить(Справочники.ПоказателиСхемМотивации.ОтработаноВремениВЧасах);
		
		Запрос.УстановитьПараметр("ПарамПоказатели", СписокПоказателей);
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПоказателиСхемМотивации.Идентификатор";
	Выборка = Запрос.Выполнить().Выбрать();
	СтрокВКолонке = Цел(Выборка.Количество()/3);
	Если СтрокВКолонке < Выборка.Количество()/3 Тогда
		СтрокВКолонке = СтрокВКолонке + 1;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		Идентификатор = Выборка.Идентификатор;
		
		Если ЗначениеЗаполнено(Идентификатор) Тогда
			Переменные.Вставить(Идентификатор,Окр(ГенераторСлучайныхЧисел.СлучайноеЧисло() /5189459139, 10));
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры //ЗаполнитьТаблицуПоказателей

Процедура ОбновитьФормулыПВРсПоказателямиШкала(Ссылка) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОсновныеНачисленияОрганизацийПоказатели.Ссылка
	|ИЗ
	|	ПланВидовРасчета.ОсновныеНачисленияОрганизаций.Показатели КАК ОсновныеНачисленияОрганизацийПоказатели
	|ГДЕ
	|	ОсновныеНачисленияОрганизацийПоказатели.Показатель = &Показатель
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ДополнительныеНачисленияОрганизацийПоказатели.Ссылка
	|ИЗ
	|	ПланВидовРасчета.ДополнительныеНачисленияОрганизаций.Показатели КАК ДополнительныеНачисленияОрганизацийПоказатели
	|ГДЕ
	|	ДополнительныеНачисленияОрганизацийПоказатели.Показатель = &Показатель
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	УдержанияОрганизацийПоказатели.Ссылка
	|ИЗ
	|	ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК УдержанияОрганизацийПоказатели
	|ГДЕ
	|	УдержанияОрганизацийПоказатели.Показатель = &Показатель";
	
	Запрос.УстановитьПараметр("Показатель", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	Если ТипЗнч(ОбработкаКомментариев) = Тип("ОбработкаОбъект.СообщенияВыполняемыхДействий") Тогда
		ОбработкаКомментариев.УдалитьСообщения();
	КонецЕсли;
	
	МассивРазделителей = ПроведениеРасчетов.ПолучитьМассивРазделителей();
	
	ОператорыИФункции				=  ".,+,-,/,*,ЦЕЛ,INT,ОКР,ROUND,МАКС,MAX,МИН,MIN,?,=,<,>,<=,>=,ОЦЕНИТЬПО,(,),И,ИЛИ,НЕ,OR,AND,NOT";
	ОператорыИФункцииОднойСтрокой	=  ".,+,-,/,*,?,=,<,>,(,)";
	
	Переменные = Новый Соответствие;
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел(546819);

	Пока Выборка.Следующий() Цикл
		
		ПВР = Выборка.Ссылка.ПолучитьОбъект();
		
		Показатели = ПВР.Показатели;
		
		ФормулаРасчетаДляФормулы = ПроведениеРасчетов.ПолучитьHTLMКодФормулыРасчета(ПВР.ФормулаРасчетаПредставление, Показатели, "Текст", Истина);
		
		ПоказателиСхемМотивацииПереопределяемый.ЗаполнитьТаблицуПоказателей(ПВР, Переменные, ГенераторСлучайныхЧисел);
		
		ФормулаРасчетаДляФормулы = ПроведениеРасчетов.ПолучитьHTLMКодФормулыРасчета(ФормулаРасчетаДляФормулы, Показатели, "Текст", Истина);
		
		СЗПоказатели = Новый СписокЗначений;
		Для Каждого Показатель Из Показатели Цикл
			СЗПоказатели.Добавить(Показатель.Показатель);
		КонецЦикла;

		Если Не ПроведениеРасчетов.ПроверкаИФормированиеФормулыРасчета(Ложь, СЗПоказатели, МассивРазделителей, ОператорыИФункцииОднойСтрокой, ОператорыИФункции, Переменные, ОбработкаКомментариев, ФормулаРасчетаДляФормулы, ПВР.ФормулаРасчета, ПВР.ФормулаРасчетаПредставление) Тогда
			ПВР.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПервоеПодразделение(Подразделение, Организация, НазваниеОрганизации, ОтображенныеОрганизации) Экспорт
	
	Если ОтображенныеОрганизации[Организация] <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПодразделенияОрганизаций.Ссылка,
	|	ПодразделенияОрганизаций.Владелец.Наименование КАК НазваниеОрганизации
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	ПодразделенияОрганизаций.Владелец = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПодразделенияОрганизаций.Наименование ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	НазваниеОрганизации = Выборка.НазваниеОрганизации;
	
	Возврат Выборка.Ссылка = Подразделение;

КонецФункции //ПервоеПодразделение

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура УстановитьЗаголовкиВФорме(ЭтаФорма) Экспорт
	
	ЭтаФорма.Заголовок = "Показатели схем мотивации";
	
КонецПроцедуры

#КонецЕсли