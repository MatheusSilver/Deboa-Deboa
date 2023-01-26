package;

//Recomendo que abra esse arquivo no VS Code pra facilitar a visualização.

/*
Vamos começar pelo básico, esse tutorial aqui vai cobrir desde adição de sprites
Até tweens, e é extremamente focado em menus
As regras mudam quando você vai para o PlayState.hx
Mas acredito que para essa parte você já está bem servido só com as coisas da Psych (por enquanto k)
*/


//Primeiro, adição de sprites básicos (sem movimento ou animação)
import flixel.FlxSprite; 
//Geralmente isso já vem adicionado em qualquer arquivo .hx, mas só pra fins de explicação
//Esse import te permite adicionar imagens - Só isso mesmo

class MenuModelo extends MusicBeatState
{
    
    //Para começar a poder usar sprites, basta adicionar o seguinte
    var pngAleatorio:FlxSprite;

    var largura:Int = 1280;
    var altura:Int = 720;

    // Só isso não fará o sprite ser adicionado

    //É pra isso que existe a override function create()
    //É lá onde você irá carregar e configurar todos os seus sprites.

    override function create(){
        
        //Essa primeiro code não é obrigatório, mas gosto de colocar ele pra ter a absoluta certeza que 
        //vou usar um sprite sem nenhuma configuração prévia
        pngAleatorio = new FlxSprite();
        
        //Vamos começar fazendo ele carregar uma imagem qualquer, pra isso:
        pngAleatorio.loadGraphic(Paths.image("menuBG")); //Vou assumir que você está usando Psych Engine, esse code fará a variável pngAleatório puxar a imagem MenuBG em preload/images
        

        //Agora, iremos dar a ele uma posição X e Y
        pngAleatorio.x = 0;
        pngAleatorio.y = 0;
        //Isso fará com que a ponta superior esquerda do png fique na mesma posição que a ponta superior esquerda da tela (isso nem sempre vale no PlayState.hx)

        //Agora, com o sprite pronto, podemos adicionar ele dentro do jogo com:
        add(pngAleatorio);

        //Simples né?
        //Isso é tudo o que você precisa pra adicionar um png no jogo
        //Agora indo pra parte mais específica:

        //Mudando o tamanho do sprite
        //Caso você use:
        pngAleatorio.setGraphicSize(FlxG.width,FlxG.height);
        //Seu sprite ocupará a tela inteira

        //Caso você queira que ele fique com um tamanho especifico pode usar:
        pngAleatorio.setGraphicSize(largura,altura);
        //Substitua largura e altura pelos números inteiros que quiser.

        pngAleatorio.updateHitbox();
        //Esse outro code deve sempre vir em sequência do primeiro caso você planeje usar o png para fazer tweens
        //Ou caso ele seja um botão apertável.

        //Caso queira mudar a transparência do sprite, pode usar o alpha
        //Alpha varia de 0 a 1, sendo 0 = totalmente transparente
        //E 1 igual a 100% visivel.
        pngAleatorio.alpha = 1;

        //E é isso, todo o básico sobre adição de sprites foi feito aqui.

        //Todo o resto que você vier a aprender são Bonus como exemplo tweens ou botões apertáveis.
        //Considerando que você talvez esteja mais interessado em Tweens, podemos fazer o seguinte.

        //Vamos fazer com que seu sprite comece na esquerda, e vá para a direita até sair da tela.
        //Pra isso:
        pngAleatorio.x = -pngAleatorio.width; //Para que ele comece lá na esquerda fora da tela.
        
        
        
        
        FlxTween.tween(pngAleatorio, {x: FlxG.width}, 5.0, {ease: FlxEase.expoInOut}); //E isso fará com que ele vá pra fora da tela passando pelo meio
        /*
        Explicando cada coisa do tween:
        - Primeiro, é o nome do sprite que você quer que ele faça algo
        - {x: FlxG.width} indica que queremos mudar a posição X dele e queremos que o sprite vá para o fim da tela (que é marcado por FlxG.width)
        - 5.0, indica o tempo em segundos, nesse caso 5 segundos
        - {ease: FlxEase.expoInOut} //Não se preocupe com isso por agora, é apenas uma fórmula que vai ditar como o sprite fará o movimento
        //Existem várias dessas fórmulas, mas não vejo muita diferença entre elas.
        */

        //Minha recomendação pra tu se acostumar um pouco mais com o tween:
        //Troque o x em {x: FlxG.width} por alpha ou scale, e veja o que acontece.
        //Assim você pega um pouco mais de costume e confiança com isso.
        //Ou então troque o FlxG.width por outros valores.

        //Importante sobre tweens {x: FlxG.width} o valor que vem depois dos ":" demarca o valor final da propriedade que você está mexendo.
    }

}

