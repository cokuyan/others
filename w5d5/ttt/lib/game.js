var Board = require("./board");
var HumanPlayer = require("./humanPlayer");
var ComputerPlayer = require("./computerPlayer");

function Game(player1, player2) {
  this.board = new Board();

  if (player1 === "Human") {
    this.player1 = new HumanPlayer("X", this.board);
  } else {
    this.player1 = new ComputerPlayer("X", this.board);
  }

  if (player2 === "Human") {
    this.player2 = new HumanPlayer("O", this.board);
  } else {
    this.player2 = new ComputerPlayer("O", this.board);
  }

  this.currentPlayer = this.player1;
};

Game.prototype.run = function (completionCallback) {
  var game = this;
  var callback = function (pos, mark) {
    if (game.board.placeMark(pos, mark)) {
      if (game.board.isWon()) {
        game.board.print();
        console.log(game.board.winner() + " has won!");
        return completionCallback();
      } else if (game.board.isFull()) {
        game.board.print();
        console.log("It's a draw :/");
        return completionCallback();
      } else {
        game.switchPlayer();
        game.run(completionCallback);
      }
    } else {
      console.log("Invalid move!");
      game.run(completionCallback);
    }
  };

  this.board.print();
  this.currentPlayer.promptMove(callback);
};

Game.prototype.switchPlayer = function () {
  if (this.currentPlayer === this.player1) {
    this.currentPlayer = this.player2;
  } else {
    this.currentPlayer = this.player1;
  }
};

module.exports = Game;
