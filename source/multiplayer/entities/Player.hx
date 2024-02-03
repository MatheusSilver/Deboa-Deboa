// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 2.0.26
// 
package multiplayer.entities;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class Player extends Schema {
	@:type("array", "number")
	public var notes: ArraySchema<Dynamic> = new ArraySchema<Dynamic>();

	@:type("number")
	public var score: Dynamic = 0;

	@:type("number")
	public var hits: Dynamic = 0;

	@:type("number")
	public var fails: Dynamic = 0;

}
