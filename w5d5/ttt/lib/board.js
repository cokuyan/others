function _makeGrid() {
  var grid = [];
  for (var i = 0; i < 3; i++) {
    grid[i] = new Array(undefined, undefined, undefined);
  }

  return grid;
};

function Board(grid) {
  if (grid === undefined) {
    this.grid = _makeGrid();
  } else {
    this.grid = grid;
  }
};

function isX(el, i, arr) {
  return el === "X";
};

function isO(el, i, arr) {
  return el === "O";
};

Array.prototype.transpose = function () {
  var columns = [];
  for (var i = 0; i < this[0].length; i++) {
    columns.push([]);
  }

  for (var i = 0; i < this.length; i++) {
    for (var j = 0; j < this[i].length; j++) {
      columns[j].push(this[i][j]);
    }
  }

  return columns;
};

Board.prototype.dup = function () {
  var grid = [];
  for (var i = 0; i < this.grid[0].length; i++) {
    grid.push([]);
  }

  for (var i = 0; i < this.grid.length; i++) {
    for (var j = 0; j < this.grid[i].length; j++) {
      grid[i].push(this.grid[i][j]);
    }
  }

  return grid;
};

Board.prototype.isFull = function () {
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 3; j++) {
      if (this.isEmpty([i, j])) {
        return false;
      }
    }
  }

  return true;
};

Board.prototype.isWon = function () {
  return !!this.winner();
};

Board.prototype.winner = function() {
  var transArr = this.grid.transpose();

  // construct diagonals
  var diag1 = [];
  var diag2 = [];

  for (var i = 0; i < 3; i++) {
    diag1.push(this.grid[i][i]);
    diag2.push(this.grid[2 - i][i]);
  }

  for (var i = 0; i < 3; i++) {
    // check row win condition
    if (this.grid[i].every(isX)) {
      return "X";
    } else if (this.grid[i].every(isO)) {
      return "O";
    }

    // check column win condition
    if (transArr[i].every(isX)) {
      return "X";
    } else if (transArr[i].every(isO)) {
      return "O";
    }
  }

  // check diag win condition
  if (diag1.every(isX)) {
    return "X";
  } else if (diag1.every(isO)) {
    return "O";
  }

  if (diag2.every(isX)) {
    return "X";
  } else if (diag2.every(isO)) {
    return "O";
  }

  return false;
};

Board.prototype.getPiece = function (pos) {
  return this.grid[pos[0]][pos[1]];
};

Board.prototype.isEmpty = function (pos) {
  return this.getPiece(pos) === undefined;
};

Board.prototype.placeMark = function (pos, mark) {
  if (this.isEmpty(pos)) {
    this.grid[pos[0]][pos[1]] = mark;
    return true;
  } else {
    return false;
  }
};

Board.prototype.print = function () {
  for (var i = 0; i < 3; i++) {
    var rowString = " ";

    for (var j = 0; j < 3; j++) {
      var pos = [i, j];
      rowString += " " +
        ( this.isEmpty(pos) ? "_" : this.getPiece(pos) ) + " ";
    }

    console.log(rowString);
  }
};

module.exports = Board;
