﻿////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

Функция ПолучитьСписокВстречПоЗаявке(ЗаявкаКандидата) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ЗаявкаКандидата",	ЗаявкаКандидата);
	Запрос.УстановитьПараметр("ТекущаяДата",		ОбщегоНазначения.ПолучитьРабочуюДату());
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Встречи.Комментарий,
	|	Встречи.Ссылка,
	|	Встречи.ДатаНачала КАК ДатаНачала,
	|	Встречи.ДатаОкончания
	|ИЗ
	|	Документ.Встречи КАК Встречи
	|ГДЕ
	|	Встречи.ЗаявкаКандидата = &ЗаявкаКандидата
	|	И Встречи.Проведен
	|	И Встречи.ДатаОкончания >= &ТекущаяДата
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачала";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ИзменитьСостояниеЗаявкиКандидата(ЗаявкаКандидата, СостояниеЗаявки) Экспорт
	
	НаборЗаписей = РегистрыСведений.ТекущаяРаботаПоЗаявкамКандидатов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ОбщегоНазначения.ПолучитьРабочуюДату());
	НаборЗаписей.Отбор.ЗаявкаКандидата.Установить(ЗаявкаКандидата);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Строка = НаборЗаписей.Добавить();
		Строка.Период			= ОбщегоНазначения.ПолучитьРабочуюДату();
		Строка.ЗаявкаКандидата	= ЗаявкаКандидата;
	Иначе
		Строка = НаборЗаписей[0];
	КонецЕсли;
	
	Строка.Состояние = СостояниеЗаявки;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура НазначитьВстречу(ЭлементыФормы, ЭтаФорма, ЭтотОбъект) Экспорт
	
	ДанныеСтроки = ЭлементыФормы.ТабличноеПолеЗаявкиКандидатов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено ИЛИ ДанныеСтроки.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкиКандидатов.ФизЛицо,
	|	ЗаявкиКандидатов.Ответственный.ФизЛицо
	|ИЗ
	|	Справочник.ЗаявкиКандидатов КАК ЗаявкиКандидатов
	|ГДЕ
	|	ЗаявкиКандидатов.Ссылка = &ЗаявкаКандидата";
	Запрос.УстановитьПараметр("ЗаявкаКандидата",	ДанныеСтроки.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Форма = Документы.Встречи.ПолучитьФормуНовогоДокумента(, ЭтаФорма, ЭтотОбъект);
	
	Форма.ВстречаСКандидатом	= Истина;
	Форма.ЗаявкаКандидата		= ДанныеСтроки.Ссылка;
	
	Если Выборка.Следующий() Тогда
		Если Не Выборка.Физлицо.Пустая() Тогда
			Форма.Участники.Добавить().Физлицо = Выборка.Физлицо;
		КонецЕсли;
		Если Выборка.ОтветственныйФизлицо <> NULL И Не Выборка.ОтветственныйФизлицо.Пустая() Тогда
			Форма.Участники.Добавить().Физлицо = Выборка.ОтветственныйФизлицо;
		КонецЕсли;
	КонецЕсли;
	
	Форма.Открыть();
	
КонецПроцедуры

Функция ТекстУсловияЗапросаПоСтруктуреОтбора(СтруктураОтбора) Экспорт
	
	// В этой конфигурации условие запроса не дополняется
	Возврат "";
	
КонецФункции

Процедура ЗаполнитьПараметрыЗапросаПоСтруктуреОтбора(Запрос, СтруктураОтбора) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура РаботаПоЗаявкеЗавершена(Форма, ВыделенныеСтроки)
	
	ДанныеСтроки = Форма.ЭлементыФормы.ТабличноеПолеЗаявкиКандидатов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено ИЛИ ДанныеСтроки.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = "Кандидаты, работа по которым завершена, не будут отображаться в списке активных кандидатов, но будут доступны в списке всех кандидатов.  Завершить работу по кандидату?";
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗаявок = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ВыделеннаяСтрока.Ссылка.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		ЗаявкаОбъект = ВыделеннаяСтрока.Ссылка.ПолучитьОбъект();
		ЗаявкаОбъект.Закрыта	= Истина;
		ЗаявкаОбъект.Записать();
		МассивЗаявок.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Для Каждого ВыделеннаяСтрока Из МассивЗаявок Цикл
		СтарыйРодитель	= ВыделеннаяСтрока.Родитель;
		СтарыйРодитель.Строки.Удалить(ВыделеннаяСтрока);
		Если СтарыйРодитель.Строки.Количество() = 0 Тогда
			Форма.ДеревоЗаявокКандидатов.Строки.Удалить(СтарыйРодитель);
		Иначе
			СтарыйРодитель.Количество = СтарыйРодитель.Строки.Количество();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьСотрудника(Форма)
	
	ДанныеСтроки = Форма.ЭлементыФормы.ТабличноеПолеЗаявкиКандидатов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено ИЛИ ДанныеСтроки.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаявкаДляСотрудника = ДанныеСтроки.Ссылка;
	
	ФормаСотрудника = Справочники.СотрудникиОрганизаций.ПолучитьФормуНовогоЭлемента(, Форма, Форма);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаявкаКандидата",	ЗаявкаДляСотрудника);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкиКандидатов.ФизЛицо
	|ИЗ
	|	Справочник.ЗаявкиКандидатов КАК ЗаявкиКандидатов
	|ГДЕ
	|	ЗаявкиКандидатов.Ссылка = &ЗаявкаКандидата";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ФормаСотрудника.Физлицо	= Выборка.Физлицо;
	КонецЕсли;
	
	ФормаСотрудника.Открыть();
	
	Опрос = ПроцедурыУправленияПерсоналомПереопределяемый.НайтиРезюмеКандидата(ЗаявкаДляСотрудника);
	
	ЗаполнитьРеквизитыФизическогоЛица(ФормаСотрудника, ФормаСотрудника.ФизлицоОбъект, ДанныеСтроки.Наименование, Опрос);
	
	ФормаСотрудника.ФизлицоОбъект.Наименование = ФормаСотрудника.Наименование;
	
	СотрудникиОрганизацийКлиент.УстановитьЗаголовокВидимостьПерейтиКВводуГруппыДоступа(ФормаСотрудника);
	
КонецПроцедуры

Процедура СоздатьФизлицоПоЗаявке(Форма)
	
	ДанныеСтроки = Форма.ЭлементыФормы.ТабличноеПолеЗаявкиКандидатов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено ИЛИ ДанныеСтроки.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаявкаДляСотрудника = ДанныеСтроки.Ссылка;
	
	ФормаФизлица = Справочники.ФизическиеЛица.ПолучитьФормуНовогоЭлемента(, Форма, Форма);
	
	Опрос = ПроцедурыУправленияПерсоналомПереопределяемый.НайтиРезюмеКандидата(ДанныеСтроки.Ссылка);
	
	ЗаполнитьРеквизитыФизическогоЛица(ФормаФизлица, ФормаФизлица, ДанныеСтроки.Наименование, Опрос);
	
	ФормаФизлица.Открыть();
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыФизическогоЛица(Форма, ФизическоеЛицо, Знач НаименованиеЗаявки, Опрос = Неопределено)
	
	Если Опрос = Неопределено Тогда
		Форма.Наименование			= НаименованиеЗаявки;
		ФизическоеЛицо.Наименование	= НаименованиеЗаявки;
		МассивФИО = ОбщегоНазначенияЗК.ПолучитьМассивФИО(НаименованиеЗаявки);
		Форма.Фамилия				= МассивФИО[0];
		Форма.Имя					= МассивФИО[1];
		Форма.Отчество				= МассивФИО[2];
		Если ЗначениеЗаполнено(Форма.Отчество) Тогда
			ФизическоеЛицо.Пол		= ПроцедурыУправленияПерсоналом.ПолучитьПол(Форма.Отчество);
		КонецЕсли;
		
	Иначе
		АнкетированиеДополнительный.ЗаполнитьФизическоеЛицоПоОпросу(Форма, ФизическоеЛицо, Опрос);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы

Процедура ДополнитьКонтекстныеМеню(ЭлементыФормы, ДополнительныеДействия) Экспорт
	
	Кнопки = ЭлементыФормы.КоманднаяПанельЗаявкиКандидатов.Кнопки.ПодменюЗаявки.Кнопки;
	
	МестоВставки = Кнопки.Индекс(Кнопки.Найти("ДобавитьФайлы")) + 1;
	
	Кнопки.Вставить(МестоВставки, "РазделительРаботаПоЗаявкеЗавершена", ТипКнопкиКоманднойПанели.Разделитель);
	
	РаботаПоЗаявкеЗавершена = Кнопки.Вставить(МестоВставки, "РаботаПоЗаявкеЗавершена", ТипКнопкиКоманднойПанели.Действие, "Работа по заявке завершена", ДополнительныеДействия);
	РаботаПоЗаявкеЗавершена.Подсказка = "Работа по заявке завершена";
	РаботаПоЗаявкеЗавершена.Пояснение = "Работа по заявке завершена";
	
	Кнопки.Вставить(МестоВставки, "РазделительСоздатьСотрудникаПоЗаявке", ТипКнопкиКоманднойПанели.Разделитель);
	
	СоздатьСотрудникаПоЗаявке = Кнопки.Вставить(МестоВставки, "СоздатьСотрудникаПоЗаявке", ТипКнопкиКоманднойПанели.Действие, "Создать сотрудника по кандидату...", ДополнительныеДействия);
	СоздатьСотрудникаПоЗаявке.Подсказка = "Создать сотрудника по кандидату...";
	СоздатьСотрудникаПоЗаявке.Пояснение = "Создать сотрудника по кандидату...";
	СоздатьСотрудникаПоЗаявке.Картинка	= БиблиотекаКартинок.ПринятьНаРаботу;
	
	СоздатьФизлицоПоЗаявке = Кнопки.Вставить(МестоВставки, "СоздатьФизлицоПоЗаявке", ТипКнопкиКоманднойПанели.Действие, "Занести кандидата в список физических лиц...", ДополнительныеДействия);
	СоздатьФизлицоПоЗаявке.Подсказка = "Занести кандидата в список физических лиц...";
	СоздатьФизлицоПоЗаявке.Пояснение = "Занести кандидата в список физических лиц...";
	
	Кнопки.Вставить(МестоВставки, "РазделительСоздатьФизлицоПоЗаявке", ТипКнопкиКоманднойПанели.Разделитель);
	
КонецПроцедуры // ДополнитьКонтекстныеМеню
	
Процедура УстановитьДоступностьДополнительныхКнопок(КнопкиПодменю, КомандыЗаявкиДоступны, НеДоступнаГрупповаяОбработка, ДанныеСтроки) Экспорт
	
	ДоступностьКоманд = Новый Соответствие;
	ДоступностьКоманд.Вставить("СоздатьФизлицоПоЗаявке", 	КомандыЗаявкиДоступны И ДанныеСтроки.Ссылка.Физлицо.Пустая() И НеДоступнаГрупповаяОбработка);
	ДоступностьКоманд.Вставить("СоздатьСотрудникаПоЗаявке", КомандыЗаявкиДоступны И НеДоступнаГрупповаяОбработка);
	ДоступностьКоманд.Вставить("РаботаПоЗаявкеЗавершена", 	КомандыЗаявкиДоступны);
	
	Для Каждого КлючИЗначение Из ДоступностьКоманд Цикл
		Если КнопкиПодменю.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
			КнопкиПодменю[КлючИЗначение.Ключ].Доступность = КлючИЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьДополнительныеДействия(Кнопка, ЭлементыФормы, Форма, ЭтотОбъект, ВыделенныеСтроки) Экспорт
	
	Если Кнопка.Имя = "РаботаПоЗаявкеЗавершена" Тогда
		РаботаПоЗаявкеЗавершена(Форма, ВыделенныеСтроки);
	ИначеЕсли Кнопка.Имя = "СоздатьСотрудникаПоЗаявке" Тогда
		СоздатьСотрудника(Форма);
	ИначеЕсли Кнопка.Имя = "СоздатьФизлицоПоЗаявке" Тогда
		СоздатьФизлицоПоЗаявке(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаПередОткрытиемДополнительно(Форма, ДополнительныеДействия = Неопределено) Экспорт
	
	Форма.ЭлементыФормы.ПанельДополнительныеСведения.Свертка = РежимСверткиЭлементаУправления.Верх;
	
	Форма.ЭлементыФормы.ФИО.Заголовок = "Описание кандидата";
	
КонецПроцедуры // ФормаПередОткрытиемДополнительно

Процедура ФормаПередЗакрытиемДополнительно(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ФормаОбработкаОповещенияДополнительно(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // ФормаОбработкаОповещенияДополнительно

Процедура СписокКандидатовПриПолученииДанныхДополнительно(Форма, Элемент, ОформленияСтрок) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // СписокКандидатовПриПолученииДанныхДополнительно

Процедура СписокКандидатовПриАктивизацииСтрокиДополнительно(Форма, Элемент) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // СписокКандидатовПриАктивизацииСтрокиДополнительно

Функция ПараметрыЭлементаОписанияКандидата(Выборка, ДанныеКандидата)
	
	ПараметрыОписания = Новый Структура;
	
	// состояние кандидата
	ПараметрыОписания.Вставить("СостояниеЗаполнено", 	?(ЗначениеЗаполнено(Выборка.Состояние), "inline", "none"));
	ПараметрыОписания.Вставить("СостояниеНеЗаполнено", 	?(ЗначениеЗаполнено(Выборка.Состояние), "none", "inline"));
	ПараметрыОписания.Вставить("СостояниеКандидата", 	"<A id=Команда href=""V8:ChangeStatus"" target=""" + Строка(Выборка.Состояние.УникальныйИдентификатор()) + """>" + ?(ЗначениеЗаполнено(Выборка.Состояние), Строка(Выборка.Состояние), "не указано") + "</A>. ");
	
	// вакансия	кандидата
	Если Выборка.ВакансияНеЗаполнена Тогда
		Если Выборка.РабочееМестоНеЗаполнено Тогда
			Вакансия	= "Вакансия, на которую рассматривается кандидат, <A id=Команда href=""V8:ChangeVacancy"">не указана</A>";
		Иначе
			Вакансия	= "Кандидат рассматриваетcя";
			Если Не Выборка.ПодразделениеНеЗаполнено Тогда
				ТипСправочника = ?(НаборПерсоналаПереопределяемый.ПолучитьНаименованиеСправочникаПодразделения() = "ПодразделенияОрганизаций", "OrganizationDivision", "Division");
				ПодразделениеИд	= Строка(Выборка.Подразделение.УникальныйИдентификатор());
				Вакансия		= Вакансия + " в подразделение: " + "<A id=Команда href=""V8:Open"+ТипСправочника+""" target="""+ПодразделениеИд+""">"+Строка(Выборка.Подразделение)+"</A>";
			КонецЕсли;
			Если Не Выборка.ДолжностьНеЗаполнена Тогда
				ДолжностьИд	= Строка(Выборка.Должность.УникальныйИдентификатор());
				Вакансия	= Вакансия + " на должность: " + "<A id=Команда href=""V8:OpenPosition"" target="""+ДолжностьИд+""">"+Строка(Выборка.Должность)+"</A>";
			КонецЕсли;
		КонецЕсли;
	Иначе
		ВакансияИд	= Строка(Выборка.Вакансия.УникальныйИдентификатор());
		Вакансия	= "Кандидат рассматриваетcя на вакансию: <A id=Команда href=""V8:OpenVacancy"" target="""+ВакансияИд+""">"+Строка(Выборка.Вакансия)+"</A>";
	КонецЕсли;
	
	ПараметрыОписания.Вставить("Вакансия",	Вакансия);
	
	Возврат ПараметрыОписания;
	
КонецФункции // ПараметрыЭлементаОписанияКандидата

Процедура ДополнитьМакетОписанияЗаявки(Форма, Выборка, ТекстМакетаОписанияЗаявки, КандидатСсылка) Экспорт
	
	ДанныеКандидата = Неопределено;
	Если Форма.ДанныеКандидатов <> Неопределено Тогда 
		ДанныеКандидата = Форма.ДанныеКандидатов[КандидатСсылка];
	КонецЕсли;
	
	ПараметрыОписания = ПараметрыЭлементаОписанияКандидата(Выборка, ДанныеКандидата);
	
	ТекстМакетаОписанияЗаявки = ТекстМакетаОписанияЗаявки + "
	|			<P id=СостояниеЗаполнено style=""DISPLAY:" + ПараметрыОписания.СостояниеЗаполнено + """>Текущее состояние: </P>
	|			<P id=СостояниеНеЗаполнено style=""DISPLAY:" + ПараметрыОписания.СостояниеНеЗаполнено + """>Текущее состояние </P>
	|			<P id=СостояниеКандидата style=""DISPLAY:inline"">" + ПараметрыОписания.СостояниеКандидата + " </P>
	|			<P id=Вакансия style=""DISPLAY:inline"">" + ПараметрыОписания.Вакансия + "</P>
	|";
	
КонецПроцедуры // ДополнитьМакетОписанияЗаявки

Процедура ОбновитьМакетОписанияЗаявки(ОписаниеКандидата, Выборка, Форма, КандидатСсылка) Экспорт
	
	ДанныеКандидата = Неопределено;
	Если Форма.ДанныеКандидатов <> Неопределено Тогда 
		ДанныеКандидата = Форма.ДанныеКандидатов[КандидатСсылка];
	КонецЕсли;
	
	ПараметрыОписания = ПараметрыЭлементаОписанияКандидата(Выборка, ДанныеКандидата);
	
	ОписаниеКандидата.getElementById("СостояниеКандидата").innerHTML 	= ПараметрыОписания.СостояниеКандидата;
	ОписаниеКандидата.getElementById("Вакансия").innerHTML 				= ПараметрыОписания.Вакансия;

КонецПроцедуры // ОбновитьМакетОписанияЗаявки

#КонецЕсли
