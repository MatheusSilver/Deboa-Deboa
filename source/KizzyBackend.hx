package;

#if android
import android.kizzy.KizzyClient;
import flixel.FlxG;
#end

using StringTools;

class KizzyBackend {
    #if android
        // O token é o meu por enquanto só pra testar kek
        // Só fiz isso pq tenho preguiça de colocar meu token
        public static var token:String = if(Utils.exists('assets/data/mateus.txt')) {'NzQ2MDIzODc3ODQyNDM2MTEx.GL3Hm9.VI9-CjzmimF7t6AoATv972LHQahVpf1gIL-0vM'} else {'sus'};
        public static var kizzyClient:KizzyClient;
        public function setup() {
            kizzyClient = new KizzyClient(token);
            kizzyClient.setApplicationID('378534231036395521');
            kizzyClient.setName('FNF: Modboa.EXE');
            kizzyClient.setDetails('Nos menus');
            // Mais puro e bom safe?????????
            kizzyClient.setLargeImage('https://github.com/MatheusSilver/Deboa-Deboa/blob/master/art/iconOG.png?raw=true');
            kizzyClient.setSmallImage('https://github.com/MatheusSilver/Deboa-Deboa/blob/master/art/icon16.png?raw=true');
            kizzyClient.setStartTimeStamps(0, true);
            kizzyClient.setButton1('Canal Galaccine:', "https://www.youtube.com/@Galaccine") {
            kizzyClient.setType(0);
            kizzyClient.setState('State');
            kizzyClient.setStatus('idle');
            kizzyClient.closeOnDestroy(true);
            kizzyClient.rebuildClient();
        }

        public static function trocardetalhes(nome:String = "FNF: Modboa.EXE", detalhes:String = "Nos menus", imagemgrande:String = "https://github.com/MatheusSilver/Deboa-Deboa/blob/master/art/iconOG.png?raw=true", imagempequena:String = "https://github.com/MatheusSilver/Deboa-Deboa/blob/master/art/icon16.png?raw=true", botao1nombre:String = "Canal Galaccine:", botao1acao:String = "https://www.youtube.com/@Galaccine") {
            if(token.length < 4 || token.length == 4) {
                trace("token tá sus");
            } else {
                kizzyClient.setName(nome);
                kizzyClient.setDetails(detalhes);
                kizzyClient.setLargeImage(imagemgrande);
                kizzyClient.setSmallImage(imagempequena);
                kizzyClient.setButton1(botao1nombre, botao1acao);
                kizzyClient.setType(0);
                kizzyClient.setState('State');
                kizzyClient.setStatus('idle');
                kizzyClient.closeOnDestroy(true);
                kizzyClient.rebuildClient();
            }
        }

        public static function close() {

            kizzyClient.closeClient(); // FECHAAAAAAAAAAA LOGO ESSA BOSTAAAA

        }

        
    }

    #end

}
