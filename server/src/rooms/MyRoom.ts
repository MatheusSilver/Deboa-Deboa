import { Room, Client } from "@colyseus/core";
import {
  LobbyState,
  GameState,
  ChooseState,
  LeaderboardState,
  Player,
  LobbyPlayer,
} from "./schema/Schema";
import { Schema, MapSchema, ArraySchema, type } from "@colyseus/schema";
import { randomInt } from "crypto";
import { stat } from "fs";

export class MyRoom extends Room {
  maxClients = 2;
  displayName: string = "Sala";
  mode: string = "Score";
  changeSides: boolean = false;

  onCreate(options: any) {
    this.setState(new LobbyState());

    // da options yeah cool shit
    this.setMetadata({ displayName: options.salaNome });
    this.setMetadata({ mode: options.mode });
    this.setMetadata({ changeSides: options.changeSides });

    this.displayName = options.salaNome;
    this.mode = options.mode;
    this.changeSides = options.changeSides;

    this.onMessage("init-game", (client, message) => {
      this.broadcast("init-game", message);
    });

    this.onMessage("lobbyPlayers", (client, message) => {
      this.sendToOther(client, "lobbyPlayers", message);
    });

    this.onMessage("lobbyInput", (client, message) => {
      this.broadcast("lobbyInput", message);
    });

    this.onMessage("input-game", (client, message) => {
      this.sendToOther(client, "input-game", message);
    });

    this.onMessage("enviarMisses", (client, message) => {
      this.sendToOther(client, "enviarMisses", message);
    });

    this.onMessage("toPronto", (client, message) => {
      this.broadcast("toPronto", message);
    });

    this.onMessage("queroSair", (client, message) => {
      this.broadcast("queroSair", message);
    });
  }

  sendToOther(client: Client, type: string, message: string) {
    this.clients.forEach((client1) => {
      if (client1 != client) {
        client1.send(type, message);
      }
    });
  }

  onJoin(client: Client, options: any) {
    this.state.createPlayer(
      client.sessionId,
      options.myName,
      options.myChar,
      options.isHost,
    );
    if (options.isHost == "1") {
      client.send("lobbyPlayers", {"type": "entrou","username":this.state.lobbyPlayers.get(this.clients[0].sessionId).username, 
      "char": this.state.lobbyPlayers.get(this.clients[0].sessionId).char, "sessionId": this.clients[0].sessionId, "playerIndex": this.state.lobbyPlayers.get(this.clients[0].sessionId).isHost});
    }
    this.broadcast("lobbyPlayers", {"type": "entrou","username":this.state.lobbyPlayers.get(client.sessionId).username, 
    "char": this.state.lobbyPlayers.get(client.sessionId).char, "sessionId": client.sessionId, "playerIndex": this.state.lobbyPlayers.get(client.sessionId).isHost});
  }

  onLeave(client: Client, consented: boolean) {
    if (this.state.lobbyPlayers.get(client.sessionId).isHost == "1") {
      var allMessage =
        "saiu" +
        "\n" +
        this.state.lobbyPlayers.get(client.sessionId).username +
        "\n" +
        this.state.lobbyPlayers.get(client.sessionId).char +
        "\n" +
        client.sessionId +
        "\n" +
        this.state.lobbyPlayers.get(client.sessionId).isHost;

      this.broadcast("lobbyPlayers", {"type": "saiu","username":this.state.lobbyPlayers.get(client.sessionId).username, 
    "char": this.state.lobbyPlayers.get(client.sessionId).char, "sessionId": client.sessionId, "playerIndex": this.state.lobbyPlayers.get(client.sessionId).isHost});
      this.broadcast("stop-match", true);
    } else if (this.state.lobbyPlayers.get(client.sessionId).isHost == "0") {
      this.broadcast("leave", { cause: 9000 });
      this.disconnect();
    }
    this.state.deletePlayer(client.sessionId);
  }

  onDispose() {
    console.log("room", this.roomId, "disposing...");
  }
}
