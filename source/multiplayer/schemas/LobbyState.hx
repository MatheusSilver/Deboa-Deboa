// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 2.0.26
// 
package multiplayer.schemas;


import multiplayer.entities.LobbyPlayer;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class LobbyState extends Schema {
	@:type("map", LobbyPlayer)
	public var lobbyPlayers: MapSchema<LobbyPlayer> = new MapSchema<LobbyPlayer>();

}
