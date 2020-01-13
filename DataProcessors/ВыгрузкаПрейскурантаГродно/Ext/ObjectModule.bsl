﻿Процедура ВыгрузитьПрейскурант() Экспорт
	
	Выборка = Справочники.ВидыРабот.ВыбратьИерархически(ВыбГруппа);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл("D:\works.xml");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("works");
	
	Пока Выборка.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("work");
		ЗаписьXML.ЗаписатьАтрибут("isgroup", ?(Выборка.ЭтоГруппа,"true","false"));
			ЗаписьXML.ЗаписатьНачалоЭлемента("id");
				ЗаписьXML.ЗаписатьТекст(СокрЛП(Выборка.КодПоПрейскуранту));
			ЗаписьXML.ЗаписатьКонецЭлемента();
			ЗаписьXML.ЗаписатьНачалоЭлемента("name");
				ЗаписьXML.ЗаписатьТекст(СокрЛП(Выборка.Наименование));
			ЗаписьXML.ЗаписатьКонецЭлемента();
			ЗаписьXML.ЗаписатьНачалоЭлемента("parent");
				ЗаписьXML.ЗаписатьТекст(?(Выборка.Родитель=ВыбГруппа,"",Строка(Выборка.Родитель.КодПоПрейскуранту)));
			ЗаписьXML.ЗаписатьКонецЭлемента();
		ЗаписьXML.ЗаписатьКонецЭлемента();
			
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();			
	ЗаписьXML.Закрыть();

КонецПроцедуры
