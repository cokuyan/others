var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

function HumanPlayer (mark, board) {
  this.mark = mark;
  this.board = board;
};

HumanPlayer.prototype.promptMove = function (callback) {
  var human = this;
  reader.question("Input Move Coordinates: ", function (raw_pos) {
    var pos = raw_pos.split(",").map(function(num) {
      return parseInt(num);
    });

    callback(pos, human.mark)
  });
};

module.exports = HumanPlayer;
