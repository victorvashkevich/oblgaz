﻿
Функция ТекстЗапросаПоказателейВидаРасчетов() Экспорт
	
	Возврат 
	"ВЫБРАТЬ
	|	УправленческиеНачисленияПоказатели.Ссылка КАК ВидРасчета,
	|	УправленческиеНачисленияПоказатели.НомерСтроки КАК НомерПоказателя,
	|	УправленческиеНачисленияПоказатели.Показатель,
	|	УправленческиеНачисленияПоказатели.Показатель.Валюта КАК ВалютаПоказателя,
	|	УправленческиеНачисленияПоказатели.ЗапрашиватьПриКадровыхПеремещениях,
	|	ВЫБОР
	|		КОГДА УправленческиеНачисленияПоказатели.Показатель.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ТипТарифныйРазряд
	|ПОМЕСТИТЬ ПоказателиВидаРасчета
	|ИЗ
	|	ПланВидовРасчета.УправленческиеНачисления.Показатели КАК УправленческиеНачисленияПоказатели
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	УправленческиеУдержанияПоказатели.Ссылка,
	|	УправленческиеУдержанияПоказатели.НомерСтроки,
	|	УправленческиеУдержанияПоказатели.Показатель,
	|	УправленческиеУдержанияПоказатели.Показатель.Валюта,
	|	УправленческиеУдержанияПоказатели.ЗапрашиватьПриКадровыхПеремещениях,
	|	ВЫБОР
	|		КОГДА УправленческиеУдержанияПоказатели.Показатель.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|ИЗ
	|	ПланВидовРасчета.УправленческиеУдержания.Показатели КАК УправленческиеУдержанияПоказатели
	|;
	|";
	
КонецФункции

Процедура ДобавитьОбъединениеДополнительныхНачисленийУдержаний(ТекстЗапроса, ЗаполнятьНачисления, ЗаполнятьУдержания) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры
