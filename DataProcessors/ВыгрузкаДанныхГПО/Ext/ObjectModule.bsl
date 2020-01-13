﻿//****************************************************
Функция СформироватьЗапросПоСотрудникам()
	
	Запрос=Новый Запрос;
	
	Запрос.УстановитьПараметр("ОсновноеМесто",Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы);
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("ДатаАктуальности",ДатаВыгрузки);
	
	Запрос.УстановитьПараметр("ВБраке",Справочники.СемейноеПоложениеФизЛиц.НайтиПоНаименованию("Состоит в зарегистрированном браке"));
	Запрос.УстановитьПараметр("ВдоваВдовец",Справочники.СемейноеПоложениеФизЛиц.НайтиПоНаименованию("Вдовец (вдова)"));
	Запрос.УстановитьПараметр("ХолостНеЗамужем",Справочники.СемейноеПоложениеФизЛиц.НайтиПоНаименованию("Никогда не состоял (не состояла в браке)"));
	Запрос.УстановитьПараметр("РазведенРазведена",Справочники.СемейноеПоложениеФизЛиц.НайтиПоНаименованию("Разведен (разведена)"));
	
	Запрос.УстановитьПараметр("Паспорт",Справочники.ДокументыУдостоверяющиеЛичность.НайтиПоНаименованию("Паспорт"));
	Запрос.УстановитьПараметр("ВидНаЖительство",Справочники.ДокументыУдостоверяющиеЛичность.НайтиПоНаименованию("Вид на жительство гражданина иностранного государства или лица без гражданства"));
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	СотрудникиОрганизаций.Ссылка,
	|	СотрудникиОрганизаций.Код КАК ТабельныйНомер,
	|	СотрудникиОрганизаций.Физлицо КАК ФизЛицо,
	|	ФИОФизЛицСрезПоследних.Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя,
	|	ФИОФизЛицСрезПоследних.Отчество,
	|	ГражданствоФизЛицСрезПоследних.Страна.Наименование КАК Гражданство,
	|	СотрудникиОрганизаций.ТекущееОбособленноеПодразделение.Наименование КАК Организация,
	|	СотрудникиОрганизаций.ТекущееОбособленноеПодразделение.Код КАК КодОрганизации,
	|	СотрудникиОрганизаций.Код,
	|	ЕСТЬNULL(РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации.Наименование, """") КАК Подразделение,
	|	РаботникиОрганизацийСрезПоследних.Должность.Наименование КАК Должность,
	|	ВЫБОР
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &ВБраке
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Мужской)
	|			ТОГДА ""Женат""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &ВБраке
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Женский)
	|			ТОГДА ""Замужем""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &ВдоваВдовец
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Женский)
	|			ТОГДА ""Вдова""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &ВдоваВдовец
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Мужской)
	|			ТОГДА ""Вдовец""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &ХолостНеЗамужем
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Мужской)
	|			ТОГДА ""Холост""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &ХолостНеЗамужем
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Женский)
	|			ТОГДА ""Не замужем""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &РазведенРазведена
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Мужской)
	|			ТОГДА ""Разведен""
	|		КОГДА СемейноеПоложениеФизЛицСрезПоследних.СемейноеПоложение = &РазведенРазведена
	|				И СотрудникиОрганизаций.Физлицо.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическихЛиц.Женский)
	|			ТОГДА ""Разведена""
	|		ИНАЧЕ ""Холост""
	|	КОНЕЦ КАК СемейноеПоложение,
	|	СотрудникиОрганизаций.Физлицо.ДатаРождения КАК ДатаРождения,
	|	СотрудникиОрганизаций.Физлицо.Пол КАК Пол,
	|	ВЫБОР
	|		КОГДА ПаспортныеДанныеФизЛицСрезПоследних.ДокументВид = &Паспорт
	|			ТОГДА ""Паспорт""
	|		КОГДА ПаспортныеДанныеФизЛицСрезПоследних.ДокументВид = &ВидНаЖительство
	|			ТОГДА ""Вид на жительство""
	|	КОНЕЦ КАК ДокументВид,
	|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументСерия,
	|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументНомер,
	|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументКемВыдан,
	|	ПаспортныеДанныеФизЛицСрезПоследних.ЛичныйНомер,
	|	ПаспортныеДанныеФизЛицСрезПоследних.ДокументСрокДействия,
	|	ВоинскийУчетСрезПоследних.КатегорияЗапаса,
	|	ВоинскийУчетСрезПоследних.Звание.Наименование КАК Звание,
	|	ВоинскийУчетСрезПоследних.Состав.Наименование КАК Состав,
	|	ЕСТЬNULL(ВоинскийУчетСрезПоследних.НаличиеМобпредписания, ЛОЖЬ) КАК НаличиеМобПредписания,
	|	ВоинскийУчетСрезПоследних.ВУС,
	|	ВоинскийУчетСрезПоследних.Военкомат.Наименование КАК Военкомат,
	|	ЕСТЬNULL(ВоинскийУчетСрезПоследних.НомерВоенногоБилета, """") КАК НомерВоенногоБилета,
	|	ВЫБОР
	|		КОГДА ВоинскийУчетСрезПоследних.Годность = ЗНАЧЕНИЕ(Перечисление.ГодностьКВоеннойСлужбе.Годен)
	|			ТОГДА ""Годен к строевой службе""
	|		КОГДА ВоинскийУчетСрезПоследних.Годность = ЗНАЧЕНИЕ(Перечисление.ГодностьКВоеннойСлужбе.ГоденСОграничениями)
	|			ТОГДА ""Огранич. годен в воен. вр""
	|		КОГДА ВоинскийУчетСрезПоследних.Годность = ЗНАЧЕНИЕ(Перечисление.ГодностьКВоеннойСлужбе.ОграниченноГоден)
	|			ТОГДА ""Не годен в мирное время""
	|		КОГДА ВоинскийУчетСрезПоследних.Годность = ЗНАЧЕНИЕ(Перечисление.ГодностьКВоеннойСлужбе.ВременноНеГоден)
	|			ТОГДА ""Снят с учета""
	|		КОГДА ВоинскийУчетСрезПоследних.Годность = ЗНАЧЕНИЕ(Перечисление.ГодностьКВоеннойСлужбе.НеГоден)
	|			ТОГДА ""нестроевая""
	|		ИНАЧЕ ""Не военнообязанный""
	|	КОНЕЦ КАК Годность,
	|	ВоинскийУчетСрезПоследних.ГруппаВоинскогоУчета КАК ГруппаВоинскогоУчета,
	|	ВЫБОР
	|		КОГДА ВоинскийУчетСрезПоследних.КатегорияЗапаса = ЗНАЧЕНИЕ(Перечисление.КатегорииЗапасаВоеннообязанных.До45лет)
	|			ТОГДА 1
	|		КОГДА ВоинскийУчетСрезПоследних.КатегорияЗапаса = ЗНАЧЕНИЕ(Перечисление.КатегорииЗапасаВоеннообязанных.До50лет)
	|			ТОГДА 2
	|		КОГДА ВоинскийУчетСрезПоследних.КатегорияЗапаса = ЗНАЧЕНИЕ(Перечисление.КатегорииЗапасаВоеннообязанных.До55лет)
	|			ТОГДА 3
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК КатегорияВоинскогоУчета,
	|	СотрудникиОрганизаций.ДатаПриемаНаРаботу,
	|	СотрудникиОрганизаций.Физлицо.МестоРождения КАК МестоРождения,
	|	КонтактнаяИнформация.Представление КАК ТелефонРабочий,
	|	КонтактнаяИнформация6.Представление КАК ТелефонРабочийМобильный,
	|	КонтактнаяИнформация1.Представление КАК ТелефонМобильный,
	|	КонтактнаяИнформация2.Представление КАК ТелефонДомашний,
	|	КонтактнаяИнформация3.Представление КАК АдресПрописки,
	|	КонтактнаяИнформация5.Представление КАК ЕМэйл,
	|	СотрудникиОрганизаций.ВидТД КАК ВидДоговора,
	|	СотрудникиОрганизаций.НомерДоговора,
	|	СотрудникиОрганизаций.ДатаНачала,
	|	СотрудникиОрганизаций.ДатаОкончания,
	|	ЕСТЬNULL(КонтактнаяИнформация4.Представление, КонтактнаяИнформация3.Представление) КАК АдресПроживания,
	|	ФизическиеЛицаСтажи.ДатаОтсчета КАК ОбщийСтаж
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаАктуальности, ) КАК ФИОФизЛицСрезПоследних
	|		ПО СотрудникиОрганизаций.Физлицо = ФИОФизЛицСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГражданствоФизЛиц.СрезПоследних(&ДатаАктуальности, ) КАК ГражданствоФизЛицСрезПоследних
	|		ПО СотрудникиОрганизаций.Физлицо = ГражданствоФизЛицСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности, ) КАК РаботникиОрганизацийСрезПоследних
	|		ПО СотрудникиОрганизаций.Ссылка = РаботникиОрганизацийСрезПоследних.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СемейноеПоложениеФизЛиц.СрезПоследних(&ДатаАктуальности, ) КАК СемейноеПоложениеФизЛицСрезПоследних
	|		ПО СотрудникиОрганизаций.Физлицо = СемейноеПоложениеФизЛицСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПаспортныеДанныеФизЛиц.СрезПоследних(&ДатаАктуальности, ) КАК ПаспортныеДанныеФизЛицСрезПоследних
	|		ПО СотрудникиОрганизаций.Физлицо = ПаспортныеДанныеФизЛицСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВоинскийУчет.СрезПоследних(&ДатаАктуальности, ) КАК ВоинскийУчетСрезПоследних
	|		ПО СотрудникиОрганизаций.Физлицо = ВоинскийУчетСрезПоследних.Физлицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация.Объект
	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон))
	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация6
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация6.Объект
	|			И (КонтактнаяИнформация6.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон))
	|			И (КонтактнаяИнформация6.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебныйМобильный))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация1
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация1.Объект
	|			И (КонтактнаяИнформация1.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон))
	|			И (КонтактнаяИнформация1.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонМобильный))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация2
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация2.Объект
	|			И (КонтактнаяИнформация2.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон))
	|			И (КонтактнаяИнформация2.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонФизЛица))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация3
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация3.Объект
	|			И (КонтактнаяИнформация3.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|			И (КонтактнаяИнформация3.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресФизЛица))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация4
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация4.Объект
	|			И (КонтактнаяИнформация4.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|			И (КонтактнаяИнформация4.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресФизЛица))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация5
	|		ПО СотрудникиОрганизаций.Физлицо = КонтактнаяИнформация5.Объект
	|			И (КонтактнаяИнформация5.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
	|			И (КонтактнаяИнформация5.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочты))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.Стажи КАК ФизическиеЛицаСтажи
	|		ПО СотрудникиОрганизаций.Физлицо = ФизическиеЛицаСтажи.Ссылка.Ссылка
	|		И ФизическиеЛицаСтажи.ВидСтажа=ЗНАЧЕНИЕ(Справочник.ВидыСтажа.ОбщийСтаж)
	|ГДЕ
	|	НЕ СотрудникиОрганизаций.ЭтоГруппа
	|	И СотрудникиОрганизаций.ТекущееОбособленноеПодразделение=&Организация
	|	И СотрудникиОрганизаций.ВидЗанятости = &ОсновноеМесто";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции
//****************************************************
Функция СформироватьСоставСемьи()
	
	Запрос=Новый Запрос;
	
	Запрос.УстановитьПараметр("Дочь",Справочники.СтепениРодстваФизЛиц.НайтиПоНаименованию("Дочь"));
	Запрос.УстановитьПараметр("Сын",Справочники.СтепениРодстваФизЛиц.НайтиПоНаименованию("Сын"));
	Запрос.УстановитьПараметр("Муж",Справочники.СтепениРодстваФизЛиц.НайтиПоНаименованию("Муж"));
	Запрос.УстановитьПараметр("Жена",Справочники.СтепениРодстваФизЛиц.НайтиПоНаименованию("Жена"));
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ФизическиеЛицаСоставСемьи.Имя,
	|	ФизическиеЛицаСоставСемьи.ГодРождения,
	|	ВЫБОР 
	|		КОГДА ФизическиеЛицаСоставСемьи.СтепеньРодства=&Дочь ТОГДА ""d""
	|		КОГДА ФизическиеЛицаСоставСемьи.СтепеньРодства=&Сын ТОГДА ""s""
	|		КОГДА ФизическиеЛицаСоставСемьи.СтепеньРодства=&Муж ТОГДА ""h""
	|		КОГДА ФизическиеЛицаСоставСемьи.СтепеньРодства=&Жена ТОГДА ""w""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК СтепеньРодства,	
	|	ФизическиеЛицаСоставСемьи.Ссылка КАК ФизЛицо
	|ИЗ
	|	Справочник.ФизическиеЛица.СоставСемьи КАК ФизическиеЛицаСоставСемьи";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
//****************************************************
Функция СформироватьОбразование()
	
	Запрос=Новый Запрос;
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ФизическиеЛицаОбразование.Ссылка КАК ФизЛицо,
	|	ФизическиеЛицаОбразование.ДатаОкончания,
	|	ФизическиеЛицаОбразование.УчебноеЗаведение,
	|	ФизическиеЛицаОбразование.Специальность,
	|	ФизическиеЛицаОбразование.Квалификация,
	|	ФизическиеЛицаОбразование.Диплом КАК НомерДиплома,
	|	ВЫБОР 
	|		КОГДА ФизическиеЛицаОбразование.ВидОбразования=ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизЛиц.ВысшееОбразование) ТОГДА ""Высшее""
	|		КОГДА ФизическиеЛицаОбразование.ВидОбразования=ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизЛиц.СреднееПрофессиональноеОбразование) ТОГДА ""Cреднее специальное""
	|		КОГДА ФизическиеЛицаОбразование.ВидОбразования=ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизЛиц.НачальноеПрофессиональноеОбразование) ТОГДА ""Профессионально-техническое""
	|		КОГДА ФизическиеЛицаОбразование.ВидОбразования=ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизЛиц.СреднееПолноеОбщееОбразование) ТОГДА ""Общее cреднее""
	|		КОГДА ФизическиеЛицаОбразование.ВидОбразования=ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизЛиц.ОбщееБазовое) ТОГДА ""Общее базовое""
	|	ИНАЧЕ 
	|		""""
	|	КОНЕЦ КАК ВидОбразования,
	|	ФизическиеЛицаОбразование.ОсновноеОбразование
	|ИЗ
	|	Справочник.ФизическиеЛица.Образование КАК ФизическиеЛицаОбразование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
//****************************************************
Функция СформироватьПовышениеКвалификации()
	
	Запрос=Новый Запрос;
	Запрос.Текст=	
	"ВЫБРАТЬ
	|	ПройденныеУчебныеКурсы.Физлицо,
	|	ПройденныеУчебныеКурсы.УчебноеЗаведение,
	|	ПройденныеУчебныеКурсы.КурсОбучения,
	|	ПройденныеУчебныеКурсы.ДатаНачала,
	|	ПройденныеУчебныеКурсы.Период КАК ДатаОкончания
	|ИЗ
	|	РегистрСведений.ПройденныеУчебныеКурсы КАК ПройденныеУчебныеКурсы";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
//****************************************************
Функция СформироватьЯзыки()
	
	Запрос=Новый Запрос;
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ФизическиеЛицаЗнаниеЯзыков.Ссылка КАК ФизЛицо,
	|	ФизическиеЛицаЗнаниеЯзыков.Язык КАК Язык
	|ИЗ
	|	Справочник.ФизическиеЛица.ЗнаниеЯзыков КАК ФизическиеЛицаЗнаниеЯзыков";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

//****************************************************
Процедура ВыгрузитьДанные() Экспорт
	
	ЗаписьXML=Новый ЗаписьXML;
	
	
	Выборка=СформироватьЗапросПоСотрудникам();
	СоставСемьи=СформироватьСоставСемьи();
	Образование=СформироватьОбразование();
	ПовышениеКвалификации=СформироватьПовышениеКвалификации();
	Языки=СформироватьЯзыки();
	
	УчрежденияПовышенияКвалификации=Новый ТекстовыйДокумент;
	СписокУчебныхЗаведений=Новый  СписокЗначений;

	СтруктураПоиска=Новый Структура();
	
	Пока Выборка.Следующий() Цикл	
		
		СтруктураПоиска.Вставить("ФизЛицо",Выборка.ФизЛицо);
		СтрокиОбразования=Образование.НайтиСтроки(СтруктураПоиска);
		ВидОбразования="";
		Если СтрокиОбразования.Количество()>0 Тогда
			ВидОбразования=СтрокиОбразования[0].ВидОбразования;
			Для Каждого Стр Из СтрокиОбразования Цикл
				Если Стр.ОсновноеОбразование ТОгда
					ВидОбразования=Стр.ВидОбразования;
					Прервать;
				КонецЕсли;				
			КонецЦикла;			
		КонецЕсли;		
				
		ЗаписьXML.ОткрытьФайл(ФайлВыгрузки+"\"+Выборка.КодОрганизации+"_"+Выборка.ТабельныйНомер+".xml");
	
		ЗаписьXML.ЗаписатьОбъявлениеXML();
	
		ЗаписьXML.ЗаписатьНачалоЭлемента("kadry");
		ЗаписьXML.ЗаписатьНачалоЭлемента("hr.employee");
			ЗаписьXML.ЗаписатьНачалоЭлемента("item");
				Если СокрЛП(Строка(Выборка.Фамилия))<>"" Тогда 
					ЗаписьXML.ЗаписатьНачалоЭлемента("surname");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Фамилия)); ЗаписьXML.ЗаписатьКонецЭлемента();	
				КонецЕсли;				
				Если СокрЛП(Строка(Выборка.Имя))<>"" ТОгда					
					ЗаписьXML.ЗаписатьНачалоЭлемента("fname");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Имя)); ЗаписьXML.ЗаписатьКонецЭлемента();	
				КонецЕсли;				
				Если СокрЛП(Строка(Выборка.Отчество))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("lname");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Отчество)); ЗаписьXML.ЗаписатьКонецЭлемента();	
				КонецЕсли;
				//ЗаписьXML.ЗаписатьНачалоЭлемента("image"); ЗаписьXML.ЗаписатьКонецЭлемента();	 //пустые теги не вносить
				ЗаписьXML.ЗаписатьНачалоЭлемента("res.company_id");ЗаписьXML.ЗаписатьАтрибут("ranks","1");ЗаписьXML.ЗаписатьТекст("Производственное республиканское унитарное предприятие ""Брестоблгаз"""); ЗаписьXML.ЗаписатьКонецЭлемента();					
				Если СокрЛП(Строка(Выборка.Организация))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("res.company_id");ЗаписьXML.ЗаписатьАтрибут("ranks","2"); ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Организация)); ЗаписьXML.ЗаписатьКонецЭлемента();	
				КонецЕсли;				
				Если СокрЛП(Строка(Выборка.Подразделение))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("hr.department_id");ЗаписьXML.ЗаписатьАтрибут("ranks","1");ЗаписьXML.ЗаписатьТекст(Выборка.Подразделение); ЗаписьXML.ЗаписатьКонецЭлемента();	
				КонецЕсли;				
				//ЗаписьXML.ЗаписатьНачалоЭлемента("hr.department_id");ЗаписьXML.ЗаписатьАтрибут("ranks","2");ЗаписьXML.ЗаписатьТекст(""); ЗаписьXML.ЗаписатьКонецЭлемента();	
				Если СокрЛП(Строка(Выборка.Должность))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("hr.post_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Должность)); ЗаписьXML.ЗаписатьКонецЭлемента();				
				КонецЕсли;								
				//ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.nationality_id");ЗаписьXML.ЗаписатьКонецЭлемента();				
				Если СокрЛП(Строка(Выборка.Гражданство))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("res.country_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Гражданство)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.Пол))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.gender_id");ЗаписьXML.ЗаписатьТекст(Нрег(Строка(Выборка.Пол))); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(ВидОбразования))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.edu_type_id");ЗаписьXML.ЗаписатьТекст(Строка(ВидОбразования)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.СемейноеПоложение))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.marital_status_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.СемейноеПоложение)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если ЗначениеЗаполнено(Выборка.ДатаРождения) Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("birthdate");ЗаписьXML.ЗаписатьТекст(Строка(Формат(Выборка.ДатаРождения,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.МестоРождения))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("birthplace");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.МестоРождения)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.АдресПроживания))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("residence_place");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.АдресПроживания)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.АдресПрописки))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("registration_place");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.АдресПрописки)); ЗаписьXML.ЗаписатьКонецЭлемента();				
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ЕМэйл))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("work_email");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ЕМэйл)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ДокументВид))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.type_identity_document_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ДокументВид)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ДокументСерия))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("series");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ДокументСерия)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ДокументНомер))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("number");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ДокументНомер)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ДокументКемВыдан))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.authorities_passport_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ДокументКемВыдан)); ЗаписьXML.ЗаписатьКонецЭлемента();			
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ЛичныйНомер))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("personal_number");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ЛичныйНомер)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если ЗначениеЗаполнено(Выборка.ДокументСрокДействия) Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("date_of_issue");ЗаписьXML.ЗаписатьТекст(Строка(Формат(Выборка.ДокументСрокДействия,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ГруппаВоинскогоУчета))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.military_group_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ГруппаВоинскогоУчета)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.КатегорияВоинскогоУчета))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.military_category_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.КатегорияВоинскогоУчета)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.Состав))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.military_part_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Состав)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.Звание))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.military_rank_id");ЗаписьXML.ЗаписатьТекст(НРЕГ(Строка(Выборка.Звание))); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.ВУС))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.military_speciality_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ВУС)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.Годность))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.military_validity_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Годность)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				Если СокрЛП(Строка(Выборка.Военкомат))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.recrut_office_id");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.Военкомат)); ЗаписьXML.ЗаписатьКонецЭлемента();				
				КонецЕсли;
				//ЗаписьXML.ЗаписатьНачалоЭлемента("mobilization_prescription");ЗаписьXML.ЗаписатьТекст(?(Выборка.НаличиеМобПредписания,Строка("true"),Строка("false"))); ЗаписьXML.ЗаписатьКонецЭлемента();
				Если Выборка.НаличиеМобПредписания ТОгда //теги булеан вносить, если только тру
					ЗаписьXML.ЗаписатьНачалоЭлемента("mobilization_prescription");ЗаписьXML.ЗаписатьТекст(Строка("true")); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;				
				//ЗаписьXML.ЗаписатьНачалоЭлемента("special_account");ЗаписьXML.ЗаписатьТекст("false"); ЗаписьXML.ЗаписатьКонецЭлемента();
				Если СокрЛП(Строка(Выборка.НомерВоенногоБилета))<>"" Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("ID_number");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.НомерВоенногоБилета)); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;				
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_obliged");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_young_professional");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();			
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_internal_reserve");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_ministry_reserve");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_perspective_reserve");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_prospective_reserve");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_minenergo");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_beltopgas");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_sovmin");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				//ЗаписьXML.ЗаписатьНачалоЭлемента("is_president");ЗаписьXML.ЗаписатьТекст("False"); ЗаписьXML.ЗаписатьКонецЭлемента();
				Если ЗначениеЗаполнено(Выборка.ДатаПриемаНаРаботу) Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("hire_date");ЗаписьXML.ЗаписатьТекст(Строка(Формат(Выборка.ДатаПриемаНаРаботу,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;
				ДатаНепрерывногоСтажа=?(Не ЗначениеЗаполнено(Выборка.ОбщийСтаж),Выборка.ДатаПриемаНаРаботу,Выборка.ОбщийСтаж);
				Если ЗначениеЗаполнено(ДатаНепрерывногоСтажа) Тогда
					ЗаписьXML.ЗаписатьНачалоЭлемента("date_continuous_service");ЗаписьXML.ЗаписатьТекст(Строка(Формат(ДатаНепрерывногоСтажа,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();				
				КонецЕсли;
				Если ЗначениеЗаполнено(Выборка.ДатаПриемаНаРаботу) Тогда
					//комментируем, разбиваем на несколько тегов
					//ЗаписьXML.ЗаписатьНачалоЭлемента("date_activity_system");ЗаписьXML.ЗаписатьТекст(Строка(Формат(Выборка.ДатаПриемаНаРаботу,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();
					ЗаписьXML.ЗаписатьНачалоЭлемента("previous_activity_system_years");ЗаписьXML.ЗаписатьТекст("0"); ЗаписьXML.ЗаписатьКонецЭлемента();
					ЗаписьXML.ЗаписатьНачалоЭлемента("previous_activity_system_months");ЗаписьXML.ЗаписатьТекст("0"); ЗаписьXML.ЗаписатьКонецЭлемента();
					ЗаписьXML.ЗаписатьНачалоЭлемента("previous_activity_system_days");ЗаписьXML.ЗаписатьТекст("0"); ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЕсли;				
				ЗаписьXML.ЗаписатьНачалоЭлемента("hr.employee_category_id");ЗаписьXML.ЗаписатьТекст("списочный состав"); ЗаписьXML.ЗаписатьКонецЭлемента();								
			ЗаписьXML.ЗаписатьКонецЭлемента();	
		ЗаписьXML.ЗаписатьКонецЭлемента();	
		
		Если СокрЛП(Строка(Выборка.ТелефонРабочий))<>"" ТОгда
			ЗаписьXML.ЗаписатьНачалоЭлемента("hr.work.phone");		
				ЗаписьXML.ЗаписатьНачалоЭлемента("item");
					ЗаписьXML.ЗаписатьНачалоЭлемента("number"); ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ТелефонРабочий));ЗаписьXML.ЗаписатьКонецЭлемента();
				ЗаписьXML.ЗаписатьКонецЭлемента();			
				Если СокрЛП(Строка(Выборка.ТелефонРабочийМобильный))<>"" ТОгда
					ЗаписьXML.ЗаписатьНачалоЭлемента("item");
						ЗаписьXML.ЗаписатьНачалоЭлемента("number"); ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ТелефонРабочийМобильный));ЗаписьXML.ЗаписатьКонецЭлемента();
					ЗаписьXML.ЗаписатьКонецЭлемента();			
				КонецЕсли;
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
		
		Если (СокрЛП(Строка(Выборка.ТелефонДомашний))<>"") или (СокрЛП(Строка(Выборка.ТелефонМобильный))<>"") Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("hr.home.phone");		
			Если СокрЛП(Строка(Выборка.ТелефонДомашний))<>"" Тогда
				ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
					ЗаписьXML.ЗаписатьНачалоЭлемента("number"); ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ТелефонДомашний)); ЗаписьXML.ЗаписатьКонецЭлемента();
				ЗаписьXML.ЗаписатьКонецЭлемента();	
			КонецЕсли;			
			Если СокрЛП(Строка(Выборка.ТелефонМобильный))<>"" Тогда
				ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
					ЗаписьXML.ЗаписатьНачалоЭлемента("number");ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ТелефонМобильный)); ЗаписьXML.ЗаписатьКонецЭлемента();
				ЗаписьXML.ЗаписатьКонецЭлемента();	
			КонецЕсли;			
			ЗаписьXML.ЗаписатьКонецЭлемента();	
		КонецЕсли;		
	
		СтрокиФизЛица=СоставСемьи.НайтиСтроки(СтруктураПоиска);
	
		//Состав семьи		
		Если СтрокиФизЛица.Количество()>0 Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("hr.family");		
		    	
				Для Каждого Стр Из СтрокиФизЛица Цикл
							
					ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
					    Если СокрЛП(Строка(Стр.Имя))<>"" Тогда
		 					ЗаписьXML.ЗаписатьНачалоЭлемента("name"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.Имя)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
						Если СокрЛП(Строка(Стр.СтепеньРодства))<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("status"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.СтепеньРодства)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
						Если ЗначениеЗаполнено(Стр.ГодРождения) Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("date"); ЗаписьXML.ЗаписатьТекст(Строка(Формат(Стр.ГодРождения,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
					ЗаписьXML.ЗаписатьКонецЭлемента();					
				
				КонецЦикла;		
			
			ЗаписьXML.ЗаписатьКонецЭлемента();	
		КонецЕсли;		
		
	
		СтрокиФизЛица=Образование.НайтиСтроки(СтруктураПоиска);
	
		//Образование	
		Если СтрокиФизЛица.Количество()>0 Тогда
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.edu.institute");		 
	
				Для Каждого Стр Из СтрокиФизЛица Цикл
		
					ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 					
					    Если СокрЛП(Строка(Стр.УчебноеЗаведение))<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("education_institution"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.УчебноеЗаведение)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;					
						Если СокрЛП(Строка(Стр.НомерДиплома))<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("nomer"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.НомерДиплома)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
						Если ЗначениеЗаполнено(Стр.ДатаОкончания) Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("date"); ЗаписьXML.ЗаписатьТекст(Строка(Формат(Стр.ДатаОкончания,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
						Если СокрЛП(Строка(Стр.Специальность))<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.speciality_diploma_id"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.Специальность)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
						Если СокрЛП(Строка(Стр.Квалификация))<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.qualification_diploma_id"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.Квалификация)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
					ЗаписьXML.ЗаписатьКонецЭлемента();						
				
				КонецЦикла;	
		
			ЗаписьXML.ЗаписатьКонецЭлемента();			
		КонецЕсли;
		
		СтрокиФизЛица=Языки.НайтиСтроки(СтруктураПоиска);
	    //языки
		Если СтрокиФизЛица.Количество()>0 Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.edu.lang");
		
			Для Каждого Стр Из СтрокиФизЛица Цикл
				ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
					Если СокрЛП(Строка(Стр.Язык))<>"" Тогда
						ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.language_id"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.Язык)); ЗаписьXML.ЗаписатьКонецЭлемента();		
					КонецЕсли;
				ЗаписьXML.ЗаписатьКонецЭлемента();						
			КонецЦикла;					
		
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;		
		
		//ЗаписьXML.ЗаписатьНачалоЭлемента("hr.other.honors"); //Награды/Звания	
	//		ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.other_honors_id"); ЗаписьXML.ЗаписатьТекст("Документ награждения"); ЗаписьXML.ЗаписатьКонецЭлемента();					
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("date"); ЗаписьXML.ЗаписатьТекст("Дата награждения"); ЗаписьXML.ЗаписатьКонецЭлемента();					
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.rewarders_id"); ЗаписьXML.ЗаписатьТекст("Организация, которая награждает"); ЗаписьXML.ЗаписатьКонецЭлемента();		
	//		ЗаписьXML.ЗаписатьКонецЭлемента();			
		//ЗаписьXML.ЗаписатьКонецЭлемента();	
	//	
	//	
		Если СокрЛП(Строка(Выборка.ВидДоговора))<>"" Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.contract");		//контракт
				ЗаписьXML.ЗаписатьНачалоЭлемента("item");					
					ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.contract_type_id"); ЗаписьXML.ЗаписатьТекст(Строка(Выборка.ВидДоговора)); ЗаписьXML.ЗаписатьКонецЭлемента();										
					Если СокрЛП(Строка(Выборка.НомерДоговора))<>"" Тогда
						ЗаписьXML.ЗаписатьНачалоЭлемента("number"); ЗаписьXML.ЗаписатьТекст(Строка(Выборка.НомерДоговора)); ЗаписьXML.ЗаписатьКонецЭлемента();					
					КонецЕсли;
					Если ЗначениеЗаполнено(Выборка.ДатаНачала) Тогда
						ЗаписьXML.ЗаписатьНачалоЭлемента("date_b"); ЗаписьXML.ЗаписатьТекст(Строка(Формат(Выборка.ДатаНачала,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();		
					КонецЕсли;
					Если ЗначениеЗаполнено(Выборка.ДатаОкончания) Тогда
						ЗаписьXML.ЗаписатьНачалоЭлемента("date_e"); ЗаписьXML.ЗаписатьТекст(Строка(Формат(Выборка.ДатаОкончания,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();		
					КонецЕсли;					
					//ЗаписьXML.ЗаписатьНачалоЭлемента("sign");  ЗаписьXML.ЗаписатьКонецЭлемента();												
					//ЗаписьXML.ЗаписатьНачалоЭлемента("base");  ЗаписьXML.ЗаписатьКонецЭлемента();							
				ЗаписьXML.ЗаписатьКонецЭлемента();			
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;		
	//	
	//	
		//ЗаписьXML.ЗаписатьНачалоЭлемента("hr.vacation");		//отпуска
	//		ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.vacation_id"); ЗаписьXML.ЗаписатьТекст("Вид отпуска"); ЗаписьXML.ЗаписатьКонецЭлемента();					
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("date_b"); ЗаписьXML.ЗаписатьТекст("Дата начала"); ЗаписьXML.ЗаписатьКонецЭлемента();		
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("date_е"); ЗаписьXML.ЗаписатьТекст("Дата окончания"); ЗаписьXML.ЗаписатьКонецЭлемента();				
	//			ЗаписьXML.ЗаписатьНачалоЭлемента("base");  ЗаписьXML.ЗаписатьТекст("Основание"); ЗаписьXML.ЗаписатьКонецЭлемента();		
	//		ЗаписьXML.ЗаписатьКонецЭлемента();			
		//ЗаписьXML.ЗаписатьКонецЭлемента();	
	//
		
		СтрокиФизЛица=ПовышениеКвалификации.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокиФизЛица.Количество()>0 Тогда
			//повышение квалификации
			ЗаписьXML.ЗаписатьНачалоЭлемента("hr.retraining");		
		
			Для Каждого Стр Из СтрокиФизЛица Цикл
				
					ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 
						Если СокрЛП(Строка(Стр.УчебноеЗаведение))<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.establish_training_id"); ЗаписьXML.ЗаписатьТекст(Строка(Стр.УчебноеЗаведение)); ЗаписьXML.ЗаписатьКонецЭлемента();					
							Если СписокУчебныхЗаведений.НайтиПоЗначению(СокрЛП(Строка(Стр.УчебноеЗаведение)))=Неопределено ТОгда
								СписокУчебныхЗаведений.Добавить(СокрЛП(Строка(Стр.УчебноеЗаведение)));
							КонецЕсли;							
						КонецЕсли;
						Если ЗначениеЗаполнено(Стр.ДатаНачала) Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("date_b"); ЗаписьXML.ЗаписатьТекст(Строка(Формат(Стр.ДатаНачала,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;
						Если ЗначениеЗаполнено(Стр.ДатаОкончания) Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("date_e"); ЗаписьXML.ЗаписатьТекст(Строка(Формат(Стр.ДатаОкончания,"ДФ=""гггг-ММ-дд"""))); ЗаписьXML.ЗаписатьКонецЭлемента();				
						КонецЕсли;
						Если Строка(Стр.КурсОбучения)<>"" Тогда
							ЗаписьXML.ЗаписатьНачалоЭлемента("programm");  ЗаписьXML.ЗаписатьТекст(Строка(Стр.КурсОбучения)); ЗаписьXML.ЗаписатьКонецЭлемента();		
						КонецЕсли;						
						//ЗаписьXML.ЗаписатьНачалоЭлемента("kadry.speciality_diploma_id");  ЗаписьXML.ЗаписатьТекст(""); ЗаписьXML.ЗаписатьКонецЭлемента();																	
						ЗаписьXML.ЗаписатьНачалоЭлемента("base");  ЗаписьXML.ЗаписатьТекст(""); ЗаписьXML.ЗаписатьКонецЭлемента();								
					ЗаписьXML.ЗаписатьКонецЭлемента();						
			        	
			КонецЦикла;
			
			ЗаписьXML.ЗаписатьКонецЭлемента();	
		КонецЕсли;		
		
		//	
		//ЗаписьXML.ЗаписатьНачалоЭлемента("hr.validation");		//аттестация
		//		ЗаписьXML.ЗаписатьНачалоЭлемента("item"); 			
		//			ЗаписьXML.ЗаписатьНачалоЭлемента("date"); ЗаписьXML.ЗаписатьТекст("Дата аттестации"); ЗаписьXML.ЗаписатьКонецЭлемента();		
		//			ЗаписьXML.ЗаписатьНачалоЭлемента("decision_boss");  ЗаписьXML.ЗаписатьТекст("Решение"); ЗаписьXML.ЗаписатьКонецЭлемента();		
		//		ЗаписьXML.ЗаписатьКонецЭлемента();			
		//ЗаписьXML.ЗаписатьКонецЭлемента();	
			
		
	ЗаписьXML.ЗаписатьКонецЭлемента();	
		
	ЗаписьXML.Закрыть();
		
	КонецЦикла;

	Для к=0 По СписокУчебныхЗаведений.Количество()-1 Цикл
		УчрежденияПовышенияКвалификации.ДобавитьСтроку(СписокУчебныхЗаведений.Получить(к));
	КонецЦикла;
	
	УчрежденияПовышенияКвалификации.Записать(ФайлВыгрузки+"\ZAVEDEN_POV.txt");
КонецПроцедуры


Процедура ВыборФайлаДляВыгрузки(Элемент) Экспорт
	
	ДиалогФыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Если ДиалогФыбораФайла.Выбрать() Тогда
		Элемент.Значение = ДиалогФыбораФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры