package async;

#if macro
import haxe.macro.Context;
#end

class Async {
	public static macro function async(expr:haxe.macro.Expr) {
		expr = Context.storeTypedExpr(Context.typeExpr(expr));
        return macro untyped __js__("(async {0})", ${expr})();
	}

	public static macro function await(expr:haxe.macro.Expr) {
        expr = Context.storeTypedExpr(Context.typeExpr(expr));
		return switch (haxe.macro.Context.typeof(expr)) {
			case TInst(_.toString() => "js.Promise", [t]):
				var ct = haxe.macro.TypeTools.toComplexType(t);
				return macro(untyped __js__("await {0}", ${expr}) : $ct);

			default:
				throw 'await() is only available for promises';
		}
	}

    public static macro function asyncPromise(expr:haxe.macro.Expr) {
        expr = Context.storeTypedExpr(Context.typeExpr(expr));
		return macro untyped __js__("(new Promise(async {0}))", ${expr});
	}
}
