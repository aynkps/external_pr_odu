//ВнОбработка ОМ.оду_ОбменДанными

#Область  Регистрация

#Область  СлужебныеПроцедурыИФункции


Функция РазрешенаРегистрацияОбъектаОбменаПоОтбору(Источник, СтруктураНастроекОбмена, ПриоритетДопПризнака = 0) Экспорт
	
	//Проверка Индивидуальных Отборов Регистрации Объектов Обмена   
	Если ПроходитИндивидуальныеНастройкиОтборовРегистрацииОбъектовОбмена(Источник, СтруктураНастроекОбмена) = Ложь Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	Если ПриоритетДопПризнака = 0 Тогда
		Возврат РазрешенаРегистрацияОбъектаОбменаПоОтборуИзНастроек(Источник, СтруктураНастроекОбмена);	
	Иначе //Своя регистрация из обработки
	    СтруктураНастроекОбмена.ПриоритетДопПризнака = ПриоритетДопПризнака;
		Возврат Истина;	
	КонецЕсли; 
	
КонецФункции

//Основной обор и проверка на регистрацию объекта УО 
Функция РазрешенаРегистрацияОбъектаОбменаПоОтборуИзНастроек(Источник, СтруктураНастроекОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	 
	РазрешенаРегистрация = Ложь;
	
	Попытка
	
		ОбработкаРегистрации = СтруктураНастроекОбмена.ОбработкаРегистрации;
		
		Если ОбработкаРегистрации = Неопределено Тогда
			Если ЗначениеЗаполнено(СтруктураНастроекОбмена.ПравилоРегистрации) Тогда
				//01 из С_оду_ПравилаРегистрацииОбмена.ПравилоРегистрации 
				//Выполнить("РазрешенаРегистрация = " + СтруктураНастроекОбмена.ПравилоРегистрации);	
				Выполнить(СтруктураНастроекОбмена.ПравилоРегистрации);	
			Иначе //???
				//02 Этот общий модуль
				РазрешенаРегистрация = ИсполняемаяФункцияПроверкиРегистрацииОбъектаОбменаПоОтборуИзНастроек(Источник, СтруктураНастроекОбмена);
			КонецЕсли; 	
		Иначе
			Если ТипЗнч(ОбработкаРегистрации) = Тип("Строка") Тогда
				//03 внешн. обработка файловая из  С_оду_ПравилаРегистрацииОбмена.ПутьКОбработкеОтладки 
				ВнОбработка = пр_Общий.ПолучитьВнешнююОбработкуПоПути(ОбработкаРегистрации);
				РазрешенаРегистрация = ВнОбработка.ИсполняемаяФункцияПроверкиРегистрацииОбъектаОбменаПоОтборуИзНастроек(Источник, СтруктураНастроекОбмена);
			ИначеЕсли ТипЗнч(ОбработкаРегистрации) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
				//04 БСП внешн. обработка из С_оду_ПравилаРегистрацииОбмена.ОбработкаОтладкиБСП 
				ВнОбработка = пр_Общий.ВнешняяОбработкаБСП( , ОбработкаРегистрации);
				РазрешенаРегистрация = ВнОбработка.ИсполняемаяФункцияПроверкиРегистрацииОбъектаОбменаПоОтборуИзНастроек(Источник, СтруктураНастроекОбмена);
			КонецЕсли; 	
		КонецЕсли;
			
	Исключение
		пр_Ошибка = ОписаниеОшибки();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = пр_Ошибка;
		Сообщение.Сообщить(); 
		оду_общий.ОтправитьСообщениеВТелеграмExchange("оду_ОбменДанными.РазрешенаРегистрацияОбъектаОбменаПоОтборуИзНастроек", , пр_Ошибка, СтруктураНастроекОбмена.БазаПриемник, , , СтруктураНастроекОбмена);	
	КонецПопытки;
		
	Возврат РазрешенаРегистрация;

КонецФункции // ()

//Текст проверки регистрации
Функция ИсполняемаяФункцияПроверкиРегистрацииОбъектаОбменаПоОтборуИзНастроек(Источник, СтруктураНастроекОбмена)

	РезультатРегистрацииОбъектаОбмена = Истина;
	
	//TODO:  +++ Своя логика отбора
	Если СтруктураНастроекОбмена.МетаданныеНаименование = "Документы" Тогда	
		
		//Условние на огранияения
		Если СтруктураНастроекОбмена.ЕстьОграничениеНаОрганизации Тогда
		
		КонецЕсли;
		
	КонецЕсли; 
	
	Возврат РезультатРегистрацииОбъектаОбмена;	

КонецФункции // ()


#КонецОбласти


#Область  ИндивидуальныеНастройкиОтборовРегистрацииОбъектовОбмена

//Дополнительные Индивидуальные отборы УО 
Функция ПроходитИндивидуальныеНастройкиОтборовРегистрацииОбъектовОбмена(Источник, СтруктураНастроекОбмена)
		
	//Проверка по типу объекта
	Если СтруктураНастроекОбмена.МетаданныеНаименование = "Документы" Тогда
		
		//Регистрация только на проведенные документы исключение
		Если НЕ (СтруктураНастроекОбмена.ТипXMLОбъектаИсточника = "DocumentRef.КорректировкаРегистров" ИЛИ 
			 					СтруктураНастроекОбмена.ТипXMLОбъектаИсточника = "DocumentRef.ОперацияБух") Тогда
			Если НЕ (СтруктураНастроекОбмена.РежимЗаписи = РежимЗаписиДокумента.Проведение ИЛИ Источник.Проведен) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		//TODO:  Переделать
		//Установка органичения на изменение объектов
		Если Источник.Дата < Дата("20210101") Тогда
			Возврат Ложь;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Источник.Номер)  Тогда
			Если НЕ ОбъектСозданВЭтойБазе(Источник.Номер, СтруктураНастроекОбмена.ИДКонфигурацииТекущейБД) Тогда
				
				//Особый случай, когда нужно проводить доки в этой базе
				Если пр_НастройкиПовтИсп.ЕстьДоступПроводитьДокументыСозданныеНеВЭтойБазе(пр_НастройкиПовтИсп.ТекущийПользователь()) Тогда
					Возврат Ложь;
				КонецЕсли; 
				
				//TODO: //ВозвратТоваровОтКлиента - особый случай 
				Если  ТипЗнч(Источник) = Тип("ДокументОбъект.ВозвратТоваровОтКлиента") Тогда  
					Возврат Ложь;
				КонецЕсли;
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Запрещено менять объекты созданыные в базе УТ ""Переход""";
				Сообщение.Сообщить(); 
				СтруктураНастроекОбмена.Отказ = Истина;
				
				Возврат Ложь;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли; 
	
	Возврат Истина;
	
КонецФункции


Функция ОбъектСозданВЭтойБазе(КодНомер, ИДКонфигурации = "") Экспорт 
	
	//TODO:  костыль
	Если НЕ ЗначениеЗаполнено(ИДКонфигурации)  Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Если ИДКонфигурации = "УТ"  Тогда
		ПрефиксЭтойБД = оду_ОбщийПовтИсп.ПрефиксЭтойИБ();
		ПрефиксДок = Лев(КодНомер, 4);
		Возврат  СтрНайти(ПрефиксДок, ПрефиксЭтойБД) <> 0;
	ИначеЕсли ИДКонфигурации = "УТАП" Тогда
		ПрефиксУТ_Переход = "ПР";
		ПрефиксДок = Лев(КодНомер, 4);
		Возврат  СтрНайти(ПрефиксДок, ПрефиксУТ_Переход) = 0;
	Иначе
		Возврат Истина;
	КонецЕсли; 
	
КонецФункции 

#КонецОбласти


//TODO:  
// Проверка есть ли объект в Приеменике, с вопросом, может не нужно выгружать повторно, если не было изменений
#Область  Самолет

//возможо сразу отбор
//доки свои проверки  и тд
Функция ПроверитьМассивОбъектовОбмена(МассивСсылокНаОбъект, ИмяТипа, ИДКонфигурации) Экспорт
	
	ПоляЗаполнения = "Номер, Представление";
	
	Модуль = пр_НастройкиПовтИсп.ИсполняемыйМодуль("пр_Общий", пр_НастройкиПовтИсп.ТекущийПользователь()); 
	ВДЗ = Модуль.ДанныеИБПоСсылкам(МассивСсылокНаОбъект, ПоляЗаполнения, ИмяТипа); 
	
	Если ТипЗнч(ВДЗ) = пр_НастройкиПовтИсп.ТипСтрока() Тогда
		Возврат МассивСсылокНаОбъект;
	КонецЕсли;
	
	МассивОбъектовОбмена = Новый Массив; 
	Пока ВДЗ.Следующий() Цикл
		//TODO:  
		Если ОбъектСозданВЭтойБазе(ВДЗ.Номер, ИДКонфигурации) Тогда //СтруктураНастроекОбмена.ИДКонфигурации) Тогда  //не для всех 
			
			МассивОбъектовОбмена.Добавить(ВДЗ.Ссылка);
			
		Иначе 
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя передавать объекты созданные не в этой базе. " + ВДЗ.Представление;
			Сообщение.Сообщить(); 
		КонецЕсли;
	КонецЦикла; 
	
	Возврат МассивОбъектовОбмена;
	
КонецФункции 

Функция МассивОбъектовОбменаСамолетПоОтбору(СтруктураНастроекОбменаНач)  Экспорт
	
	ИмяТипа = СтруктураНастроекОбменаНач.ИмяТипа;
	НастройкиТекущейБД = СтруктураНастроекОбменаНач.НастройкиТекущейБД;	
	
	Если СтрНайти(ИмяТипа, "DocumentRef") > 0  Тогда
		МассивОбъектовОбмена = ПроверитьМассивОбъектовОбмена(СтруктураНастроекОбменаНач.МассивОбъектовОбмена, ИмяТипа, НастройкиТекущейБД.ИДКонфигурации);
	Иначе
		МассивОбъектовОбмена = СтруктураНастроекОбменаНач.МассивОбъектовОбмена;
	КонецЕсли;   
	
	Возврат  МассивОбъектовОбмена;
	
КонецФункции

Процедура ЗаполнитьСтруктурыДопДаннымиМассива(МассивУчастниковОбмена, МассивОбъектовОбмена, ПриоритетОбмена = 50)
	
	ДатаРегистрации = ?(ПриоритетОбмена = 10, Неопределено, ТекущаяДатаСеанса());
	
	Для каждого СтруктураНастроекОбмена Из МассивУчастниковОбмена Цикл
		
		СтруктураНастроекОбмена.Вставить("ОбъектыОбмена", МассивОбъектовОбмена);
		МассивИДОбъектов = Новый Массив;
		Для каждого ОбъектОбмена Из МассивОбъектовОбмена Цикл
			МассивИДОбъектов.Добавить(XMLСтрока(ОбъектОбмена));	
		КонецЦикла; 
		СтруктураНастроекОбмена.Вставить("МассивИДОбъектов", МассивИДОбъектов);
		СтруктураНастроекОбмена.Вставить("ПриоритетОбмена", ПриоритетОбмена); 
		СтруктураНастроекОбмена.Вставить("ПриоритетДопПризнака", 0);
		СтруктураНастроекОбмена.Вставить("ДатаРегистрации", ДатаРегистрации);
		
	КонецЦикла;
	
КонецПроцедуры


// Б Режим Самолет - ручная регистация, быстрый транспорт
// доп. требования может быть несколько однотипных объектов + Обязательный диалог с пользователем (показ сообщений итд)
//1. Ограничить объекты в режиме загрузка, с выводом сообщений
//2. Менять только приоритет, ДатаРегистрации - пустая	
//3. Сообщать, что объекты уже зарегистрированы, либо в пути. 
//TODO:  
// Возможно были выгружены, но пользователь продолжает нажимать на самолет
// если изменений объекта не было - то при первичной отправке на проверку данных на существование в базе приемнике, не производит повторную выгрузку
//
//Количество ошибок не > 3
Процедура ЗарегистрироватьСамолетДляОбъектов(МассивУчастниковОбмена, ТипXML)
 	
	//Данные к регистрации, дальнейшая проверка
	МассивДанных = Новый Массив;
	
	
	
	
КонецПроцедуры

Процедура ЗарегистрироватьСамолетДляДокументов(МассивОбъектовОбмена, ТипXML, СтруктураНастроекОбмена)
	
	//Данные к регистрации, дальнейшая проверка
	МассивДанных = Новый Массив;
	
	//Нужен свой запрос
	
	Для каждого ОбъектОбмена Из МассивОбъектовОбмена Цикл

		//TODO: Проверить на подзапрос в цикле
		Если ОбъектСозданВЭтойБазе(ОбъектОбмена.Номер, СтруктураНастроекОбмена.ИДКонфигурации) Тогда
			
			СтруктураНастроекОбмена.Вставить("ОбъектОбмена", ОбъектОбмена.Ссылка);
			РезультатРегистрацииОбъектаОбмена = оду_Общий.РезультатРегистрацииОбъектаОбмена(СтруктураНастроекОбмена);
					
			Если РезультатРегистрацииОбъектаОбмена = Ложь Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон("Не удалось зарегистрировать в базу %1 объект обмена %2", СтруктураНастроекОбмена.ИДБазыПриемник, Строка(ОбъектОбмена));
				Сообщение.Сообщить(); 
			КонецЕсли; 

		Иначе 
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя передавать объекты созданные не в этой базе. " + Строка(ОбъектОбмена);
			Сообщение.Сообщить(); 
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗарегистрироватьСамолетСправочники(МассивОбъектовОбмена, ТипXML, СтруктураНастроекОбмена)
	
	Для каждого ОбъектОбмена Из МассивОбъектовОбмена Цикл
	
		
	
	КонецЦикла; 
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#Область  ПроизвольныйОбменПоИмениМетода

Функция РезультатExchangeData(ТелоЗапроса) Экспорт
	
	Попытка
		
		СтруктураНастроек = ТелоЗапроса.instruct;
		Данные = ТелоЗапроса.data;
		
		//TODO:  
		//Если НЕ ЗначениеЗаполнено(Данные)  Тогда
		//	Возврат Неопределено;		
		//КонецЕсли;
		//
		//Если Данные.Количество() = 0 Тогда
		//	Возврат Неопределено;		
		//КонецЕсли; 	

		ИДЗапроса = СтруктураНастроек.ИДЗапроса;
		
		пр_Модуль = пр_Общий.ИсполняемыйМодуль(ИДЗапроса, пр_НастройкиПовтИсп.ТекущийПользователь()); 
		Если пр_Модуль <> Неопределено Тогда
			Возврат пр_Модуль.Ответ(СтруктураНастроек);
		КонецЕсли; 
		
		Результат = Неопределено;
		ИмяМетода = ИДЗапроса + "_Ответ(СтруктураНастроек)";
		Выполнить("Результат = " + ИмяМетода);
	
		Возврат Результат;
		
	Исключение
		пр_Ошибка = ОписаниеОшибки();
		оду_общий.ОтправитьСообщениеВТелеграмExchange("оду_ОбменДанными.РезультатExchangeData", , пр_Ошибка, ТелоЗапроса.header.front, , , ТелоЗапроса);	
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции 

Функция ОтчетОстаткиТоваровЕГАИС_Ответ(СтруктураПараметров) Экспорт
	
	ИмяЗапроса = "Ответ_" + СтруктураПараметров.ИДЗапроса;
	
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияОстатковЕГАИС();
		
		//Запрос.Параметры.Вставить("ПериодСреза", СтруктураПараметров.ПериодСреза);
				
		РЗ = Запрос.Выполнить();
		
		Если РЗ.Пустой() Тогда
			Возврат Неопределено;
		КонецЕсли; 
		
		
		ВДЗ = РЗ.Выбрать();
		
		Результат = Новый Массив;
		
		Пока ВДЗ.Следующий() Цикл
			
			СтруктураДанных = Новый Структура();
			
			СтруктураДанных.Вставить("Организация", оду_Общий.СтруктураСсылки(ВДЗ.Организация, ВДЗ));
			СтруктураДанных.Вставить("Номенклатура", оду_Общий.СтруктураСсылки(ВДЗ.Номенклатура, ВДЗ));
			СтруктураДанных.Вставить("СерияНоменклатуры", оду_Общий.СтруктураСсылки(ВДЗ.СерияНоменклатуры, ВДЗ));
			
			СтруктураДанных.Вставить("НоменклатураЕГАИС", ВДЗ.НоменклатураЕГАИС);
			СтруктураДанных.Вставить("СправкаА", ВДЗ.СправкаА);
			СтруктураДанных.Вставить("СправкаБ", ВДЗ.СправкаБ);
			СтруктураДанных.Вставить("СправкаАДатаРозлива", ВДЗ.СправкаАДатаРозлива);
			СтруктураДанных.Вставить("КоличествоОстаток", ВДЗ.КоличествоОстаток);
			СтруктураДанных.Вставить("КоличествоОстатокЕГАИСКоэфДалл", ВДЗ.КоличествоОстатокЕГАИСКоэфДалл);
			СтруктураДанных.Вставить("КоэфДалл", ВДЗ.КоэфДалл);
			
			Результат.Добавить(СтруктураДанных);
			
		КонецЦикла;
				
	Исключение
		Ошибка = ОписаниеОшибки();
		оду_Общий.ОтправитьСообщениеВТелеграмExchange(ИмяЗапроса, Ошибка);	
		Возврат Неопределено;
	КонецПопытки;	
	
	Возврат  Результат;
	
КонецФункции 


#Область  Служебные

#Область  ПолученияДанныхПроизвольногоЗапроса

Функция ТекстЗапросаПолученияОстатковЕГАИС()
	
	Возврат
		"ВЫБРАТЬ
		|	астПартииТоваровПоСправкамЕГАИСОстатки.Организация КАК Организация,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.НоменклатураЕГАИС.Код КАК НоменклатураЕГАИС,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.Номенклатура КАК Номенклатура,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.СерияНоменклатуры КАК СерияНоменклатуры,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.СправкаА.Код КАК СправкаА,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.СправкаБ.Код КАК СправкаБ,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.СправкаА.ДатаРозлива КАК СправкаАДатаРозлива,
		|	астПартииТоваровПоСправкамЕГАИСОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	ВЫБОР
		|		КОГДА астПартииТоваровПоСправкамЕГАИСОстатки.НоменклатураЕГАИС.НефасованнаяПродукция
		|			ТОГДА ВЫБОР
		|					КОГДА астПартииТоваровПоСправкамЕГАИСОстатки.Номенклатура.ОбъемДАЛ = 0
		|						ТОГДА 0
		|					ИНАЧЕ астПартииТоваровПоСправкамЕГАИСОстатки.Номенклатура.ОбъемДАЛ
		|				КОНЕЦ
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК КоэфДалл
		|ПОМЕСТИТЬ ВТ_ОтстакиЕГАИС
		|ИЗ
		|	РегистрНакопления.астПартииТоваровПоСправкамЕГАИС.Остатки(, ) КАК астПартииТоваровПоСправкамЕГАИСОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОтстакиЕГАИС.Организация КАК Организация,
		|	ВТ_ОтстакиЕГАИС.НоменклатураЕГАИС КАК НоменклатураЕГАИС,
		|	ВТ_ОтстакиЕГАИС.Номенклатура КАК Номенклатура,
		|	ВТ_ОтстакиЕГАИС.СерияНоменклатуры КАК СерияНоменклатуры,
		|	ВТ_ОтстакиЕГАИС.СправкаА КАК СправкаА,
		|	ВТ_ОтстакиЕГАИС.СправкаАДатаРозлива КАК СправкаАДатаРозлива,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ВТ_ОтстакиЕГАИС.КоэфДалл, 0) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТ_ОтстакиЕГАИС.КоличествоОстаток / ВТ_ОтстакиЕГАИС.КоэфДалл
		|	КОНЕЦ КАК КоличествоОстаток,
		|	ВТ_ОтстакиЕГАИС.КоличествоОстаток КАК КоличествоОстатокЕГАИСКоэфДалл,
		|	ВТ_ОтстакиЕГАИС.КоэфДалл КАК КоэфДалл,
		|	ВТ_ОтстакиЕГАИС.СправкаБ КАК СправкаБ
		|ИЗ
		|	ВТ_ОтстакиЕГАИС КАК ВТ_ОтстакиЕГАИС
		|ГДЕ
		|	ВТ_ОтстакиЕГАИС.КоличествоОстаток > 0
		|";
	
КонецФункции 

#КонецОбласти
 

#КонецОбласти
 


#КонецОбласти

//ВнОбработка ОМ.оду_ОбменДанными