﻿#Если НЕ Клиент Тогда
	
// Результат выполнения СКД. Выводится в переменную Результат в зависимости от её типа.
//   
// Параметры:
//  СхемаКомпоновкиДанных	 - 	 - 
//  Настройки				 - Структура - Структура может содержать ключи:
//    ВнешниеНаборыДанных - Структура
//    КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных
//    НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных
//	Альтернативно, КомпоновщикНастроек или НастройкиКомпоновкиДанных можно передать как значение.
//    
//  Результат			 - ТаблицаЗначений, ДеревоЗначений, ТабличныйДокумент - в этот параметр будет передан результат. 
//  ДанныеРасшифровки	 - Неопределено - в этот параметр будут помещены данные расшифовки. 
// 
// Возвращаемое значение:
//   - 
//
Функция РезультатВыполнения(СхемаКомпоновкиДанных, Настройки = Неопределено, Результат, ДанныеРасшифровки = Неопределено) Экспорт
	#Если Сервер И НЕ Сервер Тогда
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	#КонецЕсли 	
	
	ВременноеЗначение = Неопределено;
	
	Если ТипЗнч(Настройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		РабочиеНастройки = Новый Структура("КомпоновщикНастроек", Настройки);
	ИначеЕсли ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		РабочиеНастройки = Новый Структура("НастройкиКомпоновкиДанных", Настройки);
	ИначеЕсли ТипЗнч(Настройки) = Тип("МакетОформленияКомпоновкиДанных") Тогда
		РабочиеНастройки = Новый Структура("МакетОформления", Настройки);
	Иначе
		РабочиеНастройки = А1Э_Структуры.Структура(Настройки);
	КонецЕсли;
	
	#Если Сервер И НЕ Сервер Тогда
		РабочиеНастройки = Новый Структура;		
	#КонецЕсли 
	
	Если РабочиеНастройки.Свойство("КомпоновщикНастроек", ВременноеЗначение) Тогда
		НастройкиКомпоновкиДанных = ВременноеЗначение.ПолучитьНастройки();
	ИначеЕсли РабочиеНастройки.Свойство("НастройкиКомпоновкиДанных", ВременноеЗначение) Тогда
		НастройкиКомпоновкиДанных = ВременноеЗначение;
	Иначе
		НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	КонецЕсли;
	
	Если ДанныеРасшифровки = Неопределено Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; 
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
	Если ТипЗнч(Результат) = Тип("ТабличныйДокумент") Тогда
		ВыводитьВТабличныйДокумент = Истина;
	ИначеЕсли ТипЗнч(Результат) = Тип("ТаблицаЗначений") Или ТипЗнч(Результат) = Тип("ДеревоЗначений") Тогда
		ВыводитьВТабличныйДокумент = Ложь;
	Иначе
		А1Э_Служебный.ИсключениеНеверныйТип("Результат", "А1Э_СКД.РезультатВыполнения", Результат, "ТаблицаЗначений,ДеревоЗначений,ТабличныйДокумент");
	КонецЕсли;
	
	МакетОформления = А1Э_Структуры.ЗначениеСвойства(РабочиеНастройки, "МакетОформления");
	Если ТипЗнч(МакетОформления) = Тип("ЭлементБиблиотекиМакетовОформленияКомпоновкиДанных") Тогда
		МакетОформления = МакетОформления.ПолучитьМакет();
	КонецЕсли;
	
	Если ВыводитьВТабличныйДокумент Тогда 
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ДанныеРасшифровки, МакетОформления);
	Иначе
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ДанныеРасшифровки, МакетОформления, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	КонецЕсли;
		
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных; 
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, А1Э_Структуры.ЗначениеСвойства(РабочиеНастройки, "ВнешниеНаборыДанных"), ДанныеРасшифровки); 
	
	Результат.Очистить();
	
	Если ТипЗнч(Результат) = Тип("ТабличныйДокумент") Тогда
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент; 
		ПроцессорВывода.УстановитьДокумент(Результат); 
	ИначеЕсли ТипЗнч(Результат) = Тип("ТаблицаЗначений") Или ТипЗнч(Результат) = Тип("ДеревоЗначений") Тогда
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(Результат);
	КонецЕсли;
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
КонецФункции

// Функция - Результат выполнения по таблице значений
//
// Параметры:
//  ТаблицаЗначений		 - ТаблицаЗначений - является источником данных для СКД
//  Настройки			 -   - см. А1Э_СКД.РезультатВыполнения() 
//  СтруктураОтчета		 - Структура - может содержать ключи "Ресурсы" , "Группировки", "Колонки" - массивы строк или строки, разделенные запятыми.
//  Результат			 - ТаблицаЗначений, ДеревоЗначений, ТабличныйДокумент - в этот параметр будет передан результат. 
//  ДанныеРасшифровки	 - Неопределено - в этот параметр будут помещены данные расшифовки. 
//  АдресСКД			 - Строка, Неопределено - Если не равно неопределено, но в этот параметр будет помещен адрес СКД во временном хранилище. 
// 
// Возвращаемое значение:
//   - 
//
Функция РезультатВыполненияПоТаблицеЗначений(ТаблицаЗначений, Настройки = Неопределено, СтруктураОтчета, Результат, ДанныеРасшифровки = Неопределено, АдресСКД = Неопределено) Экспорт 
	
	СхемаКомпоновкиДанных = СоздатьПоТаблицеЗначений(ТаблицаЗначений, 
	А1Э_Структуры.ЗначениеСвойства(СтруктураОтчета, "Ресурсы"),
	А1Э_Структуры.ЗначениеСвойства(СтруктураОтчета, "Группировки"), 
	А1Э_Структуры.ЗначениеСвойства(СтруктураОтчета, "Колонки"));
	Если АдресСКД <> Неопределено Тогда
		АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КонецЕсли;
	
	РабочиеНастройки = А1Э_Структуры.Структура(Настройки);
	РабочиеНастройки.Вставить("ВнешниеНаборыДанных", Новый Структура("НаборДанных", ТаблицаЗначений));
	
	РезультатВыполнения(СхемаКомпоновкиДанных, РабочиеНастройки, Результат, ДанныеРасшифровки);
	
КонецФункции

Функция СоздатьПоТаблицеЗначений(ТаблицаЗначений, Ресурсы = Неопределено, Группировки = Неопределено, Колонки = Неопределено) Экспорт
	#Если Сервер И НЕ Сервер Тогда
		ТаблицаЗначений = Новый ТаблицаЗначений;		
	#КонецЕсли 
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	Источник = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	Источник.Имя = "ОсновныеДанные";
	Источник.СтрокаСоединения = "";
	Источник.ТипИсточникаДанных = "Local";
	
	НаборДанных = ДобавитьНаборДанных(СхемаКомпоновкиДанных, "объект"); 
	#Если Сервер И НЕ Сервер Тогда
		НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Неопределено);		
	#КонецЕсли
	
	МассивРесурсов = А1Э_Массивы.Массив(Ресурсы);
	МассивГруппировок = А1Э_Массивы.Массив(Группировки);
	Если Колонки = Неопределено Тогда
		ВсеКолонки = Истина;
	Иначе
		ВсеКолонки = Ложь;
		МассивКолонок = А1Э_Массивы.Массив(Колонки);
		А1Э_Массивы.Добавить(МассивКолонок, МассивРесурсов);
		А1Э_Массивы.Добавить(МассивКолонок, МассивГруппировок);
	КонецЕсли;
		
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		Если НЕ ВсеКолонки Тогда
			Если МассивКолонок.Найти(Колонка.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ДобавитьПоле(НаборДанных, Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	Для Каждого Элемент Из МассивРесурсов Цикл
		ПолеРесурса = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
		ПолеРесурса.Выражение = "Сумма(" + Элемент +")";
		ПолеРесурса.ПутьКДанным = Элемент;
	КонецЦикла;
		
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	ПрошлаяГруппировка = Неопределено;
	МассивГруппировок = А1Э_Массивы.Массив(Группировки);
	Если МассивГруппировок.Количество() = 0 Тогда
		МассивГруппировок.Добавить("ДетальныеЗаписи");
	КонецЕсли;
	Для Каждого Элемент Из МассивГруппировок Цикл
		Если ПрошлаяГруппировка = Неопределено Тогда
			Группировка = НастройкиКомпоновкиДанных.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		Иначе
			Группировка = ПрошлаяГруппировка.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		КонецЕсли;
		Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Группировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		ПрошлаяГруппировка = Группировка;
		Если Элемент <> "ДетальныеЗаписи" Тогда
			ПолеГруппировки = Группировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));    
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Поле Из НаборДанных.Поля Цикл
		Если МассивГруппировок.Найти(Поле.Поле) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ВыбранноеПоле = НастройкиКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Заголовок = Поле.Поле;
		ВыбранноеПоле.Использование = Истина;
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(Поле.Поле);
	КонецЦикла;

	Возврат СхемаКомпоновкиДанных;
	
КонецФункции

// Добавляет набор данных в схему компоновки
//
// Параметры:
//  СхемаКомпоновкиДанных	 - 	 - 
//  ВидНабора				 -  - 
//  Имя						 -  - 
//  ИсточникДанных			 - Строка, Неопределено - По умолчанию заполняется первым источником данных.
//  ТекстЗапроса			 - Строка - обязательно для указания если создается наборданныхзапрос.
// 
// Возвращаемое значение:
//   - 
//
Функция ДобавитьНаборДанных(СхемаКомпоновкиДанных, ВидНабора, ИмяНабора = Неопределено, ИсточникДанных = Неопределено, ТекстЗапроса = Неопределено)
	#Если Сервер И НЕ Сервер Тогда
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;		
	#КонецЕсли
	
	ТипНабора = А1Э_СтандартныеТипы.ТипНабораДанныхСКДПолучить(ВидНабора);
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(ТипНабора);
	
	Если ИмяНабора = Неопределено Тогда
		Имя = НовоеИмяНабора();
	КонецЕсли;
	
	НаборДанных.Имя = Имя;
	
	Если ТипНабора <> Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных") Тогда
		Если ИсточникДанных = Неопределено Тогда
			Если СхемаКомпоновкиДанных.ИсточникиДанных.Количество() = 0 Тогда
				А1Э_Служебный.СлужебноеИсключение("При добавлении к СКД набора данных без указания источника данных в СКД уже должен существовать хотя бы один источник!");
			КонецЕсли;
			НаборДанных.ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных[0].Имя;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипНабора = Тип("НаборДанныхОбъектСхемыКомпоновкиДанных") Тогда
		НаборДанных.ИмяОбъекта = Имя;
	ИначеЕсли ТипНабора = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных") Тогда
		Если ТекстЗапроса = Неопределено Тогда
			А1Э_Служебный.СлужебноеИсключение("При добавлении к СКД набора данных типа ""Запрос"" необходимо указать текст запроса!");
		КонецЕсли;
		НаборДанных.Запрос = ТекстЗапроса;
		НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	КонецЕсли;
	
	Возврат НаборДанных;
	
КонецФункции

Функция ДобавитьПоле(НаборДанных, Имя, ТипЗначения)
	Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	Поле.Заголовок = Имя;
	Поле.ПутьКДанным = Имя;
	Поле.Поле = Имя;
	Поле.ТипЗначения = ТипЗначения;
	Возврат Поле;
КонецФункции

Функция НовоеИмяНабора(Определитель = Неопределено)
	Имя = "НаборДанных";
	Если Определитель = Неопределено Тогда
		Возврат Имя;
	ИначеЕсли ТипЗнч(Определитель) = Тип("Число") Тогда
		Имя = Имя + А1Э_Строки.ВСтроку(Определитель);
	ИначеЕсли ТипЗнч(Определитель) = Тип("СхемаКомпоновкиДанных") Тогда
		Имя = Имя + А1Э_Строки.ВСтроку(Определитель.НаборыДанных.Количество() + 1);
	КонецЕсли;
	А1Э_Служебный.ИсключениеНеверныйТип("Определитель", "НовоеИмяНабора", Определитель, "Неопределено,Число,СхемаКомпоновкиДанных");
КонецФункции 

Функция ДобавитьОтбор(КоллекцияНастроек, Имя, Значение, Знач ВидСравнения = "Равно", Контекст = Неопределено) Экспорт
	КоллекцияЭлементов = КоллекцияЭлементовОтбора(КоллекцияНастроек);	
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	УдалитьОтборИзЭлементов(КоллекцияЭлементов, Имя, ВидСравнения);
	ДобавитьОтборВЭлементы(КоллекцияЭлементов, Имя, ВидСравнения, Значение, Контекст); 
КонецФункции

Функция ДобавитьОтборБезЗамены(КоллекцияНастроек, Имя, Значение, Знач ВидСравнения = "Равно", Контекст = Неопределено) Экспорт
	КоллекцияЭлементов = КоллекцияЭлементовОтбора(КоллекцияНастроек);	
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	МассивАналогичныхОтборов = НайтиОтборыВЭлементах(КоллекцияЭлементов, Имя, ВидСравнения);
	Если МассивАналогичныхОтборов.Количество() > 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	ДобавитьОтборВЭлементы(КоллекцияЭлементов, Имя, ВидСравнения, Значение, Контекст);
КонецФункции

Функция НайтиОтборы(КоллекцияНастроек, Имя, Знач ВидСравнения = "Равно") Экспорт
	КоллекцияЭлементов = КоллекцияЭлементовОтбора(КоллекцияНастроек);	
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	Возврат НайтиОтборыВЭлементах(КоллекцияЭлементов, Имя, ВидСравнения);
КонецФункции

Функция УдалитьОтбор(КоллекцияНастроек, Имя, Знач ВидСравнения = "Равно") Экспорт
	КоллекцияЭлементов = КоллекцияЭлементовОтбора(КоллекцияНастроек);
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	Возврат УдалитьОтборИзЭлементов(КоллекцияЭлементов, Имя, ВидСравнения);
КонецФункции

Функция ИспользуемоеЗначениеОтбора(КоллекцияНастроек, Имя, Знач ВидСравнения = "Равно") Экспорт 
	Отборы = НайтиОтборы(КоллекцияНастроек, Имя, ВидСравнения);
	Если Отборы.Количество() = 0 Тогда Возврат Null; КонецЕсли;
	Отбор = Отборы[0];
	Если НЕ Отбор.Используется Тогда Возврат Null; КонецЕсли;
	Возврат Отбор.Значение;
КонецФункции

#КонецЕсли

#Область Служебно_Сервер

Функция ДобавитьОтборВЭлементы(КоллекцияЭлементов, Имя, Знач ВидСравнения, Значение, Знач Контекст = Неопределено) 
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	ЭлементОтбора = КоллекцияЭлементов.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Имя); 
	ЭлементОтбора.ВидСравнения = ВидСравнения; 
	ЭлементОтбора.ПравоеЗначение = Значение; 
	ЭлементОтбора.Использование = Истина;
	Контекст = А1Э_Структуры.Структура(Контекст);
	ЗаполнитьЗначенияСвойств(ЭлементОтбора, Контекст);
	Если А1Э_Структуры.ЗначениеСвойства(Контекст, "Пользовательский") = Истина Тогда
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор());
	КонецЕсли;
	
КонецФункции 

Функция УдалитьОтборИзЭлементов(КоллекцияЭлементов, Имя, Знач ВидСравнения)
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	МассивОтборов = НайтиОтборыВЭлементах(КоллекцияЭлементов, Имя, ВидСравнения);
	Удалено = МассивОтборов.Количество() <> 0;
	Для Каждого Элемент Из МассивОтборов Цикл
		КоллекцияЭлементов.Удалить(Элемент);
	КонецЦикла;
	Возврат Удалено;
КонецФункции

Функция НайтиОтборыВЭлементах(КоллекцияЭлементов, Имя, Знач ВидСравнения)
	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
	
	Результат = Новый Массив;
	
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(Имя);
	Для Каждого Элемент Из КоллекцияЭлементов Цикл
		Если ТипЗнч(Элемент) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если Элемент.ЛевоеЗначение = ПолеКомпоновки И Элемент.ВидСравнения = ВидСравнения Тогда
			Результат.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция КоллекцияЭлементовОтбора(КоллекцияНастроек)
	Если А1Э_Общее.Свойство(КоллекцияНастроек, "Отбор") Тогда
		Если А1Э_Общее.Свойство(КоллекцияНастроек.Отбор, "Элементы") Тогда
			Возврат КоллекцияНастроек.Отбор.Элементы;
		ИначеЕсли ТипЗнч(КоллекцияНастроек.Отбор) = Тип("Отбор") Тогда
			Возврат КоллекцияНастроек.Отбор;
		КонецЕсли;
	КонецЕсли;
	Возврат А1Э_СтандартныеТипы.НастройкиКомпоновкиДанныхПолучить(КоллекцияНастроек).Отбор.Элементы; 
КонецФункции

#КонецОбласти

 
#Область ПроизвольныйОтчет
#Если Клиент Тогда
	
Функция ПроизвольныйОтчет(ТекстЗапроса, ПараметрыЗапроса, СтруктураОтчета = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт 
	ДанныеОтчета = А1Э_ОбщееСервер.РезультатФункции("А1Э_СКД.ПроизвольныйОтчет_ДанныеПоЗапросу", ТекстЗапроса, ПараметрыЗапроса, СтруктураОтчета);
	ПроизвольныйОтчет_ВыполнитьПоказ(ДанныеОтчета, ДополнительныеПараметры);
КонецФункции

Функция ПроизвольныйОтчетПоТаблицеЗначений(АдресТаблицыЗначений, СтруктураОтчета = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	ДанныеОтчета = А1Э_ОбщееСервер.РезультатФункции("А1Э_СКД.ПроизвольныйОтчет_ДанныеПоТаблицеЗначений", АдресТаблицыЗначений, СтруктураОтчета); 	
	ПроизвольныйОтчет_ВыполнитьПоказ(ДанныеОтчета, ДополнительныеПараметры);
КонецФункции

Функция ПроизвольныйОтчет_ВыполнитьПоказ(ДанныеОтчета, ДополнительныеПараметры = Неопределено)
	Параметры = Новый Структура;
	Параметры.Вставить("А1_ПриСозданииНаСервере", "А1Э_СКД.ПроизвольныйОтчет_ПриСозданииНаСервере");
	Параметры.Вставить("ДанныеОтчета", ДанныеОтчета);
	Если А1Э_Структуры.ЗначениеСвойства(ДополнительныеПараметры, "ЗаголовокФормы") <> Неопределено Тогда
		Параметры.Вставить("А1_ЗаголовокФормы", ДополнительныеПараметры.ЗаголовокФормы);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.А1Э_УниверсальнаяФорма", Параметры, , , , , , РежимОткрытияОкнаФормы.Независимый);
КонецФункции

Функция ПроизвольныйОтчет_ОбработкаРасшифровки(Форма, Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	Перем ВыполненноеДействие;
	
	СтандартнаяОбработка = Ложь;
	
	Значение = А1Э_ОбщееСервер.РезультатФункции("А1Э_СКД.ПроизвольныйОтчет_ПолучитьЗначениеРасшифровки", Форма.ДанныеРасшифровки, Форма.АдресСКД, Расшифровка);
	
    ПоказатьЗначение(, Значение);    
	
КонецФункции

#КонецЕсли
 
#Если НЕ Клиент Тогда
	
	Функция ПроизвольныйОтчет_ДанныеПоЗапросу(ТекстЗапроса, Параметры, СтруктураОтчета) Экспорт 
		ТаблицаЗначений = А1Э_Запросы.Запрос(ТекстЗапроса, Параметры).Выполнить().Выгрузить();
		Возврат ПроизвольныйОтчет_Данные(ТаблицаЗначений, СтруктураОтчета);
	КонецФункции
	
	Функция ПроизвольныйОтчет_ДанныеПоТаблицеЗначений(АдресТаблицыЗначений, СтруктураОтчета) Экспорт 
		ТаблицаЗначений = ПолучитьИзВременногоХранилища(АдресТаблицыЗначений);
		Возврат ПроизвольныйОтчет_Данные(ТаблицаЗначений, СтруктураОтчета);
	КонецФункции
	
	Функция ПроизвольныйОтчет_Данные(ТаблицаЗначений, СтруктураОтчета) 
		Результат = Новый ТабличныйДокумент;
		ДанныеРасшифровки = "";
		АдресСКД = "";
		
		РезультатВыполненияПоТаблицеЗначений(ТаблицаЗначений, , СтруктураОтчета, Результат, ДанныеРасшифровки, АдресСКД);
		Возврат Новый Структура("Результат,ДанныеРасшифровки,АдресСКД", Результат, ПоместитьВоВременноеХранилище(ДанныеРасшифровки, Новый УникальныйИдентификатор), АдресСКД);
	КонецФункции
	
	Функция ПроизвольныйОтчет_ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
		МассивОписаний = Новый Массив;
		Параметры = Новый Структура("ТолькоПросмотр,ПоложениеЗаголовка", Истина, ПоложениеЗаголовкаЭлементаФормы.Нет);
		Действия = Новый Структура("ОбработкаРасшифровки", "А1Э_СКД.ПроизвольныйОтчет_ОбработкаРасшифровки");
		А1Э_Формы.ДобавитьОписаниеРеквизитаИЭлемента(МассивОписаний, "Результат", "ТабличныйДокумент", , , , , Параметры, Действия);
		А1Э_Формы.ДобавитьОписаниеРеквизита(МассивОписаний, "ДанныеРасшифровки", "Строка");
		А1Э_Формы.ДобавитьОписаниеРеквизита(МассивОписаний, "АдресСКД", "Строка");
		
		А1Э_УниверсальнаяФорма.ДобавитьРеквизитыИЭлементы(Форма, МассивОписаний);
		
		Форма.Результат = Форма.Параметры.ДанныеОтчета.Результат;
		Форма.ДанныеРасшифровки = Форма.Параметры.ДанныеОтчета.ДанныеРасшифровки;
		Форма.АдресСКД = Форма.Параметры.ДанныеОтчета.АдресСКД;
		
	КонецФункции
	
	Функция ПроизвольныйОтчет_ПолучитьЗначениеРасшифровки(АдресРасшифровки, АдресСКД, Расшифровка) Экспорт
		//ОбработкаРасшифровки =  Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
		ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресРасшифровки);
		
		МассивПолей = ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьПоля();
		Если МассивПолей.Количество() > 0 Тогда
			Возврат МассивПолей[0].Значение;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецФункции 
#КонецЕсли 
#КонецОбласти 

#Область БудущиеИдеи

//Функция ДобавитьПользовательскийОтбор(КоллекцияНастроек, Имя, Значение, Знач ВидСравнения = "Равно") Экспорт 
//	ПользовательскиеНастройки = А1Э_СтандартныеТипы.ПользовательскиеНастройкиКомпоновкиДанныхПолучить(КоллекцияНастроек);
//	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
//	
//	Для Каждого Элемент Из КоллекцияЭлементов Цикл
//		Если ТипЗнч(Элемент) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
//			Продолжить;
//		КонецЕсли;
//		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Имя) И Элемент.ВидСравнения = ВидСравнения Тогда
//			Элемент.Значение = Значение;
//			Элемент.Использование = Истина;
//		КонецЕсли;
//	КонецЦикла;
//	
//КонецФункции

//Функция УдалитьПользовательскийОтбор(КоллекцияНастроек, Имя, ВидСравнения = "Равно") Экспорт
//	ПользовательскиеНастройки = А1Э_СтандартныеТипы.ПользовательскиеНастройкиКомпоновкиДанныхПолучить(КоллекцияНастроек);
//	ВидСравнения = А1Э_СтандартныеТипы.ВидСравненияКомпоновкиДанныхПолучить(ВидСравнения);
//	
//	Для Каждого Элемент Из КоллекцияЭлементов Цикл
//		Если ТипЗнч(Элемент) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
//			Продолжить;
//		КонецЕсли;
//		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Имя) И Элемент.ВидСравнения = ВидСравнения Тогда
//			Элемент.Использование = Ложь;
//		КонецЕсли;
//	КонецЦикла;
//	
//КонецФункции 

#КонецОбласти 

#Область КомпоновщикНастроек

Функция ЗначениеПараметраДанных(КомпоновщикНастроек, ИмяПараметра) Экспорт
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если Параметр = Неопределено Тогда
		Возврат Null;
	КонецЕсли;
	ПользовательскаяНастройка = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
	Если ПользовательскаяНастройка = Неопределено Тогда
		Возврат ПримитивноеЗначениеПараметрыНастроек(Параметр);
	Иначе
		Возврат ПримитивноеЗначениеПараметрыНастроек(ПользовательскаяНастройка);
	КонецЕсли;
КонецФункции

Функция ПримитивноеЗначениеПараметрыНастроек(ПараметрНастроек) 
	Если ПараметрНастроек.Использование = Истина Тогда
		Если ТипЗнч(ПараметрНастроек.Значение) = Тип("СтандартнаяДатаНачала") Тогда
			Возврат ПараметрНастроек.Значение.Дата
		Иначе
			Возврат ПараметрНастроек.Значение;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции 

Функция АктуальныйЭлементОтбора(КомпоновщикНастроек, Имя, ВидСравнения = "Равно") Экспорт 
	Отборы = НайтиОтборыВЭлементах(КомпоновщикНастроек.Настройки.Отбор.Элементы, Имя, ВидСравнения);
	Если Отборы.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	Отбор = Отборы[0];
	ПользовательскаяНастройка = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Отбор.ИдентификаторПользовательскойНастройки);
	Если ПользовательскаяНастройка = Неопределено Тогда
		Возврат Отбор;
	Иначе
		Возврат ПользовательскаяНастройка;
	КонецЕсли;
КонецФункции

Функция ОтборИспользуется(КомпоновщикНастроек, Имя, ВидСравнения = "Равно") Экспорт
	АктуальныйЭлементОтбора = АктуальныйЭлементОтбора(КомпоновщикНастроек, Имя, ВидСравнения);
	Если АктуальныйЭлементОтбора = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат АктуальныйЭлементОтбора.Использование;
КонецФункции 
#КонецОбласти 
