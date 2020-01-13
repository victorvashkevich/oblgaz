﻿// Обработчик события УстановкаПараметровСеанса()
//  
Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)

	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ТребуемыеПараметры);
	// Конец СтандартныеПодсистемы
	
	Если ТребуемыеПараметры = Неопределено Тогда
		// раздел "безусловной" инициализации параметров сеанса
	Иначе		
		УстановленныеПараметры = Новый Структура;
		Для Каждого ИмяПараметра ИЗ ТребуемыеПараметры Цикл
			УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры);
		КонецЦикла;
	КонецЕсли;
 
КонецПроцедуры // УстановкаПараметровСеанса

Процедура УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры)
	
	Если УстановленныеПараметры.Свойство(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРИБ = Новый Структура;
	ПараметрыРИБ.Вставить("ИспользованиеРИБ");
	ПараметрыРИБ.Вставить("ПрефиксУзлаРаспределеннойИнформационнойБазы");
	ПараметрыРИБ.Вставить("НаличиеОбменаДаннымиПоОрганизации");
	ПараметрыРИБ.Вставить("ВсеУзлыОбменаПоОрганизациям");
	ПараметрыРИБ.Вставить("СоответствиеОрганизацийИУзловОбменаПоОрганизации");
	
	ПараметрыМеханизмаОграниченияПравДоступа = Новый Структура;
	ПараметрыМеханизмаОграниченияПравДоступа.Вставить("ИспользоватьОграниченияПравДоступаНаУровнеЗаписей");
	//ПараметрыМеханизмаОграниченияПравДоступа.Вставить("ИспользоватьОграничениеПо");
	//Для Каждого ВидОбъектаДоступа Из Метаданные.Перечисления.ВидыОбъектовДоступа.ЗначенияПеречисления Цикл			
	//	ПараметрыМеханизмаОграниченияПравДоступа.Вставить("ИспользоватьОграничениеПо" + ВидОбъектаДоступа.Имя);
	//КонецЦикла;	
	
	Если ИмяПараметра = "ОбщиеЗначения" Тогда
		ПараметрыСеанса.ОбщиеЗначения = Новый ХранилищеЗначения(Новый Структура);
		УстановленныеПараметры.Вставить("ОбщиеЗначения");
		
	ИначеЕсли ИмяПараметра = "ТекущийПользователь" Тогда
		ПараметрыСеанса.ТекущийПользователь = УправлениеПользователями.ОпределитьТекущегоПользователя();	
		//ПолныеПраваДополнительный.УстановитьПараметрСеансаТекущийПользователь();
		
		УстановленныеПараметры.Вставить("ТекущийПользователь");
		
	ИначеЕсли ПараметрыРИБ.Свойство(ИмяПараметра) Тогда	
		ПолныеПрава.ОпределитьФактИспользованияРИБ();
		ДополнитьСписокУстановленныхПараметров(УстановленныеПараметры, ПараметрыРИБ);
		
	ИначеЕсли ПараметрыМеханизмаОграниченияПравДоступа.Свойство(ИмяПараметра) Тогда	
		ПолныеПрава.УстановитьПараметрыМеханизмаОграниченияПравДоступа();
		ДополнитьСписокУстановленныхПараметров(УстановленныеПараметры, ПараметрыМеханизмаОграниченияПравДоступа);
					
	ИначеЕсли ИмяПараметра = "ГраницыЗапретаИзмененияДанных" Тогда		
		ПолныеПрава.УстановитьПараметрГраницыЗапретаИзмененияДанных();
		УстановленныеПараметры.Вставить("ГраницыЗапретаИзмененияДанных");
		
	ИначеЕсли ИмяПараметра = "МетаданныеДокументовРегистрацииОбъектовДоступа" Тогда		
		// Определим типы для поиска данных в документе регистрации
		// типы определим по регистру сведений ОбъектыДоступаДокументов
		МассивТиповИзмерения = Метаданные.РегистрыСведений.ОбъектыДоступаДокументов.Измерения.ОбъектДоступа.Тип.Типы();
		СоответствиеОбъектов = Новый Соответствие;
		СоответствиеОбъектов.Вставить("ТипыОбъектовДоступа", МассивТиповИзмерения);
		ПараметрыСеанса.МетаданныеДокументовРегистрацииОбъектовДоступа = Новый ХранилищеЗначения(СоответствиеОбъектов);
	//vvv
	Иначе
		
		#Если Не ТолстыйКлиентУправляемоеПриложение Тогда
			МодульСеансаПереопределяемый.УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры);
		#КонецЕсли
	//
	//ИначеЕсли ИмяПараметра = "ТекущиеУчетныеЗаписиНалогоплательщика" Тогда
	//	
	//	ПолныеПрава.УстановитьПараметрСеансаТекущиеУчетныеЗаписиНалогоплательщика();
		
	КонецЕсли;
	
	//МодульСеансаПереопределяемый.УстановитьЗначенияДополнительныхПараметровСеанса(ИмяПараметра, УстановленныеПараметры);
	
КонецПроцедуры

Процедура ДополнитьСписокУстановленныхПараметров(УстановленныеПараметры, ПараметрыРаздела)
	Для Каждого КлючИЗначение ИЗ ПараметрыРаздела Цикл
		УстановленныеПараметры.Вставить(КлючИЗначение.Ключ);
	КонецЦикла;
		
КонецПроцедуры

