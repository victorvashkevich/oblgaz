﻿
#Если Клиент Тогда

// Преобразует значение в число
Функция ПараметрВЧисло(Параметр)
	Если Параметр = Неопределено Или Параметр = NULL Тогда
		Возврат 0;
	Иначе	
		Возврат Параметр;
	КонецЕсли; 
КонецФункции
 
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет табличный документ
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//
Процедура СформироватьОтчет(ДокументРезультат) Экспорт

	Отказ = Ложь;
	
	// Проверка параметров
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация!", Отказ);
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан налоговый период!", Отказ);
	КонецЕсли; 
	Если НЕ ЗначениеЗаполнено(Физлицо) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан работник организации!", Отказ);
	КонецЕсли; 
	Если Отказ Тогда
		Возврат ;
	КонецЕсли; 	
	
	ДокументРезультат.Очистить();
	Макет =	ПолучитьМакет("ИндивидуальнаяКарточкаЕСН");

	// Расчет вычисляемых параметров
	ДатаНачалаНП = НачалоГода(Дата(НалоговыйПериод,1,1));
	ДатаКонцаНП = КонецГода(Дата(НалоговыйПериод,1,1));
	ГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
	// Создание запроса и установка всех необходимых параметров
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("ВидСтавокЕСНиПФР", ГоловнаяОрганизация.ВидСтавокЕСНиПФР);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос.УстановитьПараметр("НачалоНП", ДатаНачалаНП);
	Запрос.УстановитьПараметр("ГодНП", НалоговыйПериод);
	Запрос.УстановитьПараметр("КонецНП", ДатаКонцаНП);
	Запрос.УстановитьПараметр("ВидАдресаРегистрации" , Справочники.ВидыКонтактнойИнформации.ЮрАдресФизЛица);
	Запрос.УстановитьПараметр("ВидАдресаФактический" , Справочники.ВидыКонтактнойИнформации.ФактАдресФизЛица);
	Запрос.УстановитьПараметр("КодДоходаПособияЗаСчетФСС", Справочники.ДоходыЕСН.ПособияЗаСчетФСС);
	Запрос.УстановитьПараметр("КодДоходаНеОбъект", Справочники.ДоходыЕСН.НеЯвляетсяОбъектом);
	Запрос.УстановитьПараметр("КодДоходаВыплатыЗаСчетПрибыли", Справочники.ДоходыЕСН.ВыплатыЗаСчетПрибыли);
	Запрос.УстановитьПараметр("КодДоходаНеОблагаетсяЦеликом", Справочники.ДоходыЕСН.НеОблагаетсяЦеликом);
	Запрос.УстановитьПараметр("КодДоходаДоговораГПХ", Справочники.ДоходыЕСН.ДоговораГПХ);
	Запрос.УстановитьПараметр("КодДоходаДоговораАвторские", Справочники.ДоходыЕСН.ДоговораАвторские);
	СписокСтруктурныхПодразделений = ПроцедурыУправленияПерсоналом.ПолучитьСписокОбособленныхПодразделенийОрганизации(ГоловнаяОрганизация);
	СписокСтруктурныхПодразделений.Добавить(ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("СписокСтруктурныхПодразделений", СписокСтруктурныхПодразделений);
	
		
	// ---------------------------------------------------------------------------
	// Тексты запросов
	//

	// Сформируем текст запроса выборки месяцев налогового периода
	МесяцыНПТекст = "ВЫБРАТЬ 1 КАК МЕСЯЦ";
	Для Сч = 2 По 12 Цикл
		МесяцыНПТекст = МесяцыНПТекст +" ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ " + Сч;
	КонецЦикла;
	
	
	//-----------------------------------------------------------------------------
	// ВЫБОРКА СВЕДЕНИЙ О ФИЗЛИЦЕ 
	// 	
	
	ДанныеОФизлицеТекст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ФИОФизЛица.Фамилия + "" "" + ФИОФизЛица.Имя + "" "" + ФИОФизЛица.Отчество, ДанныеОФизЛице.Наименование) КАК ФИО,
	|	ДанныеОФизЛице.ИНН КАК ИНН,
	|	ДанныеОФизЛице.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	ВЫБОР
	|		КОГДА ДанныеОФизЛице.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Мужской)
	|			ТОГДА ""М""
	|		ИНАЧЕ ""Ж""
	|	КОНЕЦ КАК Пол,
	|	ДанныеОФизЛице.ДатаРождения КАК ДатаРождения,
	|	ЕСТЬNULL(ГражданствоФизЛица.Страна.Наименование, ""Россия"") КАК Гражданство,
	|	ПаспортныеДанныеФизЛица.ДокументСерия КАК ДокументСерия,
	|	ПаспортныеДанныеФизЛица.ДокументНомер КАК ДокументНомер,
	|	ПаспортныеДанныеФизЛица.ДокументДатаВыдачи,
	|	ВЫРАЗИТЬ(ПаспортныеДанныеФизЛица.ДокументКемВыдан КАК СТРОКА(300)) КАК ДокументКемКогдаВыдан,
	|	"","" + АдресаРегистрации.Поле1 + "","" + АдресаРегистрации.Поле2 + "","" + АдресаРегистрации.Поле3 + "","" + АдресаРегистрации.Поле4 + "","" + АдресаРегистрации.Поле5 + "","" + АдресаРегистрации.Поле6 + "","" + АдресаРегистрации.Поле7 + "","" + АдресаРегистрации.Поле8 + "","" + АдресаРегистрации.Поле9 КАК АдресРегистрации,
	|	"","" + АдресаФактические.Поле1 + "","" + АдресаФактические.Поле2 + "","" + АдресаФактические.Поле3 + "","" + АдресаФактические.Поле4 + "","" + АдресаФактические.Поле5 + "","" + АдресаФактические.Поле6 + "","" + АдресаФактические.Поле7 + "","" + АдресаФактические.Поле8 + "","" + АдресаФактические.Поле9 КАК АдресФактический,
	|	СведенияОбИнвалидности.ГруппаИнвалидности,
	|	СведенияОбИнвалидности.СерияСправки КАК СерияСправкиИнвалидности,
	|	СведенияОбИнвалидности.НомерСправки КАК НомерСправкиИнвалидности,
	|	ВЫБОР
	|		КОГДА ДолжностиРаботниковОрганизации.ПериодЗавершения <= &КонецНП
	|				И ДолжностиРаботниковОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДолжностиРаботниковОрганизации.ДолжностьЗавершения.Наименование
	|		ИНАЧЕ ДолжностиРаботниковОрганизации.Должность.Наименование
	|	КОНЕЦ КАК Должность,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.Сотрудник ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ТрудовойДоговор,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.Сотрудник ЕСТЬ NULL 
	|				И ДоговорНаВыполнениеРаботСФизЛицом.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Подряда)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ДоговорПодряда,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.Сотрудник ЕСТЬ NULL 
	|				И ДоговорНаВыполнениеРаботСФизЛицом.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Авторский)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК АвторскийДоговор,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.Сотрудник ЕСТЬ НЕ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА РаботникиОрганизации.Сотрудник.НомерДоговора = """"
	|						ТОГДА ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка.Номер
	|					ИНАЧЕ РаботникиОрганизации.Сотрудник.НомерДоговора
	|				КОНЕЦ
	|		КОГДА ДоговорНаВыполнениеРаботСФизЛицом.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Подряда)
	|			ТОГДА ДоговорНаВыполнениеРаботСФизЛицом.Номер
	|		КОГДА ДоговорНаВыполнениеРаботСФизЛицом.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Авторский)
	|			ТОГДА ДоговорНаВыполнениеРаботСФизЛицом.Номер
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК НомерДоговора,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизации.Сотрудник ЕСТЬ НЕ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА ДолжностиРаботниковОрганизации.ПериодЗавершения <= &КонецНП
	|							И ДолжностиРаботниковОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|							И ДолжностиРаботниковОрганизации.ПричинаИзмененияСостоянияЗавершения <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|						ТОГДА ДолжностиРаботниковОрганизации.ПериодЗавершения
	|					ИНАЧЕ ДолжностиРаботниковОрганизации.Период
	|				КОНЕЦ
	|		КОГДА ДоговорНаВыполнениеРаботСФизЛицом.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Подряда)
	|			ТОГДА ДоговорНаВыполнениеРаботСФизЛицом.Дата
	|		КОГДА ДоговорНаВыполнениеРаботСФизЛицом.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Авторский)
	|			ТОГДА ДоговорНаВыполнениеРаботСФизЛицом.Дата
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ДатаНазначенияНаДолжность
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ДанныеОФизЛице
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&КонецНП, ФизЛицо = &ФизЛицо) КАК ФИОФизЛица
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|				&КонецНП,
	|				Сотрудник.ФизЛицо = &ФизЛицо
	|					И Организация = &ГоловнаяОрганизация
	|					И Сотрудник.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство)
	|					И ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу)) КАК РаботникиОрганизации
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриемНаРаботуВОрганизацию.РаботникиОрганизации КАК ПриемНаРаботуВОрганизациюРаботникиОрганизации
	|			ПО ПриемНаРаботуВОрганизациюРаботникиОрганизации.Ссылка = РаботникиОрганизации.Регистратор
	|				И ПриемНаРаботуВОрганизациюРаботникиОрганизации.Сотрудник = РаботникиОрганизации.Сотрудник
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|					&КонецНП,
	|					Сотрудник.ФизЛицо = &ФизЛицо
	|						И Организация = &ГоловнаяОрганизация
	|						И Сотрудник.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство)
	|						И ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)) КАК ДолжностиРаботниковОрганизации
	|			ПО РаботникиОрганизации.Сотрудник = ДолжностиРаботниковОрганизации.Сотрудник
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПаспортныеДанныеФизЛиц.СрезПоследних(&КонецНП, ФизЛицо = &ФизЛицо) КАК ПаспортныеДанныеФизЛица
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизЛиц.СрезПоследних(&КонецНП, ФизЛицо = &ФизЛицо) КАК ГражданствоФизЛица
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресаРегистрации
	|		ПО (АдресаРегистрации.Объект = &ФизЛицо)
	|			И (АдресаРегистрации.Вид = &ВидАдресаРегистрации)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресаФактические
	|		ПО (АдресаФактические.Объект = &ФизЛицо)
	|			И (АдресаФактические.Вид = &ВидАдресаФактический)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДоговорНаВыполнениеРаботСФизЛицом КАК ДоговорНаВыполнениеРаботСФизЛицом
	|		ПО (ДоговорНаВыполнениеРаботСФизЛицом.Организация В (&СписокСтруктурныхПодразделений))
	|			И (ДоговорНаВыполнениеРаботСФизЛицом.ДатаОкончания <= &КонецНП
	|				ИЛИ ДоговорНаВыполнениеРаботСФизЛицом.ДатаНачала >= &КонецНП)
	|			И ДанныеОФизЛице.Ссылка = ДоговорНаВыполнениеРаботСФизЛицом.Сотрудник.Физлицо
	|			И (ДоговорНаВыполнениеРаботСФизЛицом.Проведен)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(СведенияОбИнвалидностиФизЛиц.Период) КАК Период
	|		ИЗ
	|			РегистрСведений.СведенияОбИнвалидностиФизлиц КАК СведенияОбИнвалидностиФизЛиц
	|		ГДЕ
	|			СведенияОбИнвалидностиФизЛиц.Физлицо = &ФизЛицо
	|			И СведенияОбИнвалидностиФизЛиц.Период <= &КонецНП) КАК ДатаСведенийОбИнвалидности
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбИнвалидностиФизлиц КАК СведенияОбИнвалидности
	|		ПО (СведенияОбИнвалидности.Физлицо = &ФизЛицо)
	|			И СведенияОбИнвалидности.Период = ДатаСведенийОбИнвалидности.Период
	|			И (СведенияОбИнвалидности.Инвалидность)
	|ГДЕ
	|	ДанныеОФизЛице.Ссылка = &ФизЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	РаботникиОрганизации.Период УБЫВ,
	|	ДоговорНаВыполнениеРаботСФизЛицом.ДатаНачала УБЫВ";
	
	// ДоходыПоМесяцамКодамТекст
	// Таблица доходов ЕСН по Месяцам налогового периода и кодам дохода
	// Поля:
	//		Месяц
	//		КодДоходаЕСН
	//		Результат
	//		Скидка
	// Описание:
	// 	Выбираем зарегистрированные доходы из ЕСНСведенияОДоходах 	
	//  Запрос выполняется для списка обособленных подразделений.
	
	ДоходыПоМесяцамКодамТекст = 
	"ВЫБРАТЬ
	|	МЕСЯЦ(ЕСНСведенияОДоходах.Период) КАК Месяц,
	|	ЕСНСведенияОДоходах.КодДоходаЕСН,
	|	СУММА(ЕСНСведенияОДоходах.Результат) КАК Результат,
	|	СУММА(ЕСНСведенияОДоходах.Скидка) КАК Скидка
	|ИЗ
	|	РегистрНакопления.ЕСНСведенияОДоходах КАК ЕСНСведенияОДоходах
	|ГДЕ
	|	ЕСНСведенияОДоходах.ФизЛицо = &ФизЛицо
	|	И ЕСНСведенияОДоходах.Организация = &ГоловнаяОрганизация
	|	И ЕСНСведенияОДоходах.Период МЕЖДУ &НачалоНП И &КонецНП
	|	И (НЕ ЕСНСведенияОДоходах.ОблагаетсяЕНВД)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСНСведенияОДоходах.КодДоходаЕСН,
	|	МЕСЯЦ(ЕСНСведенияОДоходах.Период)";
	
	// первый месяц
	КонецМесяца = КонецМесяца(ДатаНачалаНП);
	ПериодыТекст = "ВЫБРАТЬ ДАТАВРЕМЯ(" + Формат(КонецМесяца,"ДФ=гггг,М,д,Ч,м,с") + ") КАК Период";
	// прибавим остальные месяцы
	Для Сч = 2 По 12 Цикл
		КонецМесяца = КонецМесяца(КонецМесяца+1);
		ПериодыТекст = ПериодыТекст +" ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ДАТАВРЕМЯ(" + Формат(КонецМесяца,"ДФ=гггг,М,д,Ч,м,с") + ")";
	КонецЦикла;
	
	// ДанныеОПравеНаПенсию
	// Таблица Таблица Данные о праве на пенсию: - таблица это список иностранцев и периодов
	// Поля:
	//		Физлицо, 
	//		Месяц - месяц налогового периода
	// 
	// Описание:
	//	Выбираем Из Списка периодов
	//	Внутреннее соединение с ГражданствоФизЛиц.СрезПоследних
	//  по равенству периодов
	//  условие: что физлицо - не имеет права на пенсию
	//
	ДанныеОПравеНаПенсиюТекст = "
	|ВЫБРАТЬ
	|	Месяц(Периоды.Период) КАК Месяц,
	|	ГражданствоФизЛиц.ФизЛицо КАК Физлицо
	|ИЗ
	|	(ВЫБРАТЬ
	|		Периоды.Период КАК Период,
	|		ГражданствоФизЛиц.ФизЛицо КАК Физлицо,
	|		МАКСИМУМ(ГражданствоФизЛиц.Период) КАК ПериодРегистра
	|	ИЗ
	|		("+ПериодыТекст+") КАК Периоды
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизЛиц КАК ГражданствоФизЛиц
	|			ПО Периоды.Период >= ГражданствоФизЛиц.Период и ГражданствоФизЛиц.ФизЛицо = &ФизЛицо
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ГражданствоФизЛиц.ФизЛицо,
	|		Периоды.Период) КАК Периоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизЛиц КАК ГражданствоФизЛиц
	|		ПО ГражданствоФизЛиц.Период = Периоды.ПериодРегистра И ГражданствоФизЛиц.ФизЛицо = Периоды.Физлицо И ГражданствоФизЛиц.НеИмеетПравоНаПенсию
	|";
	
	// УчетнаяПолитикаНалоговыйУчет
	// Таблица УчетнаяПолитикаНалоговыйУчетУСН - это список периодов, когда организация переходила на УСН
	// поля:
	//		УСН, 
	//		Месяц - месяц налогового периода
	// Описание:	
	//	Выбираем Из Периоды (таблица - список периодов с начала года по текущий период)
	//	Внутреннее соединение с "псевдосрезом" последних регистра УчетнаяПолитикаНалоговыйУчет
	//	по равенству периодов
	//  условие: что организация использует УСН
	
 	УчетнаяПолитикаНалоговыйУчет = 
	"ВЫБРАТЬ
	|	МЕСЯЦ(Периоды.Период) КАК Месяц,
	|	УчетнаяПолитикаНалоговыйУчет.УСН КАК УСН
	|ИЗ
	|	(ВЫБРАТЬ
	|		Периоды.Период КАК Период,
	|		МАКСИМУМ(УчетнаяПолитикаНалоговыйУчет.Период) КАК ПериодРегистра
	|	ИЗ
	|		("+ ПериодыТекст +") КАК Периоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчет
	|		ПО Периоды.Период >= УчетнаяПолитикаНалоговыйУчет.Период И УчетнаяПолитикаНалоговыйУчет.Организация = &ГоловнаяОрганизация
	|
	|	СГРУППИРОВАТЬ ПО
	|		Периоды.Период) КАК Периоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчет
	|		ПО Периоды.ПериодРегистра = УчетнаяПолитикаНалоговыйУчет.Период И УчетнаяПолитикаНалоговыйУчет.Организация = &ГоловнаяОрганизация И (УчетнаяПолитикаНалоговыйУчет.УСН)";	

	// ПоказателиДоходовПоМесяцамТекст
	// Описание:
	//  Вычисляет показатели отчета, основанные на сведениях о доходах
					 
	ПоказателиДоходовПоМесяцамТекст ="
	|ВЫБРАТЬ 
	|	Доходы.Месяц,
	|	СУММА(ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL И Доходы.КодДоходаЕСН.ВходитВБазуЕдиныйПлатеж ТОГДА Доходы.Результат - Доходы.Скидка ИНАЧЕ 0 КОНЕЦ) КАК НалоговаяБазаФБ,
	|	СУММА(ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL И Иностр.Физлицо ЕСТЬ NULL И Доходы.КодДоходаЕСН.ВходитВБазуЕдиныйПлатеж ТОГДА Доходы.Результат - Доходы.Скидка ИНАЧЕ 0 КОНЕЦ) КАК БазаПФР,
	|	СУММА(ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL И Доходы.КодДоходаЕСН.ВходитВБазуСтрах ТОГДА Доходы.Результат - Доходы.Скидка ИНАЧЕ 0 КОНЕЦ) КАК НалоговаяБазаФСС,
	|	СУММА(ВЫБОР КОГДА Доходы.КодДоходаЕСН <> &КодДоходаНеОбъект ТОГДА Доходы.Результат ИНАЧЕ 0 КОНЕЦ) КАК НачисленоВсего,
	|	СУММА(ВЫБОР КОГДА Доходы.КодДоходаЕСН = &КодДоходаВыплатыЗаСчетПрибыли ТОГДА Доходы.Результат ИНАЧЕ 0 КОНЕЦ) КАК ВыплатыЗаСчетПрибыли,
	|	СУММА(ВЫБОР КОГДА Доходы.КодДоходаЕСН = &КодДоходаПособияЗаСчетФСС ИЛИ Доходы.КодДоходаЕСН = &КодДоходаНеОблагаетсяЦеликом ТОГДА Доходы.Результат ИНАЧЕ Доходы.Скидка КОНЕЦ) КАК НеОблагаетсяПоСт238КромеДоговоров,
	|	СУММА(ВЫБОР КОГДА Доходы.КодДоходаЕСН = &КодДоходаДоговораГПХ ИЛИ Доходы.КодДоходаЕСН = &КодДоходаДоговораАвторские ТОГДА Доходы.Результат ИНАЧЕ 0 КОНЕЦ) КАК ВыплатыПоДоговорам,
	|	СУММА(ВЫБОР КОГДА Доходы.КодДоходаЕСН = &КодДоходаПособияЗаСчетФСС ТОГДА Доходы.Результат ИНАЧЕ 0 КОНЕЦ) КАК ПособияЗаСчетФСС
	|	ИЗ 
	|		( " + ДоходыПоМесяцамКодамТекст + " ) КАК Доходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ("+ДанныеОПравеНаПенсиюТекст+") КАК Иностр
	|		ПО Иностр.Месяц = Доходы.Месяц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ("+УчетнаяПолитикаНалоговыйУчет+") КАК УчетнаяПолитикаНалоговыйУчетУСН
	|		ПО УчетнаяПолитикаНалоговыйУчетУСН.Месяц = Доходы.Месяц
	|
	|СГРУППИРОВАТЬ ПО Доходы.Месяц
	|";
	
	// ПоказателиНалогПоМесяцамТекст
	// Описание:
	//	Вычисляет показатели отчета, основанные на сведениях о налогах.
	//  Из по ЕСН автоматически отнимается налог, приходящийся  на налоговую льготу инвалидов.
	
	ПоказателиНалоговПоМесяцамТекст = 
	"ВЫБРАТЬ
	|	МЕСЯЦ(ЕСНИсчисленный.Период) КАК Месяц,
	|	ЕСНИсчисленный.ФедеральныйБюджетОборот КАК ИсчисленоФБ,
	|	ЕСНИсчисленный.ФССОборот КАК ИсчисленоФСС,
	|	ЕСНИсчисленный.ФФОМСОборот КАК ИсчисленоФФОМС,
	|	ЕСНИсчисленный.ТФОМСОборот КАК ИсчисленоТФОМС,
	|	ЕСНИсчисленный.ПримененнаяЛьготаФБОборот * (Ставки.ФедеральныйБюджетВПроцентах - Ставки.ПФРНакопительная1вПроцентах - Ставки.ПФРСтраховая1вПроцентах) / 100 КАК НеПодлежитФБ,
	|	ЕСНИсчисленный.ПримененнаяЛьготаФССОборот * Ставки.ФССвПроцентах / 100 КАК НеПодлежитФСС,
	|	ЕСНИсчисленный.ПримененнаяЛьготаФОМСОборот * Ставки.ФФОМСвПроцентах / 100 КАК НеПодлежитФФОМС,
	|	ЕСНИсчисленный.ПримененнаяЛьготаФОМСОборот * Ставки.ТФОМСвПроцентах / 100 КАК НеПодлежитТФОМС,
	|	ЕСНИсчисленный.ФедеральныйБюджетОборот - ЕСНИсчисленный.ПримененнаяЛьготаФБОборот * (Ставки.ФедеральныйБюджетВПроцентах - Ставки.ПФРНакопительная1вПроцентах - Ставки.ПФРСтраховая1вПроцентах) / 100 - ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL ТОГДА ЕСНИсчисленный.ПФРСтраховаяОборот - ЕСНИсчисленный.ПФРСтраховаяЕНВДОборот + ЕСНИсчисленный.ПФРНакопительнаяОборот - ЕСНИсчисленный.ПФРНакопительнаяЕНВДОборот ИНАЧЕ 0 КОНЕЦ КАК НачисленоФБ,
	|	ЕСНИсчисленный.ФССОборот - ЕСНИсчисленный.ПримененнаяЛьготаФССОборот * Ставки.ФССвПроцентах / 100 КАК НачисленоФСС,
	|	ЕСНИсчисленный.ФФОМСОборот - ЕСНИсчисленный.ПримененнаяЛьготаФОМСОборот * Ставки.ФФОМСвПроцентах / 100 КАК НачисленоФФОМС,
	|	ЕСНИсчисленный.ТФОМСОборот - ЕСНИсчисленный.ПримененнаяЛьготаФОМСОборот * Ставки.ТФОМСвПроцентах / 100 КАК НачисленоТФОМС,
	|	ЕСНИсчисленный.ПримененнаяЛьготаФБОборот КАК ПримененнаяЛьготаИнвалида,
	|	ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL ТОГДА ЕСНИсчисленный.ПФРНакопительнаяОборот - ЕСНИсчисленный.ПФРНакопительнаяЕНВДОборот ИНАЧЕ 0 КОНЕЦ КАК НачисленоПФРНакопительная,
	|	ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL ТОГДА ЕСНИсчисленный.ПФРСтраховаяОборот - ЕСНИсчисленный.ПФРСтраховаяЕНВДОборот ИНАЧЕ 0 КОНЕЦ КАК НачисленоПФРСтраховая,
	|	ВЫБОР КОГДА УчетнаяПолитикаНалоговыйУчетУСН.УСН ЕСТЬ NULL ТОГДА ЕСНИсчисленный.ПФРСтраховаяОборот - ЕСНИсчисленный.ПФРСтраховаяЕНВДОборот + ЕСНИсчисленный.ПФРНакопительнаяОборот - ЕСНИсчисленный.ПФРНакопительнаяЕНВДОборот ИНАЧЕ 0 КОНЕЦ КАК НачисленоПФР
	|ИЗ
	|	РегистрНакопления.ЕСНИсчисленный.Обороты(
	|		&НачалоНП,
	|		&КонецНП,
	|		Месяц,
	|		Организация = &ГоловнаяОрганизация
	|			И ФизЛицо = &ФизЛицо) КАК ЕСНИсчисленный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ("+УчетнаяПолитикаНалоговыйУчет+") КАК УчетнаяПолитикаНалоговыйУчетУСН
	|		ПО УчетнаяПолитикаНалоговыйУчетУСН.Месяц = МЕСЯЦ(ЕСНИсчисленный.Период)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОСтавкахЕСНиПФР КАК Ставки
	|		ПО (Ставки.ВидСтавокЕСНиПФР = &ВидСтавокЕСНиПФР)
	|			И (Ставки.Год = &ГодНП)
	|			И (Ставки.НомерСтрокиСтавок = 1)";
	
	//ДанныеРасчетаТекст
	// Описание: объединяет показатели доходов и налогов
	
	ДанныеРасчетаТекст = "
	|ВЫБРАТЬ 
	|	МесяцыНП.Месяц,
	|	ВЫБОР КОГДА ПоказателиДоходов.Месяц ЕСТЬ NULL И ПоказателиНалогов.Месяц ЕСТЬ NULL ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ КАК ЕстьСведения,
	|	ПоказателиДоходов.*,
	|	ПоказателиНалогов.*
	|
	|	ИЗ 
	|		(" + МесяцыНПТекст + ") КАК МесяцыНП
	|		ЛЕВОЕ СОЕДИНЕНИЕ  ( " + ПоказателиДоходовПоМесяцамТекст + " ) КАК ПоказателиДоходов
	|		ПО ПоказателиДоходов.Месяц = МесяцыНП.Месяц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ( " + ПоказателиНалоговПоМесяцамТекст + " ) КАК ПоказателиНалогов
	|		ПО ПоказателиНалогов.Месяц = МесяцыНП.Месяц
	|
	|УПОРЯДОЧИТЬ ПО
	|	МесяцыНП.Месяц
	|";
	
	
	//-----------------------------------------------------------------------------
	// ВЫПОЛНЕНИЕ ЗАПРОСОВ
	
	// Сведения о физлице
	Запрос.Текст = ДанныеОФизлицеТекст;
	ДанныеОФизЛице  = Запрос.Выполнить().Выбрать();
	ДанныеОФизЛице.Следующий();
	
	// Данные расчета
	Запрос.Текст = ДанныеРасчетаТекст;
	ДанныеРасчета  = Запрос.Выполнить().Выбрать();
	
	
	//-----------------------------------------------------------------------------
	// ЗАПОЛНЕНИЕ ФОРМЫ
	
	// Области макета
    ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМесяц = Макет.ПолучитьОбласть("Месяц");
	ОбластьПустойМесяц = Макет.ПолучитьОбласть("ПустойМесяц");
	
	// Вывод шапки отчета
	ОбластьШапка.Параметры.Заполнить(ДанныеОФизЛице);
	ОбластьШапка.Параметры.ДокументКемКогдаВыдан = СОКРЛП(ДанныеОФизЛице.ДокументКемКогдаВыдан);
	ОбластьШапка.Параметры.НалоговыйПериод = Формат(НалоговыйПериод,"ЧГ=");
	ОбластьШапка.Параметры.ДатаРождения = Формат(ДанныеОФизЛице.ДатаРождения,"ЧГ=; ДФ=dd.MM.yyyy");
	ОбластьШапка.Параметры.ДокументДатаВыдачи = Формат(ДанныеОФизЛице.ДокументДатаВыдачи,"ДФ=dd.MM.yyyy");
	Если СтрЗаменить(ДанныеОФизЛице.АдресФактический, ",","") = "" Тогда
		ОбластьШапка.Параметры.Адрес = РегламентированнаяОтчетность.ПредставлениеАдреса(ДанныеОФизЛице.АдресРегистрации);
	Иначе	
		ОбластьШапка.Параметры.Адрес = РегламентированнаяОтчетность.ПредставлениеАдреса(ДанныеОФизЛице.АдресФактический);	
	КонецЕсли; 
	Если ДанныеОФизЛице.ТрудовойДоговор Тогда
		ОбластьТекст = ОбластьШапка.Область("R7C10");
		ОбластьТекст.Шрифт = Новый Шрифт(ОбластьТекст.Шрифт,,,,,Истина);
	КонецЕсли;
	Если ДанныеОФизЛице.ДоговорПодряда Тогда
		ОбластьТекст = ОбластьШапка.Область("R7C11");
		ОбластьТекст.Шрифт = Новый Шрифт(ОбластьТекст.Шрифт,,,,,Истина);
	КонецЕсли;
	Если ДанныеОФизЛице.АвторскийДоговор Тогда
		ОбластьТекст = ОбластьШапка.Область("R7C13");
		ОбластьТекст.Шрифт = Новый Шрифт(ОбластьТекст.Шрифт,,,,,Истина);
	КонецЕсли;
	ДокументРезультат.Вывести(ОбластьШапка);
	
	// Вывод сведений о доходах и налогах по месяцам налогового периода
	
	// вычислим последний месяц, за который есть сведения
	ПоследнийМесяцРасчета = 0;
	ДанныеРасчета.Сбросить();
	Пока ДанныеРасчета.Следующий() Цикл
		Если ДанныеРасчета.ЕстьСведения Тогда
			ПоследнийМесяцРасчета = ДанныеРасчета.Месяц;
		КонецЕсли; 
	КонецЦикла;	
	
	// создадим структуру для хранения нарастающих данных
	МесячныеПоказатели = Новый Структура("НачисленоВсего, ВыплатыЗаСчетПрибыли, НеОблагаетсяПоСт238КромеДоговоров, ВыплатыПоДоговорам, НалоговаяБазаФБ, НалоговаяБазаФСС, БазаПФР, ПримененнаяЛьготаИнвалида, ПособияЗаСчетФСС, НачисленоФБ, НачисленоФФОМС, НачисленоТФОМС, НачисленоФСС, ИсчисленоФБ, ИсчисленоФФОМС, ИсчисленоТФОМС, ИсчисленоФСС, НеПодлежитФБ, НеПодлежитФФОМС, НеПодлежитТФОМС, НеПодлежитФСС, НачисленоПФРНакопительная, НачисленоПФРСтраховая,НачисленоПФР");
	НарастающиеИтоги = Новый Структура;
	Для Каждого Поле из МесячныеПоказатели  Цикл
		НарастающиеИтоги.Вставить("Нараст" + Поле.Ключ, 0);
	КонецЦикла;	
	
	ДанныеРасчета.Сбросить();
	Пока ДанныеРасчета.Следующий() Цикл
		Месяц = ДанныеРасчета.Месяц;
		
		Если Месяц <= ПоследнийМесяцРасчета Тогда
			
			ОбластьМесяц.Параметры.Заполнить(ДанныеРасчета);
			ОбластьМесяц.Параметры.Месяц = Формат(Дата(НалоговыйПериод,Месяц,1),"ДФ=ММММ");
			
			// Расчет нарастающих сумм с начала года
			Для Каждого Поле из МесячныеПоказатели  Цикл
				НарастающиеИтоги["Нараст"+Поле.Ключ] = НарастающиеИтоги["Нараст"+Поле.Ключ] + ПараметрВЧисло(ОбластьМесяц.Параметры[Поле.Ключ]);
			КонецЦикла; 
			
			ОбластьМесяц.Параметры.Заполнить(НарастающиеИтоги);
			
			// проставим в расшифровки название области, для того чтоб потом понять что нам надо расшифровывать 
			Для Каждого Область Из ОбластьМесяц.Области Цикл
				Если Область.Имя = "Месяц" Или Найти(Область.Имя, "R") > 0 Тогда 
					Продолжить
				Иначе
					ОбластьМесяц.Области[Область.Имя].Расшифровка = Новый Структура("Имя,Месяц",Область.Имя,Месяц);
				КонецЕсли;
			КонецЦикла;					
			
			// Выведем месяц
			ДокументРезультат.Вывести(ОбластьМесяц);
			
		Иначе	
			// Выведем пустой месяц
			ОбластьПустойМесяц.Параметры.Месяц = Формат(Дата(НалоговыйПериод,Месяц,1),"ДФ=ММММ");
			ДокументРезультат.Вывести(ОбластьПустойМесяц);
		КонецЕсли; 
	КонецЦикла; 
	
	//-----------------------------------------------------------------------------

	//Параметры документа
	ДокументРезультат.Автомасштаб 			= 	Истина;
	ДокументРезультат.ОриентацияСтраницы 	= 	ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ТолькоПросмотр		= 	Истина;
	
КонецПроцедуры


#КонецЕсли

