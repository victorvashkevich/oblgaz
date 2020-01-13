﻿Перем мДлинаСуток Экспорт;

Процедура ГрафикРаботыВывести(Таб,ДатаНач,ДатаКон,Организация,ПодразделениеОрганизации) Экспорт
	
	Таб.Очистить();
	Макет = ПолучитьМакет("ГрафикРаботы");
		
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.Период = "" + ПредставлениеПериода(ДатаНач, КонецДня(ДатаКон), "ДФ=""ММММ.гггг""");
	//Область.Параметры.Организация = Организация.Наименование;
	Область.Параметры.ПодразделениеОрганизации = ПодразделениеОрганизации;
	Руководители = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизаций(Организация, ТекущаяДата(),);
	Область.Параметры.Директор = Руководители.Руководитель;
	Таб.Вывести(Область);

	ОбластьШапкаОсновная = Макет.ПолучитьОбласть("ШапкаТаблицы|Основная");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаДата = Макет.ПолучитьОбласть("ШапкаТаблицы|Дата");
	ОбластьШапкаИтог = Макет.ПолучитьОбласть("ШапкаТаблицы|Итог");
	ОбластьДеталиОсновная = Макет.ПолучитьОбласть("Детали|Основная");
	ОбластьДеталиДата = Макет.ПолучитьОбласть("Детали|Дата");
	ОбластьДеталиИтог = Макет.ПолучитьОбласть("Детали|Итог");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	Таб.Вывести(ОбластьШапкаОсновная);
	
	НачДата = ДатаНач;
	ДД = Новый Массив(8);
	ДД[1] = "Пн.";
	ДД[2] = "Вт.";
	ДД[3] = "Ср.";
	ДД[4] = "Чт.";
	ДД[5] = "Пт.";
	ДД[6] = "Сб.";
	ДД[7] = "Вс.";
	Пока НачДата <= ДатаКон Цикл
		ОбластьШапкаДата.Параметры.Дата = Формат(НачДата, "ДФ=""дд""");
		ОбластьШапкаДата.Параметры.День = ДД[ДеньНедели(НачДата)];
		
		Таб.Присоединить(ОбластьШапкаДата);
		НачДата = КонецДня(НачДата) + 1;
	КонецЦикла;
	Таб.Присоединить(Макет.ПолучитьОбласть("ШапкаТаблицы|Итог"));
	
	ДД[1] = Перечисления.ДниНедели.Понедельник;
	ДД[2] = Перечисления.ДниНедели.Вторник;
	ДД[3] = Перечисления.ДниНедели.Среда;
	ДД[4] = Перечисления.ДниНедели.Четверг;
	ДД[5] = Перечисления.ДниНедели.Пятница;
	ДД[6] = Перечисления.ДниНедели.Суббота;
	ДД[7] = Перечисления.ДниНедели.Воскресенье;

	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ВидыЗанятости = Новый Массив;
	ВидыЗанятости.Добавить(Перечисления.ВидыЗанятостиВОрганизации.Совместительство);
	ВидыЗанятости.Добавить(Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы);
	
	ВидыУчетаВремени = Новый Массив;
	ВидыУчетаВремени.Добавить(Перечисления.ВидыУчетаВремени.ПоЧасам);
	ВидыУчетаВремени.Добавить(Перечисления.ВидыУчетаВремени.ПоНочнымЧасам);
    ВидыУчетаВремени.Добавить(Перечисления.ВидыУчетаВремени.ПоДням);
	
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПодразделениеОрганизации", ПодразделениеОрганизации);
	Запрос.УстановитьПараметр("Увольнение", Перечисления.ПричиныИзмененияСостояния.Увольнение);
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", НачалоМинуты(КонецДня(ДатаКон)));
	Запрос.УстановитьПараметр("ВидУчетаВремени", Перечисления.ВидыУчетаВремени.ПоЧасам);
	Запрос.УстановитьПараметр("ВидГрафика", Перечисления.ВидыРабочихГрафиков.Сменный);
	Запрос.УстановитьПараметр("Перемещение", Перечисления.ПричиныИзмененияСостояния.Перемещение);
	Запрос.УстановитьПараметр("Прием", Перечисления.ПричиныИзмененияСостояния.ПриемНаРаботу);
	Запрос.УстановитьПараметр("ВидЗанятости", ВидыЗанятости);
	Запрос.УстановитьПараметр("ВидыУчетаВремени", ВидыУчетаВремени);


	//Запрос.Текст =
	//"ВЫБРАТЬ РАЗЛИЧНЫЕ
	//|	Сотрудники.Сотрудник КАК Сотрудник,
	//|	Сотрудники.ВидЗанятости КАК ВидЗанятости,
	//|	Сотрудники.Организация КАК Организация,
	//|	Сотрудники.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	//|	Сотрудники.Должность КАК Должность,
	//|	Сотрудники.Период КАК Период,
	//|	Сотрудники.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,
	//|	Сотрудники.ГрафикРаботы КАК ГрафикРаботы
	//|ПОМЕСТИТЬ ВТСотрудники
	//|ИЗ
	//|	(ВЫБРАТЬ
	//|		РаботникиОрганизаций.Сотрудник КАК Сотрудник,
	//|		РаботникиОрганизаций.Сотрудник.ВидЗанятости КАК ВидЗанятости,
	//|		РаботникиОрганизаций.Организация КАК Организация,
	//|		РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	//|		РаботникиОрганизаций.Должность КАК Должность,
	//|		РаботникиОрганизаций.Период КАК Период,
	//|		РаботникиОрганизаций.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,
	//|		ЕСТЬNULL(ГрафикиРаботыИндивидуальные.ГрафикРаботы, РаботникиОрганизаций.ГрафикРаботы) КАК ГрафикРаботы
	//|	ИЗ
	//|		РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	//|				&ДатаНач,
	//|				Организация = &Организация
	//|					И ПодразделениеОрганизации = &ПодразделениеОрганизации) КАК РаботникиОрганизаций
	//|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыИндивидуальные
	//|			ПО РаботникиОрганизаций.Сотрудник = ГрафикиРаботыИндивидуальные.ГрафикРаботы
	//|				И (ГрафикиРаботыИндивидуальные.Дата МЕЖДУ &ДатаНач И &ДатаКон)
	//|				И (ГрафикиРаботыИндивидуальные.ВидУчетаВремени В (&ВидыУчетаВремени))
	//|	ГДЕ
	//|		РаботникиОрганизаций.Сотрудник.ВидЗанятости В(&ВидЗанятости)
	//|	
	//|	ОБЪЕДИНИТЬ ВСЕ
	//|	
	//|	ВЫБРАТЬ
	//|		РаботникиОрганизаций.Сотрудник,
	//|		РаботникиОрганизаций.Сотрудник.ВидЗанятости КАК ВидЗанятости,
	//|		РаботникиОрганизаций.Организация,
	//|		РаботникиОрганизаций.ПодразделениеОрганизации,
	//|		РаботникиОрганизаций.Должность,
	//|		РаботникиОрганизаций.Период,
	//|		РаботникиОрганизаций.ПричинаИзмененияСостояния КАК ПричинаИзмененияСостояния,
	//|		ЕСТЬNULL(ГрафикиРаботыИндивидуальные.ГрафикРаботы, РаботникиОрганизаций.ГрафикРаботы)
	//|	ИЗ
	//|		РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	//|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыИндивидуальные
	//|			ПО РаботникиОрганизаций.Сотрудник = ГрафикиРаботыИндивидуальные.ГрафикРаботы
	//|				И (ГрафикиРаботыИндивидуальные.Дата МЕЖДУ &ДатаНач И &ДатаКон)
	//|				И (ГрафикиРаботыИндивидуальные.ВидУчетаВремени В (&ВидыУчетаВремени))
	//|	ГДЕ
	//|		РаботникиОрганизаций.Период МЕЖДУ &ДатаНач И &ДатаКон
	//|		И РаботникиОрганизаций.Организация = &Организация
	//|		И РаботникиОрганизаций.ПодразделениеОрганизации = &ПодразделениеОрганизации) КАК Сотрудники
	//|
	//|ИНДЕКСИРОВАТЬ ПО
	//|	Сотрудник,
	//|	Период";
	//
	//
	//Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК ДатаКалендаря
	|ПОМЕСТИТЬ ВТПериоды
	|ИЗ
	|	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаНач И &ДатаКон
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РаботникиОрганизацийСрез.ДатаКалендаря,
	|	РаботникиОрганизаций.Сотрудник,
	|	РаботникиОрганизаций.Должность,
	|	ЕСТЬNULL(ГрафикиРаботыИндивидуальные.ГрафикРаботы, РаботникиОрганизаций.ГрафикРаботы) КАК ГрафикРаботы,
	|	РаботникиОрганизаций.ПодразделениеОрганизации
	|ПОМЕСТИТЬ ВТДанныеСотрудника
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(РаботникиОрганизаций1.Период) КАК Период,
	|		РаботникиОрганизаций1.Сотрудник КАК Сотрудник,
	|		Периоды.ДатаКалендаря КАК ДатаКалендаря
	|	ИЗ
	|		ВТПериоды КАК Периоды
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций1
	|			ПО Периоды.ДатаКалендаря >= РаботникиОрганизаций1.Период
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Периоды.ДатаКалендаря,
	|		РаботникиОрганизаций1.Сотрудник) КАК РаботникиОрганизацийСрез
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыИндивидуальные
	|		ПО РаботникиОрганизацийСрез.Сотрудник = ГрафикиРаботыИндивидуальные.ГрафикРаботы
	|			И (ГрафикиРаботыИндивидуальные.Дата МЕЖДУ &ДатаНач И &ДатаКон)
	|			И (ГрафикиРаботыИндивидуальные.ВидУчетаВремени В (&ВидыУчетаВремени))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО РаботникиОрганизацийСрез.Период = РаботникиОрганизаций.Период
	|			И РаботникиОрганизацийСрез.Сотрудник = РаботникиОрганизаций.Сотрудник
	|			И (РаботникиОрганизаций.ПодразделениеОрганизации = &ПодразделениеОрганизации)
	|			И (РаботникиОрганизаций.ПричинаИзмененияСостояния <> &Увольнение)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеСотрудника.ДатаКалендаря КАК Дата,
	|	ДанныеСотрудника.Сотрудник КАК Сотрудник,
	|	ДанныеСотрудника.ПодразделениеОрганизации,
	|	ДанныеСотрудника.Должность,
	|	ДанныеСотрудника.ГрафикРаботы,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ГрафикиРаботыПоВидамВремени.ВидУчетаВремени = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаВремени.ПоДням)
	|					ТОГДА ГрафикиРаботыПоВидамВремени.ОсновноеЗначение
	|			КОНЕЦ), 0) КАК Дни,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ГрафикиРаботыПоВидамВремени.ВидУчетаВремени = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаВремени.ПоЧасам)
	|					ТОГДА ГрафикиРаботыПоВидамВремени.ОсновноеЗначение
	|			КОНЕЦ), 0) КАК Часы,
	|	ЕСТЬNULL(СУММА(ВЫБОР
	|				КОГДА ГрафикиРаботыПоВидамВремени.ВидУчетаВремени = ЗНАЧЕНИЕ(Перечисление.ВидыУчетаВремени.ПоНочнымЧасам)
	|					ТОГДА ГрафикиРаботыПоВидамВремени.ОсновноеЗначение
	|			КОНЕЦ), 0) КАК НочныеЧасы,
	|	РегламентированныйПроизводственныйКалендарь.ВидДня,
	|	ДанныеСотрудника.Сотрудник.Код КАК ТабНом
	|ИЗ
	|	ВТДанныеСотрудника КАК ДанныеСотрудника
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиРаботыПоВидамВремени КАК ГрафикиРаботыПоВидамВремени
	|		ПО ДанныеСотрудника.ГрафикРаботы = ГрафикиРаботыПоВидамВремени.ГрафикРаботы
	|			И ДанныеСотрудника.ДатаКалендаря = ГрафикиРаботыПоВидамВремени.Дата
	|			И (ГрафикиРаботыПоВидамВремени.ВидУчетаВремени В (&ВидыУчетаВремени))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|		ПО ДанныеСотрудника.ДатаКалендаря = РегламентированныйПроизводственныйКалендарь.ДатаКалендаря
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеСотрудника.ДатаКалендаря,
	|	ДанныеСотрудника.Сотрудник,
	|	ДанныеСотрудника.ПодразделениеОрганизации,
	|	ДанныеСотрудника.Должность,
	|	ДанныеСотрудника.ГрафикРаботы,
	|	РегламентированныйПроизводственныйКалендарь.ВидДня,
	|	ДанныеСотрудника.Сотрудник.Код
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеСотрудника.Сотрудник.Наименование,
	|	Дата
	|ИТОГИ
	|	СУММА(Дни),
	|	СУММА(Часы),
	|	СУММА(НочныеЧасы)
	|ПО
	|	Сотрудник"; 

		
	ПустаяДата = '00010101';
	Результат = Запрос.Выполнить();
	ВыборкаПоСотруднику = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоСотруднику.Следующий() цикл
		Если ЗначениеЗаполнено(ВыборкаПоСотруднику.Дни) тогда 
			ПраздничныхДней = 0;
			ПраздничныхЧасов = 0;
			ОбластьДеталиОсновная.Параметры.ФизЛицо =  ВыборкаПоСотруднику.Сотрудник;
			ОбластьДеталиОсновная.Параметры.ТабНом =  СокрЛП(ВыборкаПоСотруднику.Сотрудник.Код);
			Таб.Вывести(ОбластьДеталиОсновная);
			ВыборкаПоДням = ВыборкаПоСотруднику.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Дата = ДатаНач;
			Пока ВыборкаПоДням.Следующий() Цикл
				
				Пока ВыборкаПоДням.Дата > Дата Цикл
					ОбластьДеталиДата= Макет.ПолучитьОбласть("Детали|Дата");	
					Таб.Присоединить(ОбластьДеталиДата);
					Дата = КонецДня(Дата) +1;
				КонецЦикла;
				ОбластьДеталиДата= Макет.ПолучитьОбласть("Детали|Дата");
				Если ВыборкаПоДням.Дни > 0 тогда
					ОбластьДеталиДата.Параметры.Часы = ВыборкаПоДням.Часы;
					Таб.Присоединить(ОбластьДеталиДата);
					Если ВыборкаПоДням.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник тогда
						ПраздничныхДней = ПраздничныхДней + 1;
						ПраздничныхЧасов = ПраздничныхЧасов + ВыборкаПоДням.Часы;
					КонецЕсли;
					
				Иначе 
					Таб.Присоединить(ОбластьДеталиДата);
				КонецЕсли;
				Дата = КонецДня(Дата) +1;
				
			КонецЦикла;
			
			
			ОбластьДеталиИтог.Параметры.РабочихДней = ВыборкаПоСотруднику.Дни;
			ОбластьДеталиИтог.Параметры.РабочихЧасов = ВыборкаПоСотруднику.Часы;
			ОбластьДеталиИтог.Параметры.РабочихНочных = ВыборкаПоСотруднику.НочныеЧасы;
			ОбластьДеталиИтог.Параметры.ПраздничныхДней = ПраздничныхДней;
			ОбластьДеталиИтог.Параметры.ПраздничныхЧасов = ПраздничныхЧасов;
			Таб.Присоединить(ОбластьДеталиИтог);
		КонецЕсли;			
	КонецЦикла;
	
	Таб.Вывести(ОбластьПодвал);
КонецПроцедуры
#Если Клиент Тогда
	
НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли
мДлинаСуток = 86400;