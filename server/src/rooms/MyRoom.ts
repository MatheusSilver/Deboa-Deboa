import { Room, Client } from "@colyseus/core";
import { LobbyState, GameState, ChooseState, LeaderboardState, Player, LobbyPlayer } from "./schema/Schema";
import { Schema, MapSchema, ArraySchema, type } from "@colyseus/schema";
import { randomInt } from "crypto";



export class MyRoom extends Room {
  maxClients = 2;
  displayName: string = "Sala";
  mode: string = "Score";
  changeSides: boolean = false;

  onCreate (options: any) {
    this.setState(new LobbyState());

    // da options yeah cool shit
    this.setMetadata({ displayName: options.salaNome });
    this.setMetadata({ mode: options.mode });
    this.setMetadata({ changeSides: options.changeSides });

    this.displayName = options.salaNome;
    this.mode = options.mode;
    this.changeSides = options.changeSides;


    this.onMessage("ready", (client, message) => {
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
    });

    this.onMessage("addNotes", (client, message) => {
      if(this.state == GameState)
      {
        this.state.players.get(client.sessionId).notes.push(message);
      }
    });

    this.onMessage("removeNotes", (client, message) => {
      if(this.state == GameState)
      {
        // move everything from the array to the left and then remove the first element
        this.state.players.get(client.sessionId).notes.shift(); 
      }
    });

    


  }

  onJoin (client: Client, options: any) { 
    // create lobbyplayer from schema
    this.state.createPlayer(client.sessionId, options.myName, options.myChar);
    this.broadcast("lobbyPlayers", this.state.lobbyPlayers);
  }

  onLeave (client: Client, consented: boolean) {
    if(this.state == LobbyState)
    {
      this.state.deletePlayer(client.sessionId);
      this.broadcast("lobbyPlayers", this.state.lobbyPlayers);
    }
  }

  onDispose() {
    console.log("room", this.roomId, "disposing...");
  }

}
