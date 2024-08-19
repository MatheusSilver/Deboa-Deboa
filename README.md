# <img src="art/icon64.png" align="center"> Friday Night Funkin' - BSL Engine Mobile - Projeto ModBoa</img>
Essa engine foi originalmente baseada na [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) com alguns elementos característicos de outras engines como a [Mic'd Up](https://github.com/Verwex/Funkin-Mic-d-Up-SC) e a [Kade Engine](https://github.com/KadeDev/Kade-Engine), e almeja ser uma alternativa para os desenvolvedores que queiram criar mods ou porta-los para APK facilmente.

Caso queira conferir a versão base da engine para seus próprios trabalhos e projetos veja o repositório oficial da [BSL Engine Mobile](https://github.com/MatheusSilver/BSL-Engine-Mobile).

Os criadores desta engine também são grandes fãs de Osu, então você pode esperar uma abordagem muito mais arcade dos mods do que o normal com sistemas de ranqueamento, modifiers que aumentam a dificuldade e a pontuação, além de outras características de layout e gameplay de Osu
## Tutorial de Build simplificado:
Siga esses seguintes passos FUNDAMENTAIS para a compilação:
* Instale o [Git](https://git-scm.com/downloads)
* Instale o [Haxe](https://haxe.org/download/version/4.2.5/) - Se atente ao número da versão! O Projeto ModBoa não é compatível com outras versões do Haxe e a versão 4.2.5 é a menos bugada para compilar este projeto no presente momento.
* Instale o [Haxeflixel](https://haxeflixel.com/documentation/getting-started/)
* Instale o [Visual Studio Community](https://visualstudio.microsoft.com/pt-br/vs/community/) e na hora de instalar as coisas, importe a seguinte [configuração](https://drive.google.com/file/d/1RVxsn2pAIanVKevcAh_VmFnGqy1Q5Xo9/view?usp=sharing) e espere baixar e instalar (tudo isso é feito automáticamente).
* Logo após instalar as ferramentas de compilação do VSC2022 (ou a versão que estiver no momento que você for compilar isso), clone o repositório do Projeto ModBoa usando seu Terminal de preferência via Git.
`git clone https://https://github.com/MatheusSilver/Deboa-Deboa`
* Abra novamente o Terminal, só que dessa vez, dentro do diretório raiz do código fonte, e execute o comando:
`haxelib install hmm`
* Em seguida, o comando:
`haxelib run hmm install`

Parte específica para a compilação de Android via PC:
* Faça TODOS os passos que foram indicados acima.
* Instale a extensão "extension-webview" usando o comando:
`haxelib git extension-webview https://github.com/TeamX02/extension-webview`
* Baixe e instale o [Android Studio](https://developer.android.com/studio)
* Baixe e extraia as ferramentas de compilação [JDK](https://drive.google.com/file/d/1dIIISXyuNaXTZzIdvCAkIm7_Ee4Y9I-7/view?usp=sharing) e [NDK](https://drive.google.com/file/d/1Eifen5o1Mky0Mr2jl3eO-BiDYeuuRA1n/view?usp=sharing) para onde você preferir.
* Após a instalação completa do Android Studio, já no menu principal, clique em "More Actions" e depois em "SDK Manager"
* Dentro do gerenciador de SDKs, entre no submenu de "SDK Platforms" e selecione as seguintes opções:
![andr](https://i.imgur.com/d9YBzFJ.png)
* Entre no submenu de "SDK Tools" e selecione as seguintes opções:
![andr2](https://i.imgur.com/L100sOm.png)
* Rode o comando `lime setup android` e coloque o caminho de onde suas coisas estão extraídas/instaladas.
![andr3](https://i.imgur.com/AR8NCnV.png)

Caso você não tenha um computador e quiser compilar o mod para Android, basta usar as workflows do GitHub:
* Faça um fork do repositório do ModBoa.
* Após isso, entre na aba Actions, abaixo do nome do repositório
* Ative o uso de Workflows, vá em `Android Build CI`, depois clique em Run Workflows e aperte no botão verde.

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
