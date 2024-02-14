// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 2.0.26
// 
package multiplayer.entities;

import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class LobbyPlayer extends Schema {
	@:type("string")
	public var username: String = "";

	@:type("string")
	public var char: String = "";

	@:type("string")
	public var isHost: String = "";

	@:type("string")
	public var noteSkin: String = "";

}
