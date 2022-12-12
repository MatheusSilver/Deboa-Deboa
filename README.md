# <img src="art/icon64.png" align="center"> Friday Night Funkin' - BSL Engine Mobile - Projeto ModBoa</img>
Essa engine foi originalmente baseada na [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) com alguns elementos característicos de outras engines como a [Mic'd Up](https://github.com/Verwex/Funkin-Mic-d-Up-SC) e a [Kade Engine](https://github.com/KadeDev/Kade-Engine), e almeja ser uma alternativa para os desenvolvedores que queiram criar mods ou porta-los para APK facilmente.

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
`haxelib git extension-webview https://github.com/MatheusSilver/extension-webview`

Caso o seu projeto não rode com Vídeos, basta remover o Videos_Allowed de project.xml
Ou caso não queira Lua em seu projeto, basta remover o Lua_Allowed do seu projeto.

Caso você não tenha um computador e quiser compilar o mod para Android, basta usar as workflows do GitHub:

Faça um fork do repositório do ModBoa.

Após isso, entre na aba Actions, abaixo do nome do repositório,

ative o uso de Workflows, vá em `Android Build CI`, depois clique em Run Workflows e aperte no botão verde.

## Creditos - Projeto ModBoa:
* Vio - Diretora do projeto
* Dav - Programador Líder
* Konan - Programador
* Team Silver - Port Mobile
* MateusX02 - Ajuda no port Mobile

## Creditos - Psych Engine 4.2:
* Shadow Mario - Programação
* RiverOaken - Artes e Animações

## Creditos - Kade Engine:
* KadeDev - Criador da Engine

## Creditos - Mic'd Up:
* Verwex - Criador da Engine

Terminaremos o resto mais tarde...
_____________________________________

# Features

## Attractive animated dialogue boxes:

![](https://user-images.githubusercontent.com/44785097/127706669-71cd5cdb-5c2a-4ecc-871b-98a276ae8070.gif)


## Atleast one change to every week:
### Week 1:
  * New Dad Left sing sprite 
  * Unused stage lights are now used
### Week 2:
  * Both BF and Skid & Pump does "Hey!" animations
  * Thunders does a quick light flash and zooms the camera in slightly
  * Added a quick transition/cutscene to Monster
### Week 3:
  * BF does "Hey!" during Philly Nice
  * Blammed has a cool new colors flash during that sick part of the song
### Week 4:
  * Better hair physics for Mom/Boyfriend (Maybe even slightly better than Week 7's :eyes:)
  * Henchmen die during all songs. Yeah :(
### Week 5:
  * Bottom Boppers and GF does "Hey!" animations during Cocoa and Eggnog
  * On Winter Horrorland, GF bops her head slower in some parts of the song.
### Week 6:
  * On Thorns, the HUD is hidden during the cutscene
  * Also there's the Background girls being spooky during the "Hey!" parts of the Instrumental

## Cool new Chart Editor changes and countless bug fixes
![](https://i.imgur.com/h6Ja7eT.png)
* You can now chart "Event" notes, which are bookmarks that trigger specific actions that usually were hardcoded on the vanilla version of the game.
* Your song's BPM can now have decimal values
* You can manually adjust a Note's strum time if you're really going for milisecond precision
* You can change a note's type on the Editor, it comes with two example types:
  * Alt Animation: Forces an alt animation to play, useful for songs like Ugh/Stress
  * Hey: Forces a "Hey" animation instead of the base Sing animation, if Boyfriend hits this note, Girlfriend will do a "Hey!" too.

## Improved Animation Debug menu (Press 8 in-game on a Debug build)
![](https://user-images.githubusercontent.com/44785097/127721062-f912853c-2513-41b8-bd66-fd80d9d4ee0f.png)
* You can now press Save Offsets to save a .txt file with the editted offsets
* You can also now change the characters while on the Menu
* Go back to the game by pressing Escape
NOTE: This should be used for fixing your character floating or being slightly under the ground! It's not for texture editting.

## Story mode menu rework:
![](https://i.imgur.com/UB2EKpV.png)
* Added a different BG to every song (less Tutorial)
* All menu characters are now in individual spritesheets, makes modding it easier.

## Credits menu
![](https://i.imgur.com/NdIQt3d.png)
* You can add a head icon, name, description and a Redirect link for when the player presses Enter while the item is currently selected.

## Awards/Achievements
* The engine comes with 16 example achievements that you can mess with and learn how it works (Check Achievements.hx and search for "checkForAchievement" on PlayState.hx)

## Options menu:
* You can change Note colors, Controls and Preferences there.
 * On Preferences you can toggle Downscroll, Anti-Aliasing, Framerate, Low Quality, Note Splashes, Hide Hud elements, Flashing Lights, etc.

## Other gameplay features:
* When the enemy hits a note, it plays the note hit animation on their strum, just like when the player hits a note.
* Lag doesn't impact the camera movement and player icon scaling anymore.
* Some stuff based on Week 7's changes has been put in (Background colors on Freeplay, Note splashes)
* You can reset your Score on Freeplay/Story Mode by pressing Reset button.
* You can listen to a song on Freeplay by pressing Space once.
