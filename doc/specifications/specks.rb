

##
#Класс для обработки запросов от клиентов через протокол FastCGI
#Должен принимать запрос в формате json, обрабатывать его и возращать ответ.
#Протокол взаимодействия описан в спеках клиент-серверного взаимодействия.
class FastCGIPoint
	#ctor
	def initialize
	end
	#запускает обработчик запросов
	def start
	end
end

##
#Обеспечивает обработку (распарсивание) JSON формата, который посупает (должен поступать) в запросе к веб-серверу
#Возвращает объект типа JsonObject (распарсенная информация)
#Работает и в обратную сторону, т.е. по информации возращает JSON-строку, которая отдается клиентну веб-сервером.
#Внутри находиться JSON-парсер (какая-то его реализация).
class Parser
	#ctor
	def initialize
	end
	def parse(a_str)
	end
	def toJsonForLogin(a_parsedInfo)
	end
	def toJsonForIm(a_parsedInfo)
	end
end

##
#Хранит информацию запроса/ответа в нормальной, удобной для использования(не текст, а нормальные переменные)
#Во внутреннем формате в виде стандартых типов ruby, массивы и хеши
class JsonObject
	#ctor
	def initialize()
	end
	#Получить session_id из распарсенной инфы
	def sessionId
	end
	#Получить JID из распарсенной инфы
	def jid
	end
	#Получить адрес сервера из распарсенной инфы
	def server
	end
	#Получить пароль из распарсенной инфы
	def pass
	end

	#Возвращает объект-ответ на запрос логина в случае _неудачи_
	#a_error:: [String] text error
	#result:: [ParsedInfo]
	def ParsedInfo.loginFailed(a_error)
	end

	#Возвращает объект-ответ на запрос логина в случае удачи
	#a_sid:: [String] session_id
	#result:: [ParsedInfo]
	def ParsedInfo.loginSuccessfully(a_sid)
	end

	#Записать данные
	def data=(a_data)
	#Получить данные (в формате стандартных типов руби)
	def data
	end
end

#Хранит и управляет всеми клиентами
#Внутри есть хеш (ключ - сторока хранящая session_id, значение - объект типа Client), хранящий всех клиентов.
#Те кто находятся в этом хеше --- активные клиенты, не активные клиенты (долго не проявлявшие активность) из него удаляются
#Есть возможность добавлять/удалять клиентов, а так же чистить неактивных клиентов.
#Дает доступ к контретному клиенту по строке, содержащей session_id
#Является синглетоном
#Уникальные session_id генерятся в нем же.
class ClientManager
	def addClient(a_client)
	end
	def delClient(a_sessionId)
	end
	#Возращает клиента по id
	def [](a_sessionId)
	end
	def clear
	end
	def delNoActiveClients
	end
	#Возращает строку, представляющую новый уникальный sessin_id
	def ClientManager.getNewSessionId
	end
	@clients
end

#Хранит информацию об отдельно взятом клиенте(всмысле юзера, а не джаббер клиента)
#В нем хранится джаббер клиент(jabberClient)  (объект типа JabberClient), auth (объект типа AuthInfo)
#Так же в нем производится обработка parsedInfo (там производятся все действия запрошенные пользователем, а так же отдаются события произошедшие между вызовами, такие как входящие сообщения ) 
class Client
	#Cоздание клиента. Должен учитывать сервер по умолчанию из jid'a, и порт по умолчанию (5222)
	#В качестве параметра передается хеш, для удобства
	#Возможные параметры:
	#:jid => [String]
	#:password => [String]
	#:server=> [String]
	#:port => [Integer]
	def initialize(a_hashAgrs)
	end
	#Выполнение запроса клиента
	#Возвращает объект типа ParsedInfo, в котором хранится информация которую надо отправить клиенту.
	#Ему передается объект типа parsedInfo в котором содержится распарсенный запрос клиента
	#Сам метод взаимодействует через объект executerRequets.
	def runRequest(a_parsedRequest)
	end
	
	#Возращает @jabberClient
	def jabberClient
	end

	#Возращает @auth
	def auth
	end

	##
	#Попытка подключиться к джаббер-серверу, вызывает исключения в случае ошибки
	#Если исключения нет, то его должен добавить clientManager в свой список
	def connect
	end
	
	@jabberClient
	@auth
end

##
#Хранить авторизационные данные клиента, пока только время последней активности, с помощью которого можно найти неактивных клиентов, должна обновлятся с каждым запросом
class AuthInfo
	def lastActivity
	end
	def updateLastActivity
	end
	@lastActivity
end

##
#Оболочка над библиотекой xmpp
#Содержит в себе ростер, джаббер клиент из библиотеки, мук клиент и т.д.
#Содержит все обработчики входящих сообщений/действий, а также очередь где они сохраняются
#Содержит базовый набор методов для отправки сообщений и действий с ростером
#потом он будет расширяться
#внешний интерфейс не должен зависить от библиотеки xmpp, через этот интерфейс будет взаимодействовать метод runRequest в классе Client
class JabberClient
	##
	#ctor
	#Не конектится к серверу, коннект обеспечивает метод connect
	#a_jid:: [String]
	#a_pass:: [String]
	#a_server:: [String]
	#a_port:: [Integer]
	def initialize(a_jid, a_pass, a_server, a_port)
	end
	
	##
	#Попытка конектится к серверу,
	#если неудачно, вызывает исключение
	def connect
	end
	
	##
	#Полная инициализация джаббер клиента, т.е. прикрипление обработчиков событий
	def fullInit
	end


	##
	#Завершение соединения
	def closeConnection
	end
	
	##
	#Установка статуса
	#a_show тип статуса, возможные значения ={ :chat => 4, nil/:online => 3, :dnd => 2, :away => 1, :xa => 0, :unavailable => -1, :error => -2 }
	#a_status - текст статуса,
	#a_priority - приоритет текущего подключения
	#Статус устанавливается немедленно
	def setStatus(a_show=nil, a_status=nil, a_priority=nil)
	end

	##
	#Послать сообщение
	#a_to:: [String] кому
	#a_type:: [Symbol] тип сообщения, возможные значения:   :chat, :error, :groupchat, :headline, :normal
	#a_text:: [String] текст сообщения
	#a_subject:: [String] тема сообщения, используется в :normal сообщениях, они как почта, поэтому и с темой 
	def sendMessage(a_to,a_text,a_type,a_subject=nil)
	end

	##
	#Послать чатовое сообщение
	#Синтаксический сахар для sendMessage(,,:chat)
	#a_to:: [String] кому
	#a_text:: [String] текст сообщения
	def sendChatMessage(a_to, a_text)
	end

	##
	#Пройтись по всем входящим сообщениям
	#Очередь сообщений после вызова метода очищается!!!
	#Методу нужно передавать замыкание, обрабатывающее сообщения
	#a_closure:: [CodeBlock]
	#Замыканию передаются:
 	# * from:: [String] jid того, кто передал сообщение
	# * type:: [Symbol] тип сообщения
	# * text:: [String] текст сообщения
	# * subject:: [String] or nil, тема сообщения(только для нечатовых)
	# * time:: [Time] время прихода сообщения
	def eachIncomingMessages(&a_closure)
	end

	##
	#Пройтись по контактам в ростере
	#Методу нужно передавать замыкание
	#a_closure:: [CodeBlock]
	#Замыканию передаются 	group:: [String] or nil	имя группы в которой находится контакт
	#			jid:: [String]		jid контакта
	#			name:: [String] or nil 	имя контакта, под которым он записан в ростере
	def eachJIDinRoster(&a_closure)
	end
	
	##
	#Пройтись по всем изменениям в статусе
	#Note: сначало приходит сразу много сообщений.
	#Методу нужно передавать замыкание
	#a_closure:: [CodeBlock]
	#Замыканию передаются:
	# * jid:: [String], jid сменившего статус	
	# * newShow:: [Symbol], тип статуса, аналогичен типу в setStatus
	# * newStatus:: [String], текст статусного сообщения, его может и не быть (пустая строка)
	# * oldShow:: [Symbol], предыдущий тип статуса
	# * oldStatus:: [String], предыдущий текст статусного сообщения
	def eachPresences(&a_closure)
	end


end



##
#Класс, который реализует алгоритм выполнения запроса клиента.
#Создан чтобы вынести алгоритм из класса клиента, в случае смены/добавления новых видов запросов
#меняется это класс или пишется другой, с таким же интерфейсом.
class ExecuterRequest
	#Выполняет запрос пользователя.
	#Возращает объект JsonObject с ответом клиенту
	#Инкапсулирует в себе алгорим обработки запроса.
	#a_request:: [JsonObject] объект с запросом
	def execute(a_request)
	end

private:
	#Выполнение запроса для залогиненного клиента
	#a_request объект типа ParsedInfo, содержащий запрос
	#a_jabberClient объект над которым будут выполнятся действия.
	def runForClient(a_request,a_jabberClient)
	end
end

#note:Используемая библиотека xmpp xmmp4r

