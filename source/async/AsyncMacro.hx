package async;

import haxe.macro.Expr;
#if macro
import haxe.macro.Context;
#end

class AsyncMacro {

    public static function macroBuild() {
        var fields = Context.getBuildFields();
        for (field in fields) {
            function e(expr) return { expr : expr, pos : field.pos };
            switch(field.kind) {
                case FieldType.FFun(f):
                    // trace(field.name);
                    // trace(f.expr);
                    for (m in field.meta) {
                    switch(m.name) {
                        case ":async":
                            var ex = e(EBlock([
                                e(EReturn(
                                    e(EUntyped(
                                        e(ECall(
                                            e(ECall(
                                                e(EConst(CIdent("__js__"))),
                                                [
                                                    e(EConst(CString("(async {0})"))),
                                                    e(EFunction(null,
                                                        { args : []
                                                        , expr : f.expr
                                                        , params : []
                                                        , ret : null
                                                        }
                                                    ))
                                                ]
                                            )),
                                            []
                                        ))
                                    ))
                                ))
                            ]));
                            f.expr = ex;
                        default:
                    }
                }
                default:
            }
        }
        return fields;
    }
}
