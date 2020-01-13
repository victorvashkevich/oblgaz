﻿Функция СтажСтрокой(Лет,Месяцев) Экспорт
	
	Возврат ?(Лет=0,"",Строка(Лет)+?((Число(Прав(Лет,1))<5) и ((Лет<>11)и(Лет<>12)и(Лет<>13)и(Лет<>14)),"г ","л "))+?(Месяцев=0,"",Строка(Месяцев)+"м");
	
КонецФункции

Функция ПоказательВидаРасчета(ВидРасчета,ОплаченоДнейЧасов,Показатель1,Показатель2,Показатель3,СуммаРезерва,ППС) Экспорт
		
	СтрокаДоп="";
	Если ТипЗнч(ВидРасчета)=Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций") ТОгда
		Если ВидРасчета.ПроизвольнаяФормулаРасчета ТОгда
			Если (ВидРасчета.Показатели.Количество()>0) и (Показатель1<>0) Тогда
				Стр=ВидРасчета.Показатели[0];
				СтрокаДоп=Строка(Показатель1)+(Стр.Показатель.НаименованиеДляПечати);
			КонецЕсли;		
			Если (ВидРасчета.Показатели.Количество()>1) и (Показатель2<>0) Тогда
				Стр=ВидРасчета.Показатели[1];
				СтрокаДоп=СтрокаДоп+" "+Строка(Показатель2)+(Стр.Показатель.НаименованиеДляПечати);
			КонецЕсли;		
		ИначеЕсли ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ЕжемесячнаяПремия ТОгда
			Если Показатель2<>0 Тогда
				СтрокаДоп=Строка(Показатель2)+"% снижено от "+Строка(Показатель1)+"%";
			Иначе
				СтрокаДоп=Строка(Показатель1)+"%";
			КонецЕсли;			
		ИначеЕсли ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПроцентомПоЧасовойТарифнойСтавкеВодители
			или ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПроцентомПоЧасовойТарифнойСтавкеРемонт
			или ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПроцентомПоЧасовойТарифнойСтавкеРемонтПлановый ТОгда
			Если Показатель3<>0 Тогда
				СтрокаДоп=Строка(Показатель3)+"% снижено от "+Строка(Показатель2)+"%";
			Иначе
				СтрокаДоп=Строка(Показатель2)+"%";
			КонецЕсли;	
		ИначеЕсли (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ДоплатаОтСтавкиПервогоРазряда) Тогда
			СтрокаДоп=Строка(Показатель1)+"% "+Строка(ОплаченоДнейЧасов)+"ч.";
		ИначеЕсли (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоМесячнойТарифнойСтавкеПоЧасам) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоЧасовойТарифнойСтавке) 
			или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ДоплатаЗаНочныеЧасы) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ДоплатаЗаЗаместительство) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработку)
			или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоЧасовойТарифнойСтавкеВодителей) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоЧасовойТарифнойСтавкеВодителейБезВыезда) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.СделкаПоЧасовойТарифнойСтавкеВодителей) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.СделкаПоЧасовойТарифнойСтавке) 
			или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоЧасовойТарифнойСтавкеВодителейРемонт) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоЧасовойТарифнойСтавкеВодителейРемонтПлановый) ТОгда
			СтрокаДоп=Строка(ОплаченоДнейЧасов)+"ч.";
		ИначеЕсли ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработкуФСЗН ТОгда	
			СтрокаДоп=Строка(ОплаченоДнейЧасов)+"д. "+Строка(Показатель1)+"%";
		ИначеЕсли ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработкуДляОтпускаПоКалендарнымДням ТОгда	
			СтрокаДоп=Строка(ОплаченоДнейЧасов)+"д.";	
		ИначеЕсли (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.Процентом) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.Индексация) или (ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПроцентом) ТОгда	
			СтрокаДоп=Строка(Показатель1)+"%";	
		ИначеЕсли ВидРасчета.СпособРасчета=Перечисления.СпособыРасчетаОплатыТруда.ОтСтажаПоЧасовойТарифнойСтавке ТОгда	
			СтрокаДоп=Строка(Показатель2)+"%";		
		КонецЕсли;
		Если СуммаРезерва<>0 ТОгда
			СтрокаДоп=СтрокаДоп+" (резерв "+Строка(СуммаРезерва)+ " руб.)"
		КонецЕсли;		
	ИначеЕсли ТипЗнч(ВидРасчета)=Тип("ПланВидовРасчетаСсылка.УдержанияОрганизаций") ТОгда
		Если ОплаченоДнейЧасов<>0 ТОгда
			СтрокаДоп="(№ "+Формат(ОплаченоДнейЧасов,"ЧЦ=12; ЧГ=0")+")";
		КонецЕсли;		
	КонецЕсли;
	
	Если ППС Тогда
		СтрокаДоп=СтрокаДоп+", ППС";
	КонецЕсли;			
	
	Возврат СтрокаДоп;
	
КонецФункции

Функция ЛетКонтрактаПрописью(Год) Экспорт
	
	Если (Год=0) или (Год=NULL) ТОгда Возврат ""; КонецЕсли;
	
	Если Число(Прав(Год,1))<5 и (Год<>11)и(Год<>12)и(Год<>13)и(Год<>14) ТОгда
		Возврат Строка(Год)+?(Год=1," год"," года");		
	КонецЕсли;
	
	Возврат Строка(Год)+" лет";
	
КонецФункции

Функция ОстатокКонтрактаПрописью(ДатаНачала,ДатаОкончания,Период) Экспорт
	
	Если (ДатаНачала=NULL) или (ДатаОкончания=NULL) ТОгда
		Возврат "";
	КонецЕсли;
	
	КолМес=12*Год(ДатаОкончания)+Месяц(ДатаОкончания)-1;
	
	ОстВМес=КолМес - (12*Год(Период)+Месяц(Период)-1);
	Если ДатаОкончания > Период тогда
		Если День(ДатаОкончания)<День(Период) тогда
			ОстВмес=ОстВмес-1;
			ОстДней=День(КонецМесяца(ДобавитьМесяц(ДатаОкончания,-1))) - День(Период)+День(ДатаОкончания);
		иначе
			ОстДней=День(ДатаОкончания) - День(Период);
		КонецЕсли;
		ОстВгодах=Цел(ОстВМес/12);
		
		Остаток=?(ОстВгодах=0,"",Строка(ОстВгодах)+"г ")+
		 ?(ОстВмес-ОстВгодах*12=0,"",Строка(ОстВмес-ОстВгодах*12)+"м ")+
         ?(ОстДней=0,"",Строка(ОстДней)+"дн ");
	иначе
		Остаток="Истек";	
	КонецЕсли;
	
	Возврат Остаток;
	
КонецФункции

Функция СокрЛП_СКД(Параметр) Экспорт
	Возврат СокрЛП(Параметр);
КонецФункции

Функция Число_СКД(Параметр) Экспорт
	Возврат Число(Параметр);
КонецФункции

Функция Символы_ПС() Экспорт
	Возврат Символы.ПС;
КонецФункции

Функция ФИО(Сотрудник) Экспорт
	
	Возврат ПроцедурыУправленияПерсоналом.ФамилияИнициалыФизЛица(Сотрудник.ФизЛицо);
	
КонецФункции

Функция СКД_ПолноеНаименованиеВидаРаботы(ВидРаботы) Экспорт
	
	Возврат  СокрЛП(ВидРаботы.КодПоПрейскуранту)+" "+СтрЗаменить(ВидРаботы.ПолноеНаименование(),"ПРЕЙСКУРАНТЫ ОБЛГАЗА/","");
	
КонецФункции






