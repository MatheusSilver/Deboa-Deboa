package;

import flixel.system.FlxAssets.FlxShader;

class CRTEffectShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		/**
		* Source: https://www.shadertoy.com/view/wllBDM
		*/
		uniform float time;

		#ifdef GL_ES
		precision mediump float;
		#ifdef GL_FRAGMENT_PRECISION_HIGH
		#define HIGHP highp
		#else
		#define HIGHP mediump
		#endif
		#else
		#define HIGHP
		#endif

		const float lineCut = 0.1;
		const float whiteIntensity = 0.8;
		const float anaglyphIntensity = 0.5;
		const vec3 col_r = vec3(0.0, 1.0, 1.0); // Anaglyph colors
		const vec3 col_l = vec3(1.0, 0.0, 0.0);

		void main()
		{
			HIGHP vec2 uv = openfl_TextureCoordv;

			float scanSpeed = fract(time) * 2.5 / 40.0;

			float wave = abs(cos((uv.y + scanSpeed) * 100.0));
			float waveRight = abs(cos((uv.y + 0.01 + scanSpeed) * 100.0));
			float waveLeft = abs(cos((uv.y - 0.01 + scanSpeed) * 100.0));
			vec3 col = smoothstep(0.1, 0.7, (vec3(wave) - lineCut) * whiteIntensity)
				+ smoothstep(0.1, 0.7, (col_r * waveRight - lineCut) * anaglyphIntensity)
				+ smoothstep(0.1, 0.7, (col_l * waveLeft - lineCut) * anaglyphIntensity);

			vec2 eyefishuv = (uv - 0.5) * 2.5;
			float deform = (1.0 - eyefishuv.y * eyefishuv.y) * 0.02 * eyefishuv.x;
			vec4 texture1 = texture2D(bitmap, vec2(uv.x - deform * 0.95, uv.y));

			float bottomRight = pow(uv.x, uv.y * 100.0);
			float bottomLeft = pow(1.0 - uv.x, uv.y * 100.0);
			float topRight = pow(uv.x, (1.0 - uv.y) * 100.0);
			float topLeft = pow(uv.y, uv.x * 100.0);
			float screenForm = bottomRight + bottomLeft + topRight + topLeft;

			gl_FragColor = texture1 + vec4(smoothstep(0.1, 0.9, col) * 0.1, 1.0);
			gl_FragColor.rgb *= 1.0 - screenForm;
		}')

	public function new()
	{
		super();
		time.value = [0];
	}
}
