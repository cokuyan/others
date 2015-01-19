var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function HanoiGame() {
  this.stacks = [[1, 2, 3], [], []]
}

HanoiGame.prototype.isWon = function () {
  if ( this.stacks[1].length === 3 || this.stacks[2].length === 3 ) {
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.isValidMove = function (startTowerIdx, endTowerIdx) {
  var startTower = this.stacks[startTowerIdx];
  var endTower = this.stacks[endTowerIdx];

  if (startTower.length === 0) {
    return false;
  } else if (endTower.length === 0) {
    return true;
  } else {
    return this.stacks[startTowerIdx][0] < this.stacks[endTowerIdx][0];
  }
};

HanoiGame.prototype.move = function (startTowerIdx, endTowerIdx) {
  if (this.isValidMove(startTowerIdx, endTowerIdx)) {
    var disc = this.stacks[startTowerIdx].shift();
    this.stacks[endTowerIdx].unshift(disc);
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.print = function () {
  console.log(JSON.stringify(this.stacks));
};

HanoiGame.prototype.promptMove = function (callback) {
  this.print();
  reader.question("Input starting stack: ", function (startTowerIdx) {
    reader.question("Input destination stack: ", function (endTowerIdx) {
      var start = parseInt(startTowerIdx);
      var end = parseInt(endTowerIdx);

      callback(start, end);
    });
  });
};

HanoiGame.prototype.run = function (completionCallback) {
  var hanoi = this;

  this.promptMove( function (startTowerIdx, endTowerIdx) {
    if (!hanoi.move.bind(hanoi)(startTowerIdx, endTowerIdx)) {
      console.log("Invalid move!");
      hanoi.run(completionCallback);
    } else {
      if (hanoi.isWon()) {
        hanoi.print();
        console.log("You win!");
        return completionCallback();
      } else {
        hanoi.run(completionCallback);
      }
    }
  });
};

var hanoi = new HanoiGame();
hanoi.run(function () {
  reader.close();
});
