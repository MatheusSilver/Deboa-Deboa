# <img src="art/icon64.png" align="center"> Friday Night Funkin' - BSL Engine Mobile - Projeto ModBoa</img>
Essa engine foi originalmente baseada na [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) com alguns elementos característicos de outras engines como a [Mic'd Up](https://github.com/Verwex/Funkin-Mic-d-Up-SC) e a [Kade Engine](https://github.com/KadeDev/Kade-Engine), e almeja ser uma alternativa para os desenvolvedores que queiram criar mods ou porta-los para APK facilmente.

Caso queira conferir a versão base da engine para seus próprios trabalhos e projetos veja o repositório oficial da [BSL Engine Mobile](https://github.com/MatheusSilver/BSL-Engine-Mobile).

Os criadores desta engine também são grandes fãs de Osu, então você pode esperar uma abordagem muito mais arcade dos mods do que o normal com sistemas de ranqueamento, modifiers que aumentam a dificuldade e a pontuação, além de outras características de layout e gameplay de Osu

## Creditos - Projeto ModBoa:
# Direção:
* Vio - Diretora do projeto
# Charts e outras coisas
* Konan - Charts/legendas/luas/ports
* Vinnie - Charts
* Gouz - Charts
* Rabbit - Charts
# Artistas
* Ashuro - artista principal - CY, Menus, Slaybells, Scrollings e mais artes
* Cat - artista - CY, Scrollings, sprites e mais artes 
* Hugo - artista, CY, Scrollings, ideias, sprites e mais artes 
* Nova - artista
* Frost - artista, fez o reshade de diversos sprites
# Coding
* Dav - Diretor de code/luas
* Konan - Programador
* MateusX02 - Coding/Ajuda na otimização e no port Mobile
# <img src="art/YT Matheus Silver (1).png" align="center"> Team Silver - Coding para a versão de PC e Mobile </img>
*  - Matheus Silver - Coding para a versão de PC e Mobile
*  - Lorena - Coding para a versão de PC e Mobile, Revisão de codes, otimização de codes, sistema de cache adaptado
*  - Clara -  Coding para a versão de PC e Mobile, otimização de alguns sprites, ajustes, e mais outras 

## Creditos - Psych Engine 0.4.2:
* Shadow Mario - Programação
* RiverOaken - Artes e Animações

## Creditos - Kade Engine:
* KadeDev - Criador da Engine

## Creditos - Mic'd Up:
* Verwex - Criador da Engine

Divirta-se

## Tutorial de Build simplificado:
Caso for compilar utilizando o Github Actions, vá para o fim do texto.
Abaixo, passos fundamentais para a compilação:
* Instale o [Git](https://git-scm.com/downloads)
* Instale o [Haxe](https://haxe.org/download/version/4.2.5/) - Se atente ao número da versão! O Projeto ModBoa não é compatível com outras versões do Haxe.
* Instale o [Haxeflixel](https://haxeflixel.com/documentation/getting-started/)

### Específico para Windows
* Instale o [Visual Studio Community](https://visualstudio.microsoft.com/pt-br/vs/community/) e na hora de instalar as coisas, importe a seguinte [configuração](https://github.com/MatheusSilver/Deboa-Deboa/blob/master/art/importar.vsconfig) (baixe apertando no símbolo de download ao lado de "Raw") e espere baixar e instalar (tudo isso é feito automáticamente).

### Específico para Linux
* Instale os pacotes `g++`, `gcc-multilib`, `g++-multilib` e também os pacotes necessários do libVLC.
* Os pacotes libVLC podem ser instalados com os comandos `sudo apt install libvlc-dev libvlccore-dev libvlccore9` em distros baseadas em Ubuntu/Debian. Já para outras distros, siga as recomendações da [documentação do hxvlc](https://github.com/MAJigsaw77/hxvlc?tab=readme-ov-file#dependencies)'

### Específico para Android
* Instale a extensão "extension-webview" usando o comando:
`haxelib git extension-webview https://github.com/x02mateus/extension-webview`
* Baixe e instale o [Android Studio](https://developer.android.com/studio)
* Baixe e extraia as ferramentas de compilação [JDK](https://adoptium.net/pt-BR/temurin/releases?version=11) e [NDK](https://github.com/android/ndk/wiki/unsupported-downloads#r21e) para onde você preferir.
* Após a instalação completa do Android Studio, já no menu principal, clique em "More Actions" e depois em "SDK Manager"
* Dentro do gerenciador de SDKs, entre no submenu de "SDK Platforms" e selecione as seguintes opções:
![andr](https://i.imgur.com/d9YBzFJ.png)
* Entre no submenu de "SDK Tools" e selecione as seguintes opções:
![andr2](https://i.imgur.com/L100sOm.png)
* Rode o comando `lime setup android` e coloque o caminho de onde suas coisas estão extraídas/instaladas.
![andr3](https://i.imgur.com/AR8NCnV.png)

* Logo após as os passos específicos para cada sistema, clone o repositório do Projeto ModBoa utilizando o comando:
`git clone https://https://github.com/MatheusSilver/Deboa-Deboa`
* Dentro do diretório raiz do código-fonte (certifique que o Terminal aponta para o diretório do código-fonte do jogo), execute o comando:
`haxelib install hmm`
* E em seguida, o comando:
`haxelib run hmm install`

### Específico para o Github Actions
Caso você queira evitar o trabalho das instalações para a compilação, segue o passo a passo para a compilação diretamente no Github:
* Faça um fork do repositório do ModBoa.
* Na aba Actions, abaixo do nome do repositório, ative o uso de Workflows, escolha entre `Android Build`, `Linux Build` ou `Windows Build`, depois clique em Run Workflows e aperte no botão verde.
* Ao finalizar da compilação, você deve receber um email avisando se houve erros ou se tudo ocorreu com sucesso.
* Para baixar o resultado da build, basta entrar na compilação executada por você e descer até achar a opção de download.
