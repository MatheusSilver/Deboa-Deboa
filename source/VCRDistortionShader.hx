package;

import flixel.system.FlxAssets.FlxShader;

// Credits to Andromeda Engine (NebulaTheZoura) for porting from shadertoy!
class VCRDistortionShader extends FlxShader // https://www.shadertoy.com/view/ldjGzV and https://www.shadertoy.com/view/Ms23DR and https://www.shadertoy.com/view/MsXGD4 and https://www.shadertoy.com/view/Xtccz4
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

		uniform bool vignetteOn;
		uniform bool perspectiveOn;
		uniform bool distortionOn;
		uniform float uWindowY;
		uniform float uGlitchAmp;
		uniform float uVShift;
		uniform float uVigAmt;
		uniform float uNoiseSeed;

		HIGHP vec2 distort(HIGHP vec2 uv)
		{
			if (distortionOn)
			{
				float dy = uv.y - uWindowY;
				float window = 1.0 / (1.0 + 20.0 * dy * dy);
				uv.x += sin(uv.y * 10.0 + iTime) * uGlitchAmp * window;
				uv.y = mod(uv.y + uVShift, 1.0);
			}
			return uv;
		}

		HIGHP vec2 screenDistort(HIGHP vec2 uv)
		{
			if (perspectiveOn)
			{
				uv = (uv - 0.5) * 2.2;
				uv.x *= 1.0 + uv.y * uv.y / 25.0;
				uv.y *= 1.0 + uv.x * uv.x / 16.0;
				uv = (uv / 2.0) + 0.5;
				uv = uv * 0.92 + 0.04;
			}
			return uv;
		}

		float random(HIGHP vec2 uv)
		{
			return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * uNoiseSeed);
		}

		float noise(HIGHP vec2 uv)
		{
			HIGHP vec2 i = floor(uv);
			vec2 f = fract(uv);
			float a = random(i);
			float b = random(i + vec2(1.0, 0.0));
			float c = random(i + vec2(0.0, 1.0));
			float d = random(i + vec2(1.0));
			vec2 u = smoothstep(0.0, 1.0, f);
			return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
		}

		HIGHP vec2 scandistort(HIGHP vec2 uv)
		{
			float scan1 = clamp(cos(uv.y * 2.0 + iTime), 0.0, 1.0);
			float scan2 = clamp(cos(uv.y * 2.0 + iTime + 4.0) * 10.0, 0.0, 1.0);
			float amount = scan1 * scan2 * uv.x;
			uv.x -= 0.045 * amount;
			return uv;
		}

		void main()
		{
			HIGHP vec2 curUV = screenDistort(openfl_TextureCoordv);
			HIGHP vec2 uv = distort(scandistort(curUV));

			vec4 video = flixel_texture2D(bitmap, uv);
			video.r = flixel_texture2D(bitmap, uv + vec2(0.001, 0.001)).r + 0.05;
			video.g = flixel_texture2D(bitmap, uv + vec2(0.0, -0.002)).g + 0.05;
			video.b = flixel_texture2D(bitmap, uv + vec2(-0.002, 0.0)).b + 0.05;
			video.r += 0.08 * flixel_texture2D(bitmap, uv + vec2(0.01975, -0.01925)).r;
			video.g += 0.05 * flixel_texture2D(bitmap, uv + vec2(-0.0165, -0.017)).g;
			video.b += 0.08 * flixel_texture2D(bitmap, uv + vec2(-0.017, -0.0135)).b;

			video = clamp(video * 0.6 + 0.4 * video * video, 0.0, 1.0);

			if (vignetteOn)
			{
				vec2 d = uv - 0.5;
				video *= (1.0 - uVigAmt * d.y * d.y) * (1.0 - uVigAmt * d.x * d.x);
			}

			if (uNoiseSeed != 0.0)
				video = mix(video, vec4(noise(uv * 75.0)), 0.05);
			else
				video *= 0.95;

			vec2 inside = step(vec2(0.0), curUV) * step(curUV, vec2(1.0));
			gl_FragColor = video * inside.x * inside.y;
		}
	')

	public var glitchModifier:Float = 0;
	public var vignetteMoving:Bool = true;

	var time:Float = 0;

	public function new()
	{
		super();
		iTime.value = [0];
		vignetteOn.value = [true];
		perspectiveOn.value = [true];
		distortionOn.value = [true];
		uWindowY.value = [0];
		uGlitchAmp.value = [0];
		uVShift.value = [0];
		uVigAmt.value = [1];
		uNoiseSeed.value = [0];
		update(0);
	}

	public function update(elapsed:Float):Void
	{
		time += elapsed;
		iTime.value[0] = time;
		uWindowY.value[0] = (time / 4) % 1;
		uGlitchAmp.value[0] = onOff(4, 4, 0.3) * (1 + Math.cos(time * 80)) / 50 * glitchModifier * 2;
		uVShift.value[0] = 0.4 * onOff(2, 3, 0.9) * (Math.sin(time) * Math.sin(time * 20) + (0.5 + 0.1 * Math.sin(time * 200) * Math.cos(time))) * glitchModifier;
		uVigAmt.value[0] = vignetteMoving ? 3 + 0.3 * Math.sin(time + 5 * Math.cos(time * 5)) : 1;
		uNoiseSeed.value[0] = 12341.14122 * Math.sin(time * 0.03);
	}

	inline function onOff(a:Float, b:Float, c:Float):Float
	{
		return Math.sin(time + a * Math.cos(time * b)) >= c ? 1 : 0;
	}
}
