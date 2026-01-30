import lime.graphics.OpenGLRenderContext;
import lime.app.Application;
import lime.ui.Window;
import lime.graphics.Image;
import lime.graphics.RenderContext;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GL;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import sys.FileSystem;

using StringTools;

typedef GifFrame =
{
	var image:Image;
	var texture:GLTexture;
	var delay:Float;
}

class GifWindow
{
	public var window:Window;

	var frames:Array<GifFrame> = [];
	var curFrame:Int = 0;
	var timer:Float = 0;

	var program:GLProgram;
	var vertexBuffer:GLBuffer;
	var texCoordBuffer:GLBuffer;
	var indexBuffer:GLBuffer;
	var positionAttrib:Int;
	var texCoordAttrib:Int;
	var samplerUniform:GLUniformLocation;
	
	public static final gifWidth:Int = 300;
	public static final gifHeight:Int = 300;
	
	// o loop é para o caso de acharem uma má ideia deixar ele se apagar sozinho, ai fica fácil de manter ele ai.
	private var shouldLoop:Bool = true;
	private var hasFinished:Bool = false;

	public function new(path:String, xPos:Float, yPos:Float, loop:Bool = true)
	{
        Application.current.window.onClose.add(function(){
            close();
        });
		window = Application.current.createWindow({
			width: gifWidth,
			height: gifHeight,
			borderless: true,
			alwaysOnTop: true
		});

		/* O construtor não altera a posição por si só. */
		window.x = Std.int(xPos);
		window.y = Std.int(yPos);
		window.title = "";
		
		shouldLoop = loop;

		loadFrames(path);

		window.onRender.add(render);
		Application.current.onUpdate.add(update);
	}

	function loadFrames(path:String)
	{
		var files = FileSystem.readDirectory(path);
		files.sort((a, b) -> Reflect.compare(a, b));

		for (file in files)
		{
			if (!file.endsWith(".png"))
				continue;
			var regex = ~/delay-([0-9.]+)s/; // top 10 maneiras de acertar o timing 💅
			if (!regex.match(file))
				continue;

			var img = Image.fromFile(path + "/" + file);
			frames.push({
				image: img,
				texture: null,
				delay: Std.parseFloat(regex.matched(1))
			});
		}
	}

	function setupGL(gl:OpenGLRenderContext)
	{
		var vertexSource = "attribute vec2 aPosition;
            attribute vec2 aTexCoord;
            varying vec2 vTexCoord;
            
            void main() {
                gl_Position = vec4(aPosition, 0.0, 1.0);
                vTexCoord = aTexCoord;
            }";

		var fragmentSource = "precision mediump float;
            varying vec2 vTexCoord;
            uniform sampler2D uSampler;
            
            void main() {
                gl_FragColor = texture2D(uSampler, vTexCoord);
            }";

		var vertexShader = gl.createShader(gl.VERTEX_SHADER);
		gl.shaderSource(vertexShader, vertexSource);
		gl.compileShader(vertexShader);

		var fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
		gl.shaderSource(fragmentShader, fragmentSource);
		gl.compileShader(fragmentShader);

		program = gl.createProgram();
		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);
		gl.useProgram(program);

		positionAttrib = gl.getAttribLocation(program, "aPosition");
		texCoordAttrib = gl.getAttribLocation(program, "aTexCoord");
		samplerUniform = gl.getUniformLocation(program, "uSampler");

		vertexBuffer = gl.createBuffer();
		texCoordBuffer = gl.createBuffer();
		indexBuffer = gl.createBuffer();

		var indices = new UInt16Array([0, 1, 2, 0, 2, 3]);
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices.length * 2, indices, gl.STATIC_DRAW);

		var texCoords = new Float32Array([
			0.0,
			1.0, // cantin
			1.0,
			1.0,
			1.0, // cantin 2
			0.0,
			0.0,
			0.0
		]);
		gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, texCoords.length * 4, texCoords, gl.STATIC_DRAW);

		for (frame in frames)
		{
			frame.texture = createTexture(gl, frame.image);
		}

		gl.enable(gl.BLEND);
		gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

		gl.disable(gl.DEPTH_TEST);
	}

	function createTexture(gl:OpenGLRenderContext, image:Image):GLTexture
	{
		var texture = gl.createTexture();
		gl.bindTexture(gl.TEXTURE_2D, texture);

		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

		image.premultiplied = false;

		var imageData = image.data;
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, image.width, image.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, imageData);

		return texture;
	}

	function update(dt:Float)
	{
		if (frames.length == 0 || hasFinished)
			return;
		timer += dt / 1000;
		if (timer >= frames[curFrame].delay)
		{
			timer = 0;
			curFrame++;
			
			if (curFrame >= frames.length)
			{
				curFrame = 0;
				if (!shouldLoop)
				{
					hasFinished = true;
					close();
				}
			}
		}
	}

	function render(ctx:RenderContext)
	{
		if (frames.length == 0)
			return;
		if (ctx.gl == null)
			return;

		var gl = ctx.gl;

		if (program == null)
		{
			setupGL(gl);
		}

		var img = frames[curFrame].image;
		var texture = frames[curFrame].texture;

		gl.clearColor(0, 0, 0, 0);
		gl.clear(gl.COLOR_BUFFER_BIT);

		var scale = Math.min(window.width / img.width, window.height / img.height);
		var w = img.width * scale;
		var h = img.height * scale;
		var x = (window.width - w) / 2;
		var y = (window.height - h) / 2;

		var x1 = (x / window.width) * 2 - 1;
		var y1 = 1 - ((y / window.height) * 2);
		var x2 = ((x + w) / window.width) * 2 - 1;
		var y2 = 1 - (((y + h) / window.height) * 2);

		var vertices = new Float32Array([x1, y2,
			x2, y2,
			x2, y1,
			x1, y1
		]);
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, vertices.length * 4, vertices, gl.DYNAMIC_DRAW);

		gl.useProgram(program);

		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, texture);
		gl.uniform1i(samplerUniform, 0);

		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.enableVertexAttribArray(positionAttrib);
		gl.vertexAttribPointer(positionAttrib, 2, gl.FLOAT, false, 0, 0);

		gl.bindBuffer(gl.ARRAY_BUFFER, texCoordBuffer);
		gl.enableVertexAttribArray(texCoordAttrib);
		gl.vertexAttribPointer(texCoordAttrib, 2, gl.FLOAT, false, 0, 0);

		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
	}

	public function close()
	{
		if (window != null)
		{
			window.close();
			window = null;
		}
	}
}
