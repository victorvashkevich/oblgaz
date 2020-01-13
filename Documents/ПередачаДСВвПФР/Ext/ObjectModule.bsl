﻿
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// заполняет данные по физлицу
//
Процедура ЗаполнитьДанныеПоФизЛицу(ФизЛицо, СтрокаТабличнойЧасти) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизЛицо",			ФизЛицо);
	Запрос.УстановитьПараметр("ДатаАктуальности" , 	Дата);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФИОФизЛицСрезПоследних.Фамилия КАК Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя КАК Имя,
	|	ФИОФизЛицСрезПоследних.Отчество КАК Отчество,
	|	ФизическиеЛица.СтраховойНомерПФР,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА "","" + АдресаДляИнформирования.Поле1 + "","" + АдресаДляИнформирования.Поле2 + "","" + АдресаДляИнформирования.Поле3 + "","" + АдресаДляИнформирования.Поле4 + "","" + АдресаДляИнформирования.Поле5 + "","" + АдресаДляИнформирования.Поле6 + "","" + АдресаДляИнформирования.Поле7 + "","" + АдресаДляИнформирования.Поле8 + "","" + АдресаДляИнформирования.Поле9
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА "","" + АдресаФактические.Поле1 + "","" + АдресаФактические.Поле2 + "","" + АдресаФактические.Поле3 + "","" + АдресаФактические.Поле4 + "","" + АдресаФактические.Поле5 + "","" + АдресаФактические.Поле6 + "","" + АдресаФактические.Поле7 + "","" + АдресаФактические.Поле8 + "","" + АдресаФактические.Поле9
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА "","" + АдресаРегистрации.Поле1 + "","" + АдресаРегистрации.Поле2 + "","" + АдресаРегистрации.Поле3 + "","" + АдресаРегистрации.Поле4 + "","" + АдресаРегистрации.Поле5 + "","" + АдресаРегистрации.Поле6 + "","" + АдресаРегистрации.Поле7 + "","" + АдресаРегистрации.Поле8 + "","" + АдресаРегистрации.Поле9
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК АдресДляИнформирования,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Представление
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Представление
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Представление
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Представление,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле1
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле1
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле1
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле1,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле2
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле2
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле2
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле2,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле3
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле3
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле3
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле3,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле4
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле4
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле4
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле4,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле5
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле5
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле5
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле5,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле6
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле6
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле6
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле6,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле7
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле7
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле7
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле7,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле8
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле8
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле8
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле8,
	|	ВЫБОР
	|		КОГДА АдресаДляИнформирования.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаДляИнформирования.Поле9
	|		КОГДА АдресаФактические.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаФактические.Поле9
	|		КОГДА АдресаРегистрации.Поле1 ЕСТЬ НЕ NULL 
	|			ТОГДА АдресаРегистрации.Поле9
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Поле9
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресаФактические
	|		ПО ФизическиеЛица.Ссылка = АдресаФактические.Объект
	|			И (АдресаФактические.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресФизЛица))
	|			И (АдресаФактические.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресаРегистрации
	|		ПО ФизическиеЛица.Ссылка = АдресаРегистрации.Объект
	|			И (АдресаРегистрации.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресФизЛица))
	|			И (АдресаРегистрации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК АдресаДляИнформирования
	|		ПО ФизическиеЛица.Ссылка = АдресаДляИнформирования.Объект
	|			И (АдресаДляИнформирования.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ИнформАдресФизЛица))
	|			И (АдресаДляИнформирования.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаАктуальности, ФизЛицо = &ФизЛицо) КАК ФИОФизЛицСрезПоследних
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ФизЛицо";
				   
	ВыборкаПоРаботнику = Запрос.Выполнить().Выбрать();

	Если ВыборкаПоРаботнику.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаПоРаботнику);
		Если ВРег(УправлениеКонтактнойИнформацией.ПолучитьПредставлениеАдреса(ВыборкаПоРаботнику)) <> ВРЕГ(ВыборкаПоРаботнику.Представление) Тогда
			СтрокаТабличнойЧасти.АдресДляИнформирования = ВыборкаПоРаботнику.Представление;
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура();

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Формирует файл, который можно будет записать на дискетку
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Строка - содержимое файла
//
Функция СформироватьВыходнойФайл(Отказ) Экспорт

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();
	Если Не ВыборкаПоШапкеДокумента.Следующий() Тогда
		Отказ = Истина;
		Возврат "";
	КонецЕсли;	

	ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
	Если Отказ Тогда
		Возврат "";
	КонецЕсли;	 

	ВыборкаПоРаботникиОрганизации =	СформироватьЗапросПоРаботникиОрганизации().Выбрать(ОбходРезультатаЗапроса.Прямой);

	СписокОбработанныхЗаявлений = Новый Соответствие;
	
	ТекстФайла	=	"";
	НомерДокументаВПачке = 0;

	ДатаЗаполнения 			= ВыборкаПоШапкеДокумента.Дата;
	НомерПачки 				= "";
	КоличествоДокументов 	= ВыборкаПоРаботникиОрганизации.Количество();

	// Список стран
	СписокСтран = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторСтранМира.Наименование,
	|	КлассификаторСтранМира.Код
	|ИЗ
	|	Справочник.КлассификаторСтранМира КАК КлассификаторСтранМира";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокСтран.Вставить(СокрЛП(Выборка.Наименование), Строка(Выборка.Код));
	КонецЦикла;
	
	НомерДокументаВПачке = 1;
	// Загружаем формат файла сведений
	МакетФормата = ПолучитьОбщийМакет("ФорматПФР70");
	
	// Создаем начальное дерево
	ДеревоВыгрузки = ПроцедурыПерсонифицированогоУчета.СоздатьДеревоXML();
	
	УзелПФР = ПроцедурыПерсонифицированогоУчета.ДобавитьУзелВДеревоXML(ДеревоВыгрузки, "ФайлПФР", "", );
	
	ПроцедурыПерсонифицированогоУчета.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, МакетФормата, ПроцедурыПерсонифицированогоУчета.ПолучитьИмяФайлаПФ(Ссылка, Год(ДатаЗаполнения), ВыборкаПоШапкеДокумента));
	
	// Добавляем реквизит ПачкаВходящихДокументов
	УзелПачкаВходящихДокументов = ПроцедурыПерсонифицированогоУчета.ЗаполнитьНаборЗаписейВходящаяОпись(УзелПФР, МакетФормата, "ЗАЯВЛЕНИЕ_О_ДОБРОВОЛЬНОМ_ВСТУПЛЕНИИ_В_ПРАВООТНОШЕНИЯ_В_ЦЕЛЯХ_УПЛАТЫ_ДСВ", ВыборкаПоШапкеДокумента, КоличествоДокументов, НомерПачки, НомерДокументаВПачке);
	
	Сокращение = "";
	
	ФорматЗаявлениеДСВ = ПроцедурыПерсонифицированогоУчета.ЗагрузитьФорматНабораЗаписейдляПФР(МакетФормата, "ЗАЯВЛЕНИЕ_О_ДОБРОВОЛЬНОМ_ВСТУПЛЕНИИ_В_ПРАВООТНОШЕНИЯ_В_ЦЕЛЯХ_УПЛАТЫ_ДСВ");
	
	ФорматИностранныйАдрес = ПроцедурыПерсонифицированогоУчета.ЗагрузитьФорматНабораЗаписейдляПФР(МакетФормата, "АдресОбщий", 3);
	ФорматНеструктурированныйАдрес = ПроцедурыПерсонифицированогоУчета.ЗагрузитьФорматНабораЗаписейдляПФР(МакетФормата, "АдресОбщий", 2);
	
	Пока ВыборкаПоРаботникиОрганизации.Следующий()	Цикл
		
		//Контроль дубля строк
		Если СписокОбработанныхЗаявлений.Получить(ВыборкаПоРаботникиОрганизации.ФизЛицо) = Неопределено Тогда
			СписокОбработанныхЗаявлений.Вставить(ВыборкаПоРаботникиОрганизации.ФизЛицо, Истина);
		Иначе	
			ОбщегоНазначения.СообщитьОбОшибке("Строка №" + ВыборкаПоРаботникиОрганизации.НомерСтроки + ": Работник " + ВыборкаПоРаботникиОрганизации.ФизЛицоНаименование + " указан(а) в документе дважды!", Отказ, Заголовок);
		КонецЕсли;	 
		
		ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоРаботникиОрганизации, Отказ ,Заголовок);
		
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		НомерДокументаВПачке = 	НомерДокументаВПачке + 1;
		
		НаборЗаписейЗаявлениеДСВ = ПроцедурыПерсонифицированогоУчета.СкопироватьСтруктуруДанных(ФорматЗаявлениеДСВ);
		
		НаборЗаписейЗаявлениеДСВ.НомерВпачке.Значение = НомерДокументаВПачке;
		НаборЗаписейЗаявлениеДСВ.СтраховойНомер.Значение = ВыборкаПоРаботникиОрганизации.СтраховойНомерПФР;
		НаборЗаписейФИО = НаборЗаписейЗаявлениеДСВ.ФИО.Значение;
		НаборЗаписейФИО.Фамилия = ВРег(ВыборкаПоРаботникиОрганизации.Фамилия);
		ПроцедурыПерсонифицированогоУчета.ЗаменитьБуквуЁ(НаборЗаписейФИО.Фамилия, "Фамилия");
		НаборЗаписейФИО.Имя = ВРег(ВыборкаПоРаботникиОрганизации.Имя);
		ПроцедурыПерсонифицированогоУчета.ЗаменитьБуквуЁ(НаборЗаписейФИО.Имя, "Имя");
		НаборЗаписейФИО.Отчество = ВРег(ВыборкаПоРаботникиОрганизации.Отчество);
		ПроцедурыПерсонифицированогоУчета.ЗаменитьБуквуЁ(НаборЗаписейФИО.Отчество, "Отчество");
		Если ПустаяСтрока(ВыборкаПоРаботникиОрганизации.АдресДляИнформирования) Тогда
			НаборЗаписейЗаявлениеДСВ.Удалить("АдресРегистрации");
		Иначе
			ТекстОшибки  ="";
			НаборЗаписейАдресМестаЖительства = НаборЗаписейЗаявлениеДСВ.АдресМестаЖительства.Значение;
			ПроцедурыПерсонифицированогоУчета.ЗаполнитьАдрес(НаборЗаписейАдресМестаЖительства, ВыборкаПоРаботникиОрганизации.АдресДляИнформирования, 
			СписокСтран,ФорматНеструктурированныйАдрес, ФорматИностранныйАдрес, ТекстОшибки);
			НаборЗаписейЗаявлениеДСВ.АдресМестаЖительства.Значение = НаборЗаписейАдресМестаЖительства;
			Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Предупреждение: Строка №" + ВыборкаПоРаботникиОрганизации.НомерСтроки + ": Работник " + ВыборкаПоРаботникиОрганизации.ФизЛицоНаименование + " Адрес регистрации" + ТекстОшибки, Ложь, Заголовок);
			КонецЕсли;
		КонецЕсли;
		
		НаборЗаписейЗаявлениеДСВ.НаименованиеТерриториальногоОрганаПФР.Значение = ВРег(СокрЛП(ВыборкаПоШапкеДокумента.НаименованиеТерриториальногоОрганаПФР));
		НаборЗаписейЗаявлениеДСВ.ДатаЗаполнения.Значение = ДатаЗаполнения;
		
		ПроцедурыПерсонифицированогоУчета.ДобавитьИнформациюВДерево(ПроцедурыПерсонифицированогоУчета.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "ЗАЯВЛЕНИЕ_О_ДОБРОВОЛЬНОМ_ВСТУПЛЕНИИ_В_ПРАВООТНОШЕНИЯ_В_ЦЕЛЯХ_УПЛАТЫ_ДСВ",""), НаборЗаписейЗаявлениеДСВ);
		
	КонецЦикла;
	
	// Преобразуем дерево в строковое описание XML
	ТекстФайла = ПроцедурыПерсонифицированогоУчета.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки,  "Окружение=""В составе файла"" Стадия=""До обработки"" ДобровольныеПравоотношения=""ДСВ""");
	
	Возврат ТекстФайла;
	
КонецФункции // СформироватьВыходнойФайл()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("парамПустаяОрганизация", Справочники.Организации.ПустаяСсылка());

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Дата,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Номер,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Ссылка,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.Код,
	|	ВЫБОР
	|		КОГДА ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.ГоловнаяОрганизация = &парамПустаяОрганизация
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоГоловнаяОрганизация,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ФорматФайлаПФР.Версия07) КАК ФорматФайла,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.РегистрационныйНомерПФР,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.Наименование,
	|	ВЫРАЗИТЬ(ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.НаименованиеПолное КАК СТРОКА(300)) КАК ОрганизацияНаименованиеПолное,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.ИНН,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.КПП,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.ЮрФизЛицо,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.ОГРН,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.НаименованиеОКОПФ,
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Организация.НаименованиеТерриториальногоОрганаПФР КАК НаименованиеТерриториальногоОрганаПФР
	|ИЗ
	|	Документ.ПередачаДСВвПФР КАК ЗаявлениеОДобровольныхСтраховыхВзносах
	|ГДЕ
	|	ЗаявлениеОДобровольныхСтраховыхВзносах.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Выбирает данные, необходимые для заполнения утвержденных форм как из спр-ка
//  физлиц, так и из соотв. регистров сведений
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоРаботникиОрганизации()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заявления.Ссылка КАК Ссылка,
	|	Заявления.НомерСтроки КАК НомерСтроки,
	|	Заявления.ФизЛицо КАК ФизЛицо,
	|	Заявления.АдресДляИнформирования КАК АдресДляИнформирования,
	|	Заявления.Фамилия КАК Фамилия,
	|	Заявления.Имя КАК Имя,
	|	Заявления.Отчество КАК Отчество,
	|	Заявления.ФизЛицо.Наименование КАК ФизЛицоНаименование,
	|	Заявления.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	Заявления.ДатаЗаполнения
	|ПОМЕСТИТЬ ВТДанныеЗаявлений
	|ИЗ
	|	Документ.ПередачаДСВвПФР.РаботникиОрганизации КАК Заявления
	|ГДЕ
	|	Заявления.Ссылка = &ДокументСсылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо";
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заявления.Ссылка КАК Ссылка,
	|	Заявления.НомерСтроки КАК НомерСтроки,
	|	Заявления.ФизЛицо КАК ФизЛицо,
	|	Заявления.АдресДляИнформирования КАК АдресДляИнформирования,
	|	Заявления.Фамилия КАК Фамилия,
	|	Заявления.Имя КАК Имя,
	|	Заявления.Отчество КАК Отчество,
	|	Заявления.ФизЛицоНаименование,
	|	Заявления.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	Заявления.ДатаЗаполнения,
	|	МИНИМУМ(ПовторяющиесяСтроки.НомерСтроки) КАК НомерКонфликтнойСтроки
	|ИЗ
	|	ВТДанныеЗаявлений КАК Заявления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеЗаявлений КАК ПовторяющиесяСтроки
	|		ПО Заявления.ФизЛицо = ПовторяющиесяСтроки.ФизЛицо
	|			И Заявления.НомерСтроки < ПовторяющиесяСтроки.НомерСтроки
	|
	|СГРУППИРОВАТЬ ПО
	|	Заявления.Ссылка,
	|	Заявления.НомерСтроки,
	|	Заявления.ФизЛицо,
	|	Заявления.АдресДляИнформирования,
	|	Заявления.Фамилия,
	|	Заявления.Имя,
	|	Заявления.Отчество,
	|	Заявления.ФизЛицоНаименование,
	|	Заявления.СтраховойНомерПФР,
	|	Заявления.ДатаЗаполнения";
		
	Возврат Запрос.Выполнить();
	
КонецФункции

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
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

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация, которая подает сведения!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по работникам, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоСтрокамДокумента, Отказ ,Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке № "+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + " табл. части: ";
	
	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не выбран работник!", Отказ ,Заголовок);
	Иначе	
		
		СтрокаНачалаСообщенияОбОшибке = СтрокаНачалаСообщенияОбОшибке + " по работнику " + ВыборкаПоСтрокамДокумента.ФизЛицоНаименование + " ";
		
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Фамилия) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не задана фамилия!", Отказ ,Заголовок);
		КонецЕсли;	
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Имя) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не задано имя!", Отказ ,Заголовок);
		КонецЕсли;	
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаЗаполнения) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не указана дата заполнения заявления!", Отказ ,Заголовок);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.НомерКонфликтнойСтроки) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Указанный работник повторяется в строке " + ВыборкаПоСтрокамДокумента.НомерКонфликтнойСтроки + "!", Отказ ,Заголовок);
		КонецЕсли;
	КонецЕсли;

	// Проверка адреса регистрации и проживания
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.АдресДляИнформирования) Тогда
		
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не задан адрес места жительства!", Отказ ,Заголовок);
		
	Иначе
		
		АдресДляИнформированияСписком = УправлениеКонтактнойИнформацией.ПолучитьСтруктуруАдресаИзСтроки(ВыборкаПоСтрокамДокумента.АдресДляИнформирования);
		ЗаПределамиРФ = Ложь;
		АдресДляИнформированияСписком.Свойство("ЗаПределамиРФ", ЗаПределамиРФ);
		// значение переменной ЗаПределамиРФ может быть Неопределено
		Если ЗаПределамиРФ <> Истина Тогда
			Если  РегламентированнаяОтчетность.АдресСоответствуетТребованиям(АдресДляИнформированияСписком) Тогда
				ТекстОшибки = ПроцедурыПерсонифицированогоУчета.ПроверитьАдресПоКЛАДР(АдресДляИнформированияСписком);
				Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
					ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Адрес места жительства не соответствует адресному классификатору: в классификаторе не найден" + ТекстОшибки + "!", , Заголовок);
				КонецЕсли;
			Иначе
				ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Адрес места жительства заполнен не полностью или неверно или присутствуют латинские или недопустимые символы!", Отказ ,Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
	СтраховойНомерПФР = ВыборкаПоСтрокамДокумента.СтраховойНомерПФР;
	Если ЗначениеЗаполнено(СтраховойНомерПФР) И Не РегламентированнаяОтчетность.СтраховойНомерПФРСоответствуетТребованиям(СтраховойНомерПФР) тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Задан неверный страховой номер!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		Если Отказ Тогда
			Возврат;
		КонецЕсли;	 
		
	КонецЕсли;
	
	//При проведении файл формируем заново 
	ТекстФайла = СформироватьВыходнойФайл(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	 

	//Сохраним сформированный файл сведений в регистре сведений
	Запись = Движения.АрхивДанныхРегламентированнойОтчетности.Добавить();
	Запись.Объект = Ссылка;
	Запись.ОписаниеДанных = "Файл-пачка форм ДСВ-1";
	Запись.Данные = ТекстФайла;
	
КонецПроцедуры	

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации,, "Физлицо");
	//Если ФорматФайла.Пустая() Тогда
		ФорматФайла = Перечисления.ФорматФайлаПФР.Версия07
	//КонецЕсли;
	
КонецПроцедуры



