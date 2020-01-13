﻿Перем ПроверятьНаВхождениеВГруппы Экспорт;

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЭтоНовый() Тогда
			
		Если НЕ ПравоДоступа("Администрирование", Метаданные) 
			И (Ссылка.Код <> Код) Тогда
			
			#Если Клиент Тогда
				
				Сообщить("Изменение кода существующего элемента справочника ""Пользователи"" запрещено. 
				|Изменение кода возможно только при наличии права ""Администрирование""", СтатусСообщения.Важное);
			
			#КонецЕсли
			Отказ = Истина;
			
		КонецЕсли;
			
	КонецЕсли;
	
	
	ВыводитьПредупреждение = ПроверятьНаВхождениеВГруппы И НЕ ПользовательВключенВГруппыПользователей();
	Если ВыводитьПредупреждение Тогда
		#Если Клиент Тогда
		Предупреждение("Для правильной работы механизма ограничения прав доступа,
						|пользователь должен быть включен хотя бы в одну группу пользователей!");
		#КонецЕсли
	КонецЕсли;
		
КонецПроцедуры

Функция ПользовательВключенВГруппыПользователей()
	
	Если ЭтоНовый() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	 |	1 КАК Поле1
	 |ИЗ
	 |	Константы КАК Константы
	 |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ ПЕРВЫЕ 1
	 |			1 КАК ЕстьГруппа
	 |		ИЗ
	 |			Справочник.ГруппыПользователей.ПользователиГруппы КАК ГруппыПользователейПользователиГруппы
	 |		ГДЕ
	 |			ГруппыПользователейПользователиГруппы.Пользователь = &Пользователь) КАК ГруппыПользователя
	 |		ПО (ИСТИНА)
	 |ГДЕ
	 |	Константы.ИспользоватьОграниченияПравДоступаНаУровнеЗаписей
	 |	И ГруппыПользователя.ЕстьГруппа ЕСТЬ NULL";
	 
	 Запрос.УстановитьПараметр("Пользователь", Ссылка);
	 Результат = Запрос.Выполнить();
	 
	 Возврат Результат.Пустой();
	
КонецФункции
	


Процедура ПриКопировании(ОбъектКопирования)
	
	Код = "";
	Наименование = "";
	
КонецПроцедуры

ПроверятьНаВхождениеВГруппы = Ложь;