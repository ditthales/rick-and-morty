# ExchangeApp
Aplicativo que consome e mostra os dados da api https://rickandmortyapi.com/documentation

Autoria de código base: https://github.com/jamerson-macedo/

As modificações feitas envolvem a inserção de analytics no projetos, há uma estrutura de dados padrão para evento a ser disparado. 

Os eventos exemplares são são chamados de characterSelection e favoriteCharacterSelection. 

Os parametros são com base em cada estrutura de dados vinda do hand-off com o time design/négócios para tagueamento. Assim se cria um dicionário dinâmico.



# Funcionalidades
- Listagem de personagens
- busca de personagens
- mostra detalhes
- favoritar personagens
- Remove favoritos

# Tecnologias utilizadas
- SwiftUI
- MVVM
- Notifications
- Requisições HTTP
- SwiftData
- Combine
  
# Tecnologias utilizadas para Analytics
- Firebase (branch firebase) -> após a feitura em código, a engenharia de dados via -> Google Analytics / BigQuery / PowerBi / Colab Notebook 
- CloudKit (branch nativeIOS) -> Mais problemático para usar como ferramenta de Analytics, armazenamento e acesso aos dados fica comprometivo
- TelemetryDeck (branch telemetrydeck) -> Bom, mas menos potente que o firebase, pegada privacy-first, mas dashboard também restrita e acesso aos dados 
 
## Layout mobile
<p float="center">
  <img src="fotos/foto1.png" width="250" />
  <img src="fotos/foto2.png" width="250" />
  <img src="fotos/foto3.png" width="250" />
  <img src="fotos/foto4.png" width="250" />
  <img src="fotos/foto5.png" width="250" />

</p>


# rick-and-morty
