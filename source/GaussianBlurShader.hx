package;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;

class GaussianBlurShader extends FlxShader
{

  @:glFragmentSource('
  #pragma header
  
  uniform float size1;
  uniform vec3 iResolution;

  void mainImage( out vec4 fragColor, in vec2 fragCoord )
  {
      float Pi = 6.28318530718; // Pi*2

      // GAUSSIAN BLUR SETTINGS {{{
      float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
      float Quality = 3.0; // BLUR QUALITY (Default 4.0 - More is better but slower) // BLUR SIZE (Radius)
      // GAUSSIAN BLUR SETTINGS }}}
    
      vec2 Radius = size1/iResolution.xy;
      
      // Normalized pixel coordinates (from 0 to 1)
      vec2 uv = fragCoord/iResolution.xy;
      // Pixel colour
      vec4 Color = texture(flixel_texture2D(bitmap, openfl_TextureCoordv), uv);
      
      // Blur calculations
      for( float d=0.0; d<Pi; d+=Pi/Directions)
      {
      for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
          {
        Color += texture(flixel_texture2D(bitmap, openfl_TextureCoordv), uv+vec2(cos(d),sin(d))*Radius*i);		
          }
      }
      
      // Output to screen
      Color /= Quality * Directions - 15.0;
      fragColor =  Color;
  }
  ')
  public function new()
  {
    super();
  }
}