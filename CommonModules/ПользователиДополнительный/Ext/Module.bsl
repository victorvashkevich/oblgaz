﻿////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

Функция ПользовательИмеетУправленческиеРоли(Код) Экспорт
	
	ПользовательИБ = УправлениеПользователями.НайтиПользователяИБ(СокрЛП(Код));
	
	Если ПользовательИБ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РолиУправленческогоУчета = Новый Массив;
	РолиУправленческогоУчета.Добавить(Метаданные.Роли.ПолныеПрава);
	РолиУправленческогоУчета.Добавить(Метаданные.Роли.КадровикУправленческихДанных);
	РолиУправленческогоУчета.Добавить(Метаданные.Роли.РасчетчикУправленческойЗарплаты);
	
	Для Каждого РольУправленческогоУчета Из РолиУправленческогоУчета Цикл
		Если ПользовательИБ.Роли.Содержит(РольУправленческогоУчета)	Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

// Проверка доступности роли "управленческого" кадровика
// это или КадровикУправленческихДанных или полные права
// Применяется для проверки прав на доступ к кадровым даннам, например, 
// в формах или при выводе на печать
// Возвращаемое значение:
//	булево - истина если есть доступ к "кадровым" данным
Функция ДоступнаРольКадровикаУпр() Экспорт
	Возврат РольДоступна("КадровикУправленческихДанных")
			или ОбщегоНазначенияЗКПереопределяемый.ДоступнаУстаревшаяРоль("УдалитьКадровикУправленческихДанныхБезОграниченияПрав")
			или РольДоступна("ПолныеПрава");
	
КонецФункции  //ДоступнаРольРасчетчика
