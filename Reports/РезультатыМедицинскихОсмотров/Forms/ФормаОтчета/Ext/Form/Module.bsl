﻿&НаСервере
Процедура Подключаемый_ПриСозданииНаСервереУниверсальныйОбработчик(Отказ, СтандартнаяОбработка)
	ФункцииОтчетов.ПриСозданииОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ПриЗагрузкеВариантаНаСервереУниверсальныйОбработчик(Настройки)
	ФункцииОтчетов.ПриЗагрузкеВариантаНаСервере(ЭтаФорма, Настройки);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ПриЗагрузкеПользовательскихНастроекНаСервереУниверсальныйОбработчик(Настройки)
	ФункцииОтчетов.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗакрытииУниверсальныйОбработчик()
	ФункцииОтчетовКлиент.ПриЗакрытии(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриОкончанииРедактированияУниверсальныйОбработчик(Элемент, НоваяСтрока, ОтменаРедактирования)
	ФункцииОтчетовКлиент.ПриОкончанииРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриАктивизацииСтрокиУниверсальныйОбработчик(Элемент)
	ФункцииОтчетовКлиент.ПриАктивизацииСтроки(ЭтаФорма, Элемент);
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТЧИКИ СОРБЫТИЯ

&НаКлиенте
Процедура Подключаемый_НачалоВыбораУниверсальныйОбработчик(Элемент, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.НачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачалоВыбораИзСпискаУниверсальныйОбработчик(Элемент, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.НачалоВыбораИзСписка(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОчисткаУниверсальныйОбработчик(Элемент, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.Очистка(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РегулированиеУниверсальныйОбработчик(Элемент, Направление, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.Регулирование(ЭтаФорма, Элемент, Направление, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоПодборУниверсальныйОбработчик(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.АвтоПодбор(ЭтаФорма, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОкончаниеВводаТекстаУниверсальныйОбработчик(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.ОкончаниеВводаТекста(ЭтаФорма, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииУниверсальныйОбработчик(Элемент)
	ФункцииОтчетовКлиент.ПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРасшифровкиУниверсальныйОбработчик(Элемент, Расшифровка, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФормаОбработкаВыбораУниверсальныйОбработчик(РезультатВыбора, ИсточникВыбора)
	ФункцииОтчетовКлиент.ФормаОбработкаВыбора(ЭтаФорма, РезультатВыбора, ИсточникВыбора);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаВыбораУниверсальныйОбработчик(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ФункцииОтчетовКлиент.ОбработкаВыбора(ЭтаФорма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры


&НаСервере
Процедура Подключаемый_ПриСохраненииВариантаНаСервереУниверсальныйОбработчик(Настройки)
	ФункцииОтчетов.ПриСохраненииВариантаНаСервере(ЭтаФорма, Настройки);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ПриСохраненииПользовательскихНастроекНаСервереУниверсальныйОбработчик(Настройки)
	ФункцииОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УниверсальнаяПроцедураКомандыУниверсальныйОбработчик(Команда)
	ФункцииОтчетовКлиент.УниверсальнаяПроцедураКоманды(Команда, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеУниверсальныйОбработчик(Элемент)
	ФункцииОтчетовКлиент.Нажатие(ЭтаФорма, Элемент);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервереУниверсальныйОбработчик(СтруктураКоманды) Экспорт
	ФункцииОтчетов.ВыполнитьКомандуНаСервере(ЭтаФорма, СтруктураКоманды);
КонецПроцедуры

