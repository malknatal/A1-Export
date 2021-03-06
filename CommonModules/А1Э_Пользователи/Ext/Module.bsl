﻿#Если НЕ Клиент Тогда
	
	Функция ЗаполнитьПараметрСеансаГруппыТекущегоПользователя() Экспорт
		УстановитьПривилегированныйРежим(Истина);
		Если Метаданные.ПараметрыСеанса.Найти("А1Э_ГруппыТекущегоПользователя") = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		Если Метаданные.Справочники.Найти("ГруппыПользователей") = Неопределено Тогда
			ПараметрыСеанса["А1Э_ГруппыТекущегоПользователя"] = Новый ФиксированныйМассив(Новый Массив);
			Возврат Неопределено;
		КонецЕсли;
		МодульПользователи = Вычислить("Пользователи");
		МассивГруппПользователей = АктивныеГруппыПользователей(МодульПользователи.ТекущийПользователь());
		ПараметрыСеанса["А1Э_ГруппыТекущегоПользователя"] = Новый ФиксированныйМассив(МассивГруппПользователей);
		УстановитьПривилегированныйРежим(Ложь);
	КонецФункции
	
	Функция АктивныеГруппыПользователей(Пользователи) Экспорт
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Состав.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ГруппыПользователей.Состав КАК Состав
		|ГДЕ
		|	Состав.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И Состав.Пользователь В(&Пользователи)";
		Запрос.УстановитьПараметр("Пользователи", Пользователи);
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецФункции 
	
	Функция ОсновнаяГруппаТекущегоПользователя() Экспорт
		УстановитьПривилегированныйРежим(Истина);
		МодульПользователи = Вычислить("Пользователи");
		Возврат ОсновнаяГруппаПользователя(МодульПользователи.ТекущийПользователь());
		УстановитьПривилегированныйРежим(Ложь);
	КонецФункции
	
	Функция ГруппыТекущегоПользователя() Экспорт
		УстановитьПривилегированныйРежим(Истина);
		Возврат ПараметрыСеанса["А1Э_ГруппыТекущегоПользователя"];
		УстановитьПривилегированныйРежим(Ложь);
	КонецФункции
	
	Функция ОсновнаяГруппаПользователя(Пользователь) Экспорт
		Возврат А1Э_ДопРеквизиты.Значение(Пользователь, "А1_ОсновнаяГруппаПользователя", "А1"); 
	КонецФункции
	
#КонецЕсли
