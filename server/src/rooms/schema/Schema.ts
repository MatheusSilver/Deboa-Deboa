import { Schema, ArraySchema, MapSchema, Context, type } from "@colyseus/schema";
import { MyRoom } from "../MyRoom";

export class LobbyPlayer extends Schema { // player do lobby
  @type("string") username = "Player";
  @type("string") char = "bf"; // unused for now
  @type("string") isHost = "0";
}

export class LobbyState extends Schema {
  @type({ map: LobbyPlayer }) lobbyPlayers = new MapSchema<LobbyPlayer>();

  createPlayer (id: string, username: string, char: string, isHost:String) {
    let player = new LobbyPlayer();
    player.username = username;
    player.char = char;
    this.lobbyPlayers.set(id, player); // coloca o player yey
    console.log(this.lobbyPlayers.get(id).username);
  }

  deletePlayer (id: string) {
    this.lobbyPlayers.delete(id); // tira o player yey
  }

}

export class ChooseState extends Schema {
  //for when players are choosing the song to play
  @type(["number"]) songsChosen = new ArraySchema<number>();
}

export class Player extends Schema { // player do gameState
  @type(["number"]) notes = new ArraySchema<number>();
  @type("number") score = 0;
  @type("number") hits = 0;
  @type("number") fails = 0;
}

export class GameState extends Schema {
  @type({ map: Player }) players = new MapSchema<Player>();
}

export class LeaderboardState extends Schema {

}

