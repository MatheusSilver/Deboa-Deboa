package;

import flixel.system.FlxAssets.FlxShader;

class GrayscaleShader extends FlxShader
{
	public static var shared(get, null):GrayscaleShader;

	static function get_shared():GrayscaleShader
	{
		if (shared == null)
			shared = new GrayscaleShader();
		return shared;
	}

	@:glFragmentSource('
		#pragma header
		#ifdef GL_ES
		precision mediump float;
		#endif

		void main()
		{
			vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
			float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
			gl_FragColor = vec4(vec3(gray), color.a);
		}
	')
	public function new()
	{
		super();
	}
}

/* Adaptado de https://github.com/mariosbignuts/Soulles-DX-YCE/blob/37b770d64be4a2736850d3860bd37cb8e923a6dd/shaders/hotlineVHS.frag */
class TapeVhsShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform float iTime;

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

		uniform float uTimeNoise;

		#define PI 3.14159265

		vec3 tex2D(HIGHP vec2 p)
		{
			vec3 col = flixel_texture2D(bitmap, p).xyz;
			return mix(col, vec3(0.1), step(0.5, abs(p.x - 0.5)));
		}

		float hash(HIGHP vec2 v)
		{
			return fract(sin(dot(v, vec2(89.44, 19.36))) * 22189.22);
		}

		float iHash(HIGHP vec2 v, float r)
		{
			HIGHP vec2 cell = floor(v * r);
			float h00 = hash(cell / r);
			float h10 = hash((cell + vec2(1.0, 0.0)) / r);
			float h01 = hash((cell + vec2(0.0, 1.0)) / r);
			float h11 = hash((cell + vec2(1.0, 1.0)) / r);
			vec2 ip = smoothstep(vec2(0.0), vec2(1.0), fract(v * r));
			return mix(mix(h00, h10, ip.x), mix(h01, h11, ip.x), ip.y);
		}

		float noise(HIGHP vec2 v)
		{
			return iHash(v + vec2(1.0), 4.0) * 0.5
				+ iHash(v + vec2(2.0), 8.0) * 0.25
				+ iHash(v + vec2(3.0), 16.0) * 0.125
				+ iHash(v + vec2(4.0), 32.0) * 0.0625
				+ iHash(v + vec2(5.0), 64.0) * 0.03125
				+ iHash(v + vec2(6.0), 128.0) * 0.015625
				+ iHash(v + vec2(7.0), 256.0) * 0.0078125
				+ iHash(v + vec2(8.0), 512.0) * 0.00390625;
		}

		void main()
		{
			HIGHP vec2 uv = openfl_TextureCoordv;
			HIGHP vec2 uvn = uv;

			float lineNoise = noise(vec2(uv.y * 100.0, iTime * 10.0));
			uvn.x += (noise(vec2(uv.y, iTime)) - 0.5) * 0.005;
			uvn.x += (lineNoise - 0.5) * 0.01;

			float tcPhase = clamp((sin(uvn.y * 8.0 - iTime * PI * 1.2) - 0.92) * uTimeNoise, 0.0, 0.01) * 10.0;
			float tcNoise = max(lineNoise - 0.5, 0.0);
			uvn.x -= tcNoise * tcPhase;

			float snPhase = smoothstep(0.02, 0.0, uvn.y);
			uvn.y += snPhase * 0.08;
			uvn.x += snPhase * ((lineNoise - 0.5) * 0.06);

			vec3 col = tex2D(uvn);
			col *= 1.0 - tcPhase;
			col = mix(col, col.yzx, snPhase);

			HIGHP float px = 7E-3;
			vec3 tm8 = tex2D(uvn + vec2(-8.0 * px, 0.0));
			vec3 tm7 = tex2D(uvn + vec2(-7.0 * px, 0.0));
			vec3 tm6 = tex2D(uvn + vec2(-6.0 * px, 0.0));
			vec3 tm5 = tex2D(uvn + vec2(-5.0 * px, 0.0));
			vec3 tm4 = tex2D(uvn + vec2(-4.0 * px, 0.0));
			vec3 tm3 = tex2D(uvn + vec2(-3.0 * px, 0.0));
			vec3 tm2 = tex2D(uvn + vec2(-2.0 * px, 0.0));
			vec3 tm1 = tex2D(uvn + vec2(-1.0 * px, 0.0));
			vec3 t0 = tex2D(uvn);
			vec3 tp1 = tex2D(uvn + vec2(1.0 * px, 0.0));
			vec3 tp2 = tex2D(uvn + vec2(2.0 * px, 0.0));
			col.x += (tm4.x + tm3.x + tm2.x + tm1.x + t0.x + tp1.x + tp2.x) * 0.1;
			col.y += (tm6.y + tm5.y + tm4.y + tm3.y + tm2.y + tm1.y + t0.y) * 0.1;
			col.z += (tm8.z + tm7.z + tm6.z + tm5.z + tm4.z + tm3.z + tm2.z) * 0.1;
			col *= 0.75;

			col *= 1.0 + clamp(noise(vec2(0.0, uv.y + iTime * 0.2)) * 0.6 - 0.25, 0.0, 0.1);

			gl_FragColor = vec4(col, flixel_texture2D(bitmap, uv).a);
		}
	')

	public function new()
	{
		super();
		iTime.value = [0];
		uTimeNoise.value = [0];
		update(0);
	}

	public function update(elapsed:Float):Void
	{
		var time:Float = iTime.value[0] + elapsed;
		iTime.value[0] = time;
		uTimeNoise.value[0] = timeNoise(time);
	}

	static function timeNoise(time:Float):Float
	{
		var sum:Float = 0;
		for (i in 1...9)
		{
			var r:Float = 2 * Math.pow(2, i);
			var x:Float = time + i;
			var cell:Float = Math.ffloor(x * r);
			var h00:Float = hash(cell / r, cell / r);
			var h10:Float = hash((cell + 1) / r, cell / r);
			var h01:Float = hash(cell / r, (cell + 1) / r);
			var h11:Float = hash((cell + 1) / r, (cell + 1) / r);
			var f:Float = x * r - cell;
			var ip:Float = f * f * (3 - 2 * f);
			sum += ((h00 * (1 - ip) + h10 * ip) * (1 - ip) + (h01 * (1 - ip) + h11 * ip) * ip) / Math.pow(2, i);
		}
		return sum;
	}

	static inline function hash(x:Float, y:Float):Float
	{
		var v:Float = Math.sin(x * 89.44 + y * 19.36) * 22189.22;
		return v - Math.ffloor(v);
	}
}

class ColorblindData
{
	public static final matrizes:Array<Array<Float>> = [
		null,
		// Protanopia
		[
			0.43, 0.72, -0.15, 0, 0,
			0.34, 0.57,  0.09, 0, 0,
			-0.02, 0.03, 1.00, 0, 0,
			0.00, 0.00,  0.00, 1, 0
		],

		// Deuteranopia
		[
			0.97, 0.11, -0.08, 0, 0,
			0.02, 0.82,  0.16, 0, 0,
			0.06, 0.88,  0.18, 0, 0,
			0.00, 0.00,  0.00, 1, 0
		],

		// Tritanopia
		[
			0.20, 0.99, -0.19, 0, 0,
			0.16, 0.79,  0.04, 0, 0,
			0.01, -0.01, 1.00, 0, 0,
			0.00, 0.00,  0.00, 1, 0
		]
	];

	public static inline function valido(index:Int):Bool
	{
		return index > 0 && index < matrizes.length;
	}
}
