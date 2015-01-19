var Board = require('./board');

function ComputerPlayer(mark, board) {
  this.mark = mark;
  this.board = board;
};

ComputerPlayer.prototype.isWinningMove = function (pos) {
  var testBoard = new Board(this.board.dup());
  testBoard.placeMark(pos, this.mark);
  return testBoard.winner === this.mark;
};

ComputerPlayer.prototype.randomMove = function () {
  var x, y;
  x = Math.floor(Math.random() * 3);
  y = Math.floor(Math.random() * 3);

  return [x, y];
};

ComputerPlayer.prototype.generateMove = function () {
  // search for winning move
  for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 3; j++) {
      if (this.board.isEmpty([i, j]) && this.isWinningMove([i, j])) {
        return [i, j];
      }
    }
  }

  // if no winning move, make a random move
  do {
    var pos = this.randomMove();
  } while (!this.board.isEmpty(pos));

  return pos;
};

ComputerPlayer.prototype.promptMove = function (callback) {
  var pos = this.generateMove();
  console.log("The AI has made move: " + pos);
  callback(pos, this.mark);
};

module.exports = ComputerPlayer;
