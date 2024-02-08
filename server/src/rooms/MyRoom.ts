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

    /*this.onMessage("ready", (client, message) => {
      if(this.state == LobbyState && this.clients.length == 2)
      {
        client.readyState = 1;
        if(this.clients.every((client) => client.readyState == 1)) {
          this.setState(new ChooseState());
          console.log("Initing Game in room " + this.roomId + " with mode " + this.mode);
        }
      }
    });

    this.onMessage("unReady", (client, message) => {
      if(this.state == LobbyState)
      {
        if(!this.clients.every((client) => client.readyState == 1)) {
          client.readyState = 0;
        }
      }
    });

    this.onMessage("chooseSong", (client, message) => {
      if(this.state == ChooseState)
      {
        this.state.songsChosen.push(message);
        if(this.state.songsChosen.length == 2)
        {
          this.setState(new GameState());
          this.broadcast("startGame", {mode: this.mode, changeSides: this.changeSides, song: this.state.songsChosen[randomInt(0, 1)]});
        }
      }
    });*/

    this.onMessage("init-game", (client, message) => {
      this.broadcast("init-game", message);
    });

    this.onMessage("lobbyPlayers", (client, message) => {
      this.sendToOther(client, "lobbyPlayers", message);
    });

    this.onMessage("lobbyInput", (client, message) => {
      this.sendToOther(client, "lobbyInput", message);
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
    var allMessage =
      "entrou" +
      "\n" +
      this.state.lobbyPlayers.get(client.sessionId).username +
      "\n" +
      this.state.lobbyPlayers.get(client.sessionId).char +
      "\n" +
      client.sessionId +
      "\n" +
      options.isHost;
    this.broadcast("lobbyPlayers", allMessage);
  }

  onLeave(client: Client, consented: boolean) {
    switch (this.state) {
      case LobbyState:
        var allMessage =
          "saiu" +
          "\n" +
          this.state.lobbyPlayers.get(client.sessionId).username +
          "\n" +
          this.state.lobbyPlayers.get(client.sessionId).char +
          "\n" +
          client.sessionId;
        this.broadcast("lobbyPlayers", allMessage);
        this.state.deletePlayer(client.sessionId);
        break;
      case GameState:
        var allMessage =
          "saiu" +
          "\n" +
          this.state.lobbyPlayers.get(client.sessionId).username +
          "\n" +
          this.state.lobbyPlayers.get(client.sessionId).char +
          "\n" +
          client.sessionId;
        this.broadcast("lobbyPlayers", allMessage);
        this.state.deletePlayer(client.sessionId);
        //this.broadcast("stop-match", true);
        break;
    }
  }

  onDispose() {
    console.log("room", this.roomId, "disposing...");
  }
}
