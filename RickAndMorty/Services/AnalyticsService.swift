//
//  AnalyticsService.swift
//  RickAndMorty
//
//  Created by Juliano on 07/10/25.
//

import FirebaseAnalytics


// MARK: - Events

enum AnalyticsEvent {
    
    case characterSelection(CharacterSelectedEvent)
    case screenView(ScreenViewEvent)
    case actionPerformed(ActionEvent)
    case custom(name: String, parameters: [String: String] = [:])
    
    var eventName: String { //  case characterSelection // O rawValue padrão é "characterSelection" se nao quisermos ter esas var
        switch self {
        case .characterSelection: return "CharacterSelected"
//        case .characterSelection: "characterSelection"
//        case .characterSelection(_): // tanto faz
//        case .characterSelection(let character): // tanto faz
//            return "CharacterSelection:" + character.name + " \(character.origin)" + " " + "\(character.timestamp)"
//            agora com interpolacao de strings, mas assim nao estamos salvando bem legal, vamos criar um dicionario ja pra ficar melhor!
        case .screenView: return "ScreenView"
        case .actionPerformed: return "ActionPerformed"
        case .custom(let name, _): return name
        }
    }

    func parameters() throws -> [String: String] {
        switch self {
        case .characterSelection(let event): return try event.asStringDictionary()
        case .screenView(let event): return try event.asStringDictionary()
        case .actionPerformed(let event): return try event.asStringDictionary()
        case .custom(_, let params): return params
        }
    }
        
//assim nao precisa repetir o nome, mas Enum with raw type cannot have cases with arguments, nao poderia ter a struct dentro do case!
//enum AnalyticsEvent: String {
//        var eventName: String {
//            return self.rawValue
//        } // Retorna a string do case atual
//    }
    
}


struct CharacterFavoritedEvent: Codable {
    var name: String
    var isFavorited: Bool
    var date: String
}

// MARK: - Screen Names

enum Screens: String {
    case home = "Rick and Morty View (List of all characters)"
    case character = "Rick and Morty Item (Single chacracter)"
}

   
// MARK: - Event Structs (Payloads)
   
struct CharacterSelectedEvent: Codable { //para pegar do json!
//    struct CharacterSelectedEvent: Decodable { //para pegar do json! (receber dados)
//    struct CharacterSelectedEvent: Encodable { //para pegar do json! -> Se tiver certeza q so vai codificar e nao decodificar (enviar dados)
//    Codable=Encodable+Decodable
    
       let name: String
       let origin: String
       let date: String
   }
   
    struct FavoriteCharacterEvent: Codable {
        let name: String
        let isFavorited: Bool
        let date: String
    }
   
struct ScreenViewEvent: Codable {
       let screenName: String
       let duration: Double
       let userTier: String
   }

struct ActionEvent: Codable {
       let actionName: String
       let context: String
       let success: Bool
   }


// MARK: - AnalyticsError

enum AnalyticsError: Error {
   case encoding(String),
        invalidDictionary(String)
}

// MARK: - Tranformação Encodable -> [String: String] // Sem tratar direito os erros

extension Encodable {
   func asStringDictionary() throws -> [String:String] {
       do {
           let data = try JSONEncoder().encode(self)
           guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
               throw AnalyticsError.invalidDictionary("JSON não é dicionário de topo.")
           }
           return dict.mapValues { "\($0)" }
       } catch let e as EncodingError {
           throw AnalyticsError.encoding("Falha ao codificar: \(e)")
       } catch {
           throw AnalyticsError.invalidDictionary("Falha: \(error.localizedDescription)")
       }
   }
}


//MARK: - Refatorada

/*
extension Encodable {
    func transformParametersToDictionary() throws -> [String: Any]? {
        // 1. Codifica (Struct -> Data)
        let data = try JSONEncoder().encode(self)
        
        // 2. Deserializa (Data -> Dicionário)
        return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
    }
}

class AnalyticsService {
    
    private init() {}
    
    static let shared = AnalyticsService()
    
    public func log(screen: String, event: AnalyticsEvent) {
        
        
        switch event {
            
        case .characterSelection(let characterSelectionEvent):
            do {
                // Usa a extensão para ir de Struct -> Dicionário em uma linha
                if let dictParameters = try characterSelectionEvent.transformParametersToDictionary() {
                    Analytics.logEvent(event.eventName, parameters: dictParameters)
                } else {
                    // O JSON foi lido, mas não era um Dicionário de nível superior (ex: era um Array).
                    print("Erro de formato: O JSON do evento '\(event.eventName)' foi decodificado, mas não era um dicionário ([String: Any]).")
                    
                }
            } catch {
                //                Lembrando que catch só é ativado se a função lançar (throw) um erro, e não se ela retornar nil, se for nil é pq nao conseguiu transformar em dicionario, ai entra no else!
                print("Erro na Codificação (JSONEncoder) ou Desserialização (JSONSerialization) do evento para dicionário: \(error.localizedDescription)") // ja que a funcao transforms pode lançar (throws) um erro tanto do JSONEncoder quando JSONSerialization.
            }
        }//switch
 
     print("Event tracked: \(event.eventName) | params: \(parameters)" )
 
     Analytics.logEvent(event.eventName, parameters: parameters)
        
    } // fim funcao
    
} //classe

 */

// MARK: - Sem ser refatorada
            
///  Service to handle app analytics
class AnalyticsService {

    private init() {}
    
    static let shared = AnalyticsService()
    
//    public func logEvent() {}
//
//    public func logEventForCharacterSelection() {
//        Analytics.logEvent("CharacterSelection", parameters:["Character":"Rick"])
//        //constants! que bad
//    }
    
    // MARK: - Método para simular hang (fins didáticos - Instruments)
    public func simulateHang() {
        print("🐢 Iniciando hang proposital para demonstração no Instruments...")
        
        // Bloqueia a main thread por 3 segundos
        Thread.sleep(forTimeInterval: 3.0)
        
        // Processamento intensivo adicional por 2 segundos
        let startTime = Date()
        var counter = 0
        while Date().timeIntervalSince(startTime) < 2.0 {
            // Operações matemáticas intensivas para simular processamento pesado
            counter += Int.random(in: 1...1000)
            _ = sqrt(Double(counter))
        }
        
        print("🐢 Hang finalizado! Total: \(counter)")
    }
    
    public func log (event: AnalyticsEvent) {
        
        var parameters: [String: Any] = [:]
        var dataEvent: Data
        
        switch event {
                    case .characterSelection(let characterSelectionEvent):
            
            // Tratando o dado dentro do case, mas podemos tratar fora tambem como veremos com a funcao parameters que chama asDictionaryStrings
            
                        // MARK: - Passo 1: Codificar o seu objeto Swift (characterSelectionEvent) em Data (bytes JSON)
                        do {
            
                            dataEvent = try JSONEncoder().encode(characterSelectionEvent)
                            // mas ainda nao está no formato de dicionario que queremos!
            
            
                            //                Codificar para Data: Deixa o JSONEncoder fazer o trabalho chato (e seguro) de converter a struct em JSON (Data).
            
                            // MARK: - Passo 2: Converter o objeto Data (JSON em bytes) o dicionário para formato esperado pelo firebase
            
                            //Aqui poderiamos construir na mao o dictionario com os parametros mas isso é perigoso:
                            //
                            //
                            //            let characterData: [String: Any] = [
                            //                "name": "Ricky Gemeo",
                            //                "origin": "Planeta XDV-23"
                            //                "timestamp": "2025-10-07T23:28:38Z" // A data precisa ser uma String
                            //            ]
                            //                Quando você opta por não usar o Codable, você perde a segurança de tipo do Swift, mas ganha a flexibilidade total de trabalhar diretamente com as coleções nativas ([String: Any]).
            
                            //                Vamos estar usando o JSONEncoder para evitar o trabalho manual de criar o dicionário!
            
                            if let dictParameters = try JSONSerialization.jsonObject(with: dataEvent) as? [String: Any] { // Aqui... pderia ser outro do catch separado se achar q ta mt aninhado
                                //dictParameters recebe a decodificação (ou desserialização): ele transforma dados brutos de JSON (Data) em uma estrutura Swift legível ([String: Any]
            
                                // Atribui o dicionário de parâmetros final
                                parameters = dictParameters
            
                                //                    / alem disso temos uma vantagem de Manipular: Você altera o dicionário ([String: Any]) para adicionar ou modificar campos.
                                //                    se a sua API de destino exigir campos no nível superior do JSON que não pertencem logicamente à sua struct (CharacterSelection), você tem um problema.
            
                                //                    Exemplo    Você precisa adicionar {"api_key": "xyz123"} ao JSON final.
                                //                    Desvantagem    Você seria forçado a incluir api_key na sua struct CharacterSelection, mesmo que essa chave não tenha nada a ver com a seleção do personagem. Isso polui seu modelo de dados e o torna menos reutilizável.
                            } else {
                                print("Erro: A decodificação resultou em um tipo diferente esperado de [String: Any].")
                            }
            
                        } catch {
                            print("Erro na serialização/deserialização: \(error.localizedDescription)")
                        }
            
        case .screenView(_):
            do {
                parameters = try event.parameters()
            }
            catch {
                print("❌ Erro ao logar evento \(event): \(error.localizedDescription)")
            }
            
        case .actionPerformed(_):
            do {
                parameters = try event.parameters()
            }
            catch {
                print("❌ Erro ao logar evento \(event): \(error.localizedDescription)")
            }
            
        case .custom(name: let name, parameters: let parameters2):
//            do {
                parameters = parameters2
//            }
        }
            
            
             // MARK: - Passo 3: Enviar dicionario para firebase

        print("Event tracked: From \(event.eventName) | params: \(parameters)" )
        
            Analytics.logEvent(event.eventName, parameters: parameters)
        
        }
    
}
