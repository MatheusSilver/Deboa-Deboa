# <img src="art/icon64.png" align="center"> Friday Night Funkin' - BSL Engine Mobile - Projeto ModBoa</img>
Essa engine foi originalmente baseada na [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) com alguns elementos característicos de outras engines como a [Mic'd Up](https://github.com/Verwex/Funkin-Mic-d-Up-SC) e a [Kade Engine](https://github.com/KadeDev/Kade-Engine), e almeja ser uma alternativa para os desenvolvedores que queiram criar mods ou porta-los para APK facilmente.

Caso queira conferir a versão base da engine para seus próprios trabalhos e projetos veja o repositório oficial da [BSL Engine Mobile](https://github.com/MatheusSilver/BSL-Engine-Mobile).

Os criadores desta engine também são grandes fãs de Osu, então você pode esperar uma abordagem muito mais arcade dos mods do que o normal com sistemas de ranqueamento, modifiers que aumentam a dificuldade e a pontuação, além de outras características de layout e gameplay de Osu
## Tutorial de Build simplificado:
Caso queira fazer uma build para Android diretamente no PC, siga o tutorial disponível em:
https://github.com/luckydog7/Funkin-android
Agora, caso queira fazer uma build para Windows, recomendamos o seguinte tutorial e mais as correções abaixo:
https://gamebanana.com/tuts/13935

Agora a parte específica para compilações de android:
`haxelib set openfl 9.1.0`

`haxelib set lime 7.9.0`

`haxelib git linc_luajit https://github.com/Sirox228/linc_luajit.git`

`haxelib install actuate`

`haxelib git extension-webm https://github.com/Daninnocent/extension-webm`

Caso esteja fazendo a build para PC, execute o seguinte comando:
`lime rebuild extension-webm windows`

agora, caso seja para Android (o que provavelmente é):
`lime rebuild extension-webm android`

e ainda deverá instalar essa ultima extensão:
`haxelib git extension-webview https://github.com/MateuzinhoX02/extension-webview`

Caso o seu projeto não rode com Vídeos, basta remover o Videos_Allowed de project.xml
Ou caso não queira Lua em seu projeto, basta remover o Lua_Allowed do seu projeto.

Caso você não tenha um computador e quiser compilar o mod para Android, basta usar as workflows do GitHub:

Faça um fork do repositório do ModBoa.

Após isso, entre na aba Actions, abaixo do nome do repositório,

ative o uso de Workflows, vá em `Android Build CI`, depois clique em Run Workflows e aperte no botão verde.

## Creditos - Projeto ModBoa:
# Direção:
* Vio - Diretora do projeto
# Charts e outras coisas
* Konan - Charts/legendas/luas/ports
# Artistas
* Ashuro - artista principal - CY, Menus, Slaybells, Scrollings e mais artes
* Cat - artista - CY, Scrollings, sprites e mais artes 
* Hugo - artista, CY, Scrollings, ideias, sprites e mais artes 
# Coding
* Dav - Diretor de code/luas
# <img src="art/YT Matheus Silver (1).png" align="center"> Team Silver - Port Mobile </img>
*  - Matheus Silver - Diretor de code/port mobile
*  - Lorena - Port Mobile, Revisão de codes, otimização de codes, sistema de cache adaptado
*  - Clara -  Port Mobile, otimização de alguns sprites, ajustes, e mais outras coisas
*  -------------------------
* Konan - Programador
* MateusX02 - Ajuda no port Mobile/coding adicional

## Creditos - Psych Engine 4.2:
* Shadow Mario - Programação
* RiverOaken - Artes e Animações

## Creditos - Kade Engine:
* KadeDev - Criador da Engine

## Creditos - Mic'd Up:
* Verwex - Criador da Engine

Divirta-se
