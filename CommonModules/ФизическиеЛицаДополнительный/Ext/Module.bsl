﻿
Функция УпоминанияФизическогоЛица(Физлицо)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиОрганизаций.Ссылка,
	|	1 КАК ТипСсылки,
	|	ВЫБОР
	|		КОГДА СотрудникиОрганизаций.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизлицами.ТрудовойДоговор)
	|			ТОГДА СотрудникиОрганизаций.ВидЗанятости
	|		ИНАЧЕ СотрудникиОрганизаций.ВидДоговора
	|	КОНЕЦ КАК ВидОтношений,
	|	СотрудникиОрганизаций.Организация,
	|	СотрудникиОрганизаций.ТекущееПодразделениеОрганизации КАК Подразделение,
	|	СотрудникиОрганизаций.ТекущаяДолжностьОрганизации КАК Должность,
	|	СотрудникиОрганизаций.ДатаПриемаНаРаботу КАК ДатаНачала,
	|	СотрудникиОрганизаций.ДатаУвольнения КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА СотрудникиОрганизаций.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизлицами.ТрудовойДоговор)
	|			ТОГДА ВЫБОР
	|					КОГДА СотрудникиОрганизаций.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)
	|						ТОГДА 1
	|					ИНАЧЕ 2
	|				КОНЕЦ
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо = &Физлицо
	|";
	
	Если ПравоДоступа("Просмотр", Метаданные.Справочники.ЗаявкиКандидатов) Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаявкиКандидатов.Ссылка,
		|	2,
		|	ЗаявкиКандидатов.Вакансия,
		|	ЗаявкиКандидатов.Организация,
		|	ЗаявкиКандидатов.Подразделение,
		|	ЗаявкиКандидатов.Должность,
		|	ЗаявкиКандидатов.ДатаОткрытия,
		|	ДАТАВРЕМЯ(1, 1, 1),
		|	1
		|ИЗ
		|	Справочник.ЗаявкиКандидатов КАК ЗаявкиКандидатов
		|ГДЕ
		|	ЗаявкиКандидатов.ФизЛицо = &Физлицо
		|	И ЗаявкиКандидатов.ФизЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипСсылки,
	|	Порядок,
	|	ДатаНачала УБЫВ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Физлицо", Физлицо);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // УпоминанияФизическогоЛица

Функция ПредставлениеМестаРаботы(МестоРаботы)
	
	Представление = Строка(МестоРаботы.ВидОтношений);
	
	Если ЗначениеЗаполнено(МестоРаботы.Организация) Тогда
		Представление = Представление + " в " + Строка(МестоРаботы.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоРаботы.Подразделение) Тогда
		Представление = Представление + " (" + МестоРаботы.Подразделение;
		Если ЗначениеЗаполнено(МестоРаботы.Должность) Тогда
			Представление = Представление + ", " + МестоРаботы.Должность;
		КонецЕсли;
		Представление = Представление + ")";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоРаботы.ДатаНачала) Тогда
		Представление = Представление + " с " + Формат(МестоРаботы.ДатаНачала, "ДФ=dd.MM.yyyy");
		Если ЗначениеЗаполнено(МестоРаботы.ДатаОкончания) Тогда
			Представление = Представление + " по " + Формат(МестоРаботы.ДатаОкончания, "ДФ=dd.MM.yyyy") + " (уволен)";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции // ПредставлениеМестаРаботы

Функция ПредставлениеКандидата(Кандидат)
	
	Представление = Строка(Кандидат.ВидОтношений);
	
	Если ЗначениеЗаполнено(Кандидат.Организация) Тогда
		Представление = Представление + " в " + Строка(Кандидат.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Кандидат.Подразделение) Тогда
		Представление = Представление + " (" + Кандидат.Подразделение;
		Если ЗначениеЗаполнено(Кандидат.Должность) Тогда
			Представление = Представление + ", " + Кандидат.Должность;
		КонецЕсли;
		Представление = Представление + ")";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Кандидат.ДатаНачала) Тогда
		Представление = Представление + " от " + Формат(Кандидат.ДатаНачала, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции // ПредставлениеМестаРаботы

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
Процедура СоздатьНовогоСотрудникаПоФизическомуЛицу(Физлицо, ПараметрыЗаполнения = Неопределено) Экспорт
	
	// проверим какую форму надо использовать
	ИспользоватьПомощника = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ИспользоватьПомощникаПриемаНаРаботу");
	Если ИспользоватьПомощника Тогда
		Форма = Справочники.СотрудникиОрганизаций.ПолучитьФормуНовогоЭлемента("ФормаПомощник", , Физлицо);
		Отказ = истина;
	Иначе
		Форма = Справочники.СотрудникиОрганизаций.ПолучитьФормуНовогоЭлемента( , , Физлицо);
	КонецЕсли;
	
	Форма.ПараметрыОткрытия = Новый Структура("Физлицо", Физлицо);
	
	Если ПараметрыЗаполнения <> Неопределено Тогда
		ПараметрыОткрытия = Форма.ПараметрыОткрытия;
		Для каждого ПараметрЗаполнения Из ПараметрыЗаполнения Цикл
			ПараметрыОткрытия.Вставить(ПараметрЗаполнения.Ключ, ПараметрЗаполнения.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если Форма.Открыта() Тогда
		// просто активизируем уже открытую форму
		Форма.Активизировать();
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьПомощника Тогда
		Форма.СоздатьДокумент = Истина;
	КонецЕсли;
	
	Форма.Открыть();
	
КонецПроцедуры // СоздатьНовогоСотрудникаПоФизическомуЛицу

Функция ДобавитьГиперссылку(Верх, ДополнительныеДействия, ЭлементыФормы, Панель)
	
	Гиперссылка = ЭлементыФормы.Добавить(Тип("Надпись"), РаботаСДиалогамиКлиент.УникальноеИмяЭлементаФормы(), Истина, Панель);
	Гиперссылка.Гиперссылка = Истина;
	Гиперссылка.ЦветТекста = ЦветаСтиля.ЦветГиперссылки;
	Гиперссылка.УстановитьДействие("Нажатие", ДополнительныеДействия);
	Гиперссылка.Лево 	= 6;
	Гиперссылка.Верх	= Верх;
	Гиперссылка.Ширина	= Панель.Ширина;
	Гиперссылка.УстановитьПривязку(ГраницаЭлементаУправления.Право, Панель, ГраницаЭлементаУправления.Право);
	
	Возврат Гиперссылка;
	
КонецФункции // ДобавитьГиперссылку

Функция ДобавитьРамкуГруппы(Верх, Заголовок, ЭлементыФормы, Панель)
	
	Рамка = ЭлементыФормы.Добавить(Тип("РамкаГруппы"), РаботаСДиалогамиКлиент.УникальноеИмяЭлементаФормы(), Истина, Панель);
	Рамка.Заголовок = Заголовок;
	Рамка.Лево = 6;
	Рамка.Верх = Верх;
	Рамка.Ширина = Панель.Ширина;
	Рамка.Высота = 16;
	Рамка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Подчеркивание);
	Рамка.УстановитьПривязку(ГраницаЭлементаУправления.Право, Панель, ГраницаЭлементаУправления.Право);
	
	Возврат Рамка;
	
КонецФункции // ДобавитьРамкуГруппы

Процедура ДобавитьСтраницуСсылки(Форма)
	
	ЭлементыФормы = Форма.ЭлементыФормы;
	ОсновнаяПанель = Форма.ЭлементыФормы.ОсновнаяПанель;
	СтраницаСсылки = ОсновнаяПанель.Страницы.Добавить("Ссылки");
	
КонецПроцедуры // ДобавитьСтраницуСсылки

Функция НайтиГиперссылку(Форма, УпоминанияСсылки, Ссылка)
	
	Гиперссылка = Неопределено;
	
	Для Каждого КлючИЗначение Из УпоминанияСсылки Цикл
		Если КлючИЗначение.Значение = Ссылка Тогда 
			Гиперссылка = Форма.ЭлементыФормы.Найти(КлючИЗначение.Ключ);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Гиперссылка;
	
КонецФункции

Процедура ДобавитьГиперссылки(Форма, ДополнительныеДействия)
	
	Упоминания = УпоминанияФизическогоЛица(Форма.Ссылка);
	
	ЭлементыФормы = Форма.ЭлементыФормы;
	ОсновнаяПанель = ЭлементыФормы.ОсновнаяПанель;
	ОсновнаяПанель.ТекущаяСтраница = ОсновнаяПанель.Страницы["Ссылки"];
	
	МестаРаботы = Упоминания.НайтиСтроки(Новый Структура("ТипСсылки", 1));
	КандидатыНаРаботу = Упоминания.НайтиСтроки(Новый Структура("ТипСсылки", 2));
	
	// определяем максимальное количество гиперссылок на места работы
	МестаРаботыМаксКоличество = ?(КандидатыНаРаботу.Количество() > 0, 10, 14);
	КандидатыМаксКоличество = 3;
	
	Верх = 6;
	
	РамкаМестаРаботы = ДобавитьРамкуГруппы(Верх, "Места работы", ЭлементыФормы, ОсновнаяПанель);
	Верх = Верх + РамкаМестаРаботы.Высота + 6;
	
	УпоминанияСсылки = ?(Форма.УпоминанияФизическогоЛица = Неопределено, Новый Соответствие, Форма.УпоминанияФизическогоЛица);
	
	// добавляем гиперссылки на сотрудников
	Если МестаРаботы.Количество() > 0 Тогда
		МестаРаботыКоличество = 0;
		Для Каждого МестоРаботы Из МестаРаботы Цикл
			Гиперссылка = НайтиГиперссылку(Форма, УпоминанияСсылки, МестоРаботы.Ссылка);
			Если Гиперссылка = Неопределено Тогда
				Гиперссылка = ДобавитьГиперссылку(Верх, ДополнительныеДействия, ЭлементыФормы, ОсновнаяПанель);
				УпоминанияСсылки.Вставить(Гиперссылка.Имя, МестоРаботы.Ссылка);
			КонецЕсли;
			
			Гиперссылка.Заголовок = ПредставлениеМестаРаботы(МестоРаботы);
			Верх = Верх + Гиперссылка.Высота + 6;
			
			МестаРаботыКоличество = МестаРаботыКоличество + 1;
			Если МестаРаботыКоличество = МестаРаботыМаксКоличество Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		// пока нигде не работает
		Гиперссылка = ДобавитьГиперссылку(Верх, ДополнительныеДействия, ЭлементыФормы, ОсновнаяПанель);
		Гиперссылка.Заголовок = "Принять на работу";
		УпоминанияСсылки.Вставить(Гиперссылка.Имя, Справочники.СотрудникиОрганизаций.ПустаяСсылка());
	КонецЕсли;
	
	Верх = 254;
	
	// добавляем гиперссылки на кандидатов
	Если КандидатыНаРаботу.Количество() > 0 Тогда
		РамкаМестаРаботы = ДобавитьРамкуГруппы(Верх, "Заявки кандидата", ЭлементыФормы, ОсновнаяПанель);
		Верх = Верх + РамкаМестаРаботы.Высота + 6;
		КандидатыКоличество = 0;
		Для Каждого Кандидат Из КандидатыНаРаботу Цикл
			Гиперссылка = НайтиГиперссылку(Форма, УпоминанияСсылки, Кандидат.Ссылка);
			Если Гиперссылка = Неопределено Тогда
				Гиперссылка = ДобавитьГиперссылку(Верх, ДополнительныеДействия, ЭлементыФормы, ОсновнаяПанель);
				УпоминанияСсылки.Вставить(Гиперссылка.Имя, Кандидат.Ссылка);
			КонецЕсли;
			
			Гиперссылка.Заголовок = ПредставлениеКандидата(Кандидат);
			Верх = Верх + Гиперссылка.Высота + 6;
			
			КандидатыКоличество = КандидатыКоличество + 1;
			Если КандидатыКоличество = КандидатыМаксКоличество Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Форма.УпоминанияФизическогоЛица = УпоминанияСсылки;
	
КонецПроцедуры // ДобавитьГиперссылки

Процедура УдалитьКнопкиРедактированияДанных(ИменаКнопок, КоманднаяПанель)
	
	Кнопки = КоманднаяПанель.Кнопки;
	
	ИндексКнопки = 0;
	Пока ИндексКнопки < Кнопки.Количество() Цикл
		Кнопка = Кнопки[ИндексКнопки];
		Если Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Подменю Тогда
			УдалитьКнопкиРедактированияДанных(ИменаКнопок, Кнопка);
		КонецЕсли;
		Если ИменаКнопок.Найти(Кнопка.Имя) <> Неопределено Тогда
			Кнопки.Удалить(ИндексКнопки);
		Иначе
			ИндексКнопки = ИндексКнопки + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // УдалитьКнопкиРедактированияДанных
	
Процедура ФормаФизическогоЛицаПередОткрытием(Форма, ДополнительныеДействия) Экспорт
	
	ИспользоватьФормуФизическогоЛицаДляРедактирования = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ОбщегоНазначенияЗК.ПолучитьЗначениеПеременной("глТекущийПользователь"), "ИспользоватьФормуФизическогоЛицаДляРедактирования");
	
	Если Не ИспользоватьФормуФизическогоЛицаДляРедактирования Тогда
		
		ДобавитьСтраницуСсылки(Форма);
		
		ДобавитьГиперссылки(Форма, ДополнительныеДействия);
		
	КонецЕсли;
	
КонецПроцедуры // ФормаФизическогоЛицаПередОткрытием

Процедура ФормаФизическогоЛицаПриОткрытии(Форма) Экспорт
	
	ИспользоватьФормуФизическогоЛицаДляРедактирования = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ОбщегоНазначенияЗК.ПолучитьЗначениеПеременной("глТекущийПользователь"), "ИспользоватьФормуФизическогоЛицаДляРедактирования");
	
	Если Не ИспользоватьФормуФизическогоЛицаДляРедактирования Тогда
		// изменить внешний вид панели
		ОсновнаяПанель = Форма.ЭлементыФормы.ОсновнаяПанель;
		ОсновнаяПанель.ТекущаяСтраница		= ОсновнаяПанель.Страницы["Ссылки"];
		ОсновнаяПанель.ОтображениеЗакладок	= ОтображениеЗакладок.НеИспользовать;
		
		// удалить кнопки редактирования данных
		ИменаКнопок = Новый Массив;
		ИменаКнопок.Добавить("Труд");
		ИменаКнопок.Добавить("НДФЛ");
		ИменаКнопок.Добавить("ПерейтиАвансы");
		ИменаКнопок.Добавить("ПерейтиАвансыОрганизаций");
		ИменаКнопок.Добавить("ПерейтиЛицевыеСчета");
		УдалитьКнопкиРедактированияДанных(ИменаКнопок, Форма.ЭлементыФормы.ДействияФормы);
	КонецЕсли;
	
КонецПроцедуры // ФормаФизическогоЛицаПриОткрытии

Процедура ФормаФизическогоЛицаДополнительныеДействия(Элемент, Форма) Экспорт
	
	Упоминание = Форма.УпоминанияФизическогоЛица[Элемент.Имя];
	
	Если Упоминание <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(Упоминание) Тогда
			// создать сотрудника можно только если есть ссылка
			Если ОбщегоНазначенияЗКПереопределяемый.ДоступнаСсылкаВФормеОбъекта(Форма) Тогда
				// открыть помощник или форму нового сотрудника
				СоздатьНовогоСотрудникаПоФизическомуЛицу(Форма.Ссылка);
			КонецЕсли;
		Иначе
			ОткрытьЗначение(Упоминание);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьДополнительныеДействия

Процедура ФормаФизическогоЛицаОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма, ДополнительныеДействия) Экспорт
	
	Если (ИмяСобытия = "ЗаписанСотрудник" Или ИмяСобытия = "ЗаписанаЗаявкаКандидата") 
		И Параметр.Свойство("Физлицо") И Параметр.Физлицо = Форма.Ссылка Тогда
		ДобавитьГиперссылки(Форма, ДополнительныеДействия);
	КонецЕсли;
	
КонецПроцедуры // ФормаФизическогоЛицаОбработкаОповещения

#КонецЕсли

Процедура ПриКопировании(ЭтотОбъект, ОбъектКопирования) Экспорт
	
	НастройкаВнутригрупповогоПорядкаЭлементовСобытия.НастройкаВнутригрупповогоПорядкаЭлементовПриКопировании(ЭтотОбъект, ОбъектКопирования, "НомерПозицииВПодразделении");
	
КонецПроцедуры

Процедура ПередЗаписью(ЭтотОбъект, Отказ) Экспорт
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаВнутригрупповогоПорядкаЭлементовСобытия.НастройкаВнутригрупповогоПорядкаЭлементовПередЗаписью(ЭтотОбъект, Отказ, "ТекущееПодразделениеКомпании", "НомерПозицииВПодразделении");
	
КонецПроцедуры

// Функция получает всех доступных пользователю сотрудников 
//  выбранного физического лица
// 
Функция СотрудникиФизлица(Физлицо, ПараметрыОтбора = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиОрганизаций.Ссылка
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо = &Физлицо";
	
	Если ПараметрыОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрыОтбора Цикл
			ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" И %1 = &%1", КлючИЗначение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Физлицо", Физлицо);
	
	Если ПараметрыОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрыОтбора Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	СотрудникиФизлица = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СотрудникиФизлица.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СотрудникиФизлица;
	
КонецФункции // СотрудникиФизлица

// Функция получает всех доступных пользователю кандидатов 
//  выбранного физического лица
// 
Функция КандидатыФизлица(Физлицо, ПараметрыОтбора = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Кандидаты.Ссылка
	|ИЗ
	|	Справочник.ЗаявкиКандидатов КАК Кандидаты
	|ГДЕ
	|	Кандидаты.ФизЛицо = &Физлицо
	|	И Кандидаты.ФизЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)";
	
	Если ПараметрыОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрыОтбора Цикл
			ТекстЗапроса = ТекстЗапроса + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(" И %1 = &%1", КлючИЗначение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Физлицо", Физлицо);
	
	Если ПараметрыОтбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ПараметрыОтбора Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	КандидатыФизлица = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		КандидатыФизлица.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат КандидатыФизлица;
	
КонецФункции // КандидатыФизлица

// Функция выполняет запрос для получения адресов электронной почты 
//  по списку физических лиц
//
// Параметры
//	Физлица - массив элементов справочника Физические лица
//	ВидАдресаЭП - необязательный, если не задан, то будет предприниматься попытка выбрать адрес, помеченный как основной
//
Функция ПрочитатьАдресаЭП(Физлица, ВидАдресаЭП = Неопределено) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Адресаты.Ссылка
	|ПОМЕСТИТЬ Адресаты
	|ИЗ
	|	Справочник.ФизическиеЛица КАК Адресаты
	|ГДЕ
	|	Адресаты.Ссылка В(&Адресаты)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Адресаты", Физлица);
	Запрос.Выполнить();
	
	Если ВидАдресаЭП = Неопределено Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Адресаты.Ссылка КАК Адресат,
		|	АдресЭлектроннойПочты.Вид КАК ВидАдресаЭП,
		|	1 КАК Приоритет
		|ПОМЕСТИТЬ ВидыАдресаЭПАдресатов
		|ИЗ
		|	Адресаты КАК Адресаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресЭлектроннойПочты
		|		ПО Адресаты.Ссылка = АдресЭлектроннойПочты.Объект
		|			И (АдресЭлектроннойПочты.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
		|			И (АдресЭлектроннойПочты.ЗначениеПоУмолчанию)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Адресаты.Ссылка,
		|	МИНИМУМ(АдресЭлектроннойПочты.Вид),
		|	2
		|ИЗ
		|	Адресаты КАК Адресаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресЭлектроннойПочты
		|		ПО Адресаты.Ссылка = АдресЭлектроннойПочты.Объект
		|			И (АдресЭлектроннойПочты.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
		|			И (НЕ АдресЭлектроннойПочты.ЗначениеПоУмолчанию)
		|
		|СГРУППИРОВАТЬ ПО
		|	Адресаты.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыАдресаЭПАдресатов.Адресат,
		|	МИНИМУМ(ВидыАдресаЭПАдресатов.Приоритет) КАК Приоритет
		|ПОМЕСТИТЬ ПриоритетыАдресаЭП
		|ИЗ
		|	ВидыАдресаЭПАдресатов КАК ВидыАдресаЭПАдресатов
		|
		|СГРУППИРОВАТЬ ПО
		|	ВидыАдресаЭПАдресатов.Адресат
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыАдреса.Адресат,
		|	ВидыАдреса.ВидАдресаЭП
		|ПОМЕСТИТЬ ВыбранныеВидыАдреса
		|ИЗ
		|	ВидыАдресаЭПАдресатов КАК ВидыАдреса
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПриоритетыАдресаЭП КАК ПриоритетыАдреса
		|		ПО ВидыАдреса.Адресат = ПриоритетыАдреса.Адресат
		|			И ВидыАдреса.Приоритет = ПриоритетыАдреса.Приоритет";
		Запрос.Выполнить();
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Адресаты.Ссылка КАК Адресат,
		|	&ВидАдреса КАК ВидАдресаЭП
		|ПОМЕСТИТЬ ВыбранныеВидыАдреса
		|ИЗ
		|	Адресаты КАК Адресаты";
		Запрос.УстановитьПараметр("ВидАдреса", ВидАдресаЭП);
		Запрос.Выполнить();
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Адресаты.Ссылка КАК Адресат,
	|	АдресЭлектроннойПочты.Представление КАК АдресЭП,
	|	АдресЭлектроннойПочты.Вид КАК ВидАдресаЭП
	|ИЗ
	|	Адресаты КАК Адресаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресЭлектроннойПочты
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыбранныеВидыАдреса КАК ВидыАдресаЭП
	|			ПО АдресЭлектроннойПочты.Вид = ВидыАдресаЭП.ВидАдресаЭП
	|				И АдресЭлектроннойПочты.Объект = ВидыАдресаЭП.Адресат
	|		ПО Адресаты.Ссылка = АдресЭлектроннойПочты.Объект
	|			И (АдресЭлектроннойПочты.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Определяет дату увольнения человека из компании
//
// Параметры
//	- Физлицо - физическое лицо
// 
// Возвращаемое значение - дата увольнения из компании или Неопределено, 
//		если человек никогда не работал в компании
//
Функция ДатаУвольненияИзКомпании(Физлицо)
	
	Сотрудники = СотрудникиФизлица(Физлицо);
	
	Если Сотрудники.Количество() = 0 Тогда
		// Нет сотрудников физического лица
		Возврат Неопределено;
	КонецЕсли;

	ДатыСотрудника = ОбщегоНазначенияЗК.ПолучитьЗначенияРеквизитов(Сотрудники[0], "ДатаПриемаНаРаботуВКомпанию, ДатаУвольненияИзКомпании");
	
	Если ДатыСотрудника.ДатаПриемаНаРаботуВКомпанию = Дата(1, 1, 1) Тогда
		// Сотрудник не был принят в компанию
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДатыСотрудника.ДатаУвольненияИзКомпании;
	
КонецФункции

// Определяет самую позднюю дату увольнения человека из компании 
// по данным регламентированного учета
// 
// Параметры
//	- Физлицо
//	- Организация - если не задано, определяется по всем организациям
//
// Возвращаемое значение - самая поздняя из дат увольнения, Неопределено, 
//		если нет ни одного трудового договора с физлицом
//
Функция ДатаУвольненияИзОрганизации(Физлицо, Организация = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(МАКСИМУМ(СотрудникиОрганизаций.ДатаУвольнения), НЕОПРЕДЕЛЕНО) КАК ДатаУвольнения
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо = &Физлицо
	|	И (СотрудникиОрганизаций.ТекущееОбособленноеПодразделение = &Организация
	|			ИЛИ НЕ &ОтборПоОрганизации)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Физлицо", Физлицо);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОтборПоОрганизации", ЗначениеЗаполнено(Организация));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ДатаУвольнения;
	
КонецФункции

// Определяет по какую дату физическому лицу могут быть доступны данные по его зарплате
// Дата определяется в соответствии с положением учетной политики, 
// а также с учетом даты увольнения сотрудника. 
// Если сотрудник уволен, то для него доступны расчеты текущего периода
//
// Параметры
//	- Физлицо
//	- Организация - необязательный, если не задан, дата увольнения будет определяться 
//			по всем организациям
//
Функция ГраницаПериодаДоступныхФизлицуДанныхЗарплаты(Физлицо, Организация = Неопределено) Экспорт
	
	ГраницаДанныхДоступныхФизлицу = ОбщегоНазначенияЗКПереопределяемый.ГраницаТекущегоПериодаРасчетаЗарплаты();
	
	// Определяем дату увольнения физлица в зависимости от того, 
	// в каком учете определена его "полная" зарплата
	
	УправленческийУчетПолный = Ложь;
	Если ОбщегоНазначенияЗК.ПолучитьЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты") Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетЗаработкаРаботников.Физлицо,
		|	ЕСТЬNULL(УчетЗаработкаРаботников.УчетНачисленийПоОрганизации, ЛОЖЬ) КАК УправленческийУчетПолный
		|ИЗ
		|	РегистрСведений.УчетЗаработкаРаботников.СрезПоследних(, Физлицо = &Физлицо) КАК УчетЗаработкаРаботников";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Физлицо", Физлицо);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			УправленческийУчетПолный = Выборка.УправленческийУчетПолный;
		КонецЕсли;	
	КонецЕсли;
	
	Если УправленческийУчетПолный Тогда
		ДатаУвольнения = ДатаУвольненияИзКомпании(Физлицо);
	Иначе
		ДатаУвольнения = ДатаУвольненияИзОрганизации(Физлицо, Организация);
	КонецЕсли;
	
	Если ДатаУвольнения <> Неопределено Тогда
		ГраницаДанныхДоступныхФизлицу = Макс(ДатаУвольнения, ГраницаДанныхДоступныхФизлицу);
	КонецЕсли;
	
	Возврат ГраницаДанныхДоступныхФизлицу;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры печати

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Печать") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Печать", "Сведения о физическом лице", ПечатьСведенийОФизлице(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры	

Функция ПечатьСведенийОФизлице(Ссылка, ОбъектыПечати = Неопределено, НазваниеОтчета = Неопределено, Результат = Неопределено) Экспорт
	
	Возврат УправлениеПечатью.ПечатьПриПомощиСКД(Справочники.ФизическиеЛица.ПолучитьМакет("ДосьеНаФизлицо"), "Физлицо", Ссылка, ОбъектыПечати, НазваниеОтчета, Результат);
	
КонецФункции
