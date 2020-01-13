﻿
&НаКлиенте
Процедура ПодборДолжностей(Команда)
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ЗакрыватьПриВыборе", Ложь);
	ОткрытьФорму("Справочник.ДолжностиОрганизаций.ФормаВыбора", СтруктураПараметры, Элементы.КонтролируемыеДолжности);
КонецПроцедуры

&НаКлиенте
Процедура КонтролируемыеДолжностиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ДолжностиОрганизаций") Тогда
		СтандартнаяОбработка = Ложь;
		Если Объект.КонтролируемыеДолжности.НайтиСтроки(Новый Структура("Должность", ВыбранноеЗначение)).Количество() = 0 Тогда
			Объект.КонтролируемыеДолжности.Добавить().Должность = ВыбранноеЗначение;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияСрокаДействияПриИзменении(Элемент)
	УстановитьДоступностьПериодичности();
КонецПроцедуры


&НаКлиенте
Процедура УстановитьДоступностьПериодичности()
	Элементы.СрокДействия.Доступность = Объект.СпособОпределенияСрокаДействия = РассчитываетсяАвтоматически;
	Элементы.Периодичность.Доступность = Объект.СпособОпределенияСрокаДействия = РассчитываетсяАвтоматически;
КонецПроцедуры //УстановитьДоступностьПериодичности()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РассчитываетсяАвтоматически = Перечисления.СпособыОпределенияСрокаДействия.РассчитываетсяАвтоматически;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Объект.СпособОпределенияСрокаДействия = Перечисления.СпособыОпределенияСрокаДействия.ОпределяетсяИндивидуально;
		Объект.Периодичность = Перечисления.Периодичность.Год;
		Объект.СрокДействия = 1;
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	ВалютаУпрУчета  = Константы.ВалютаУправленческогоУчета.Получить();
	Если ЗначениеЗаполнено(ВалютаУпрУчета) Тогда
		Элементы.СуммаРасходов.Заголовок = "Сумма расходов организации (" + ВалютаУпрУчета.Наименование +")";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьПериодичности();
КонецПроцедуры

&НаКлиенте
Процедура СрокДействияПриИзменении(Элемент)
	Если Объект.СрокДействия <= 0 Тогда
		Объект.СрокДействия = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.СпособОпределенияСрокаДействия = РассчитываетсяАвтоматически
		И НЕ ЗначениеЗаполнено(Объект.Периодичность) Тогда
		Предупреждение("Периодичность аттестации не указана");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтролируемыеДолжностиДолжностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ДолжностиОрганизаций") Тогда
		СтандартнаяОбработка = Ложь;
		Если Объект.КонтролируемыеДолжности.НайтиСтроки(Новый Структура("Должность", ВыбранноеЗначение)).Количество() = 0 Тогда
			Элементы.КонтролируемыеДолжности.ТекущиеДанные.Должность = ВыбранноеЗначение;
		Иначе
			Предупреждение("Должность " + ВыбранноеЗначение + " уже присутствует в списке.");	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтролируемыеДолжностиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока и Копирование Тогда
		Элементы.КонтролируемыеДолжности.ТекущиеДанные.Должность = "";
	КонецЕсли;
КонецПроцедуры
