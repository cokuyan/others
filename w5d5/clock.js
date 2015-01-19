function Clock () {
}

Clock.TICK = 5000;




Clock.prototype.printTime = function () {
  // Format the time in HH:MM:SS
  var hours, minutes, seconds;
  hours = this.currentTime.getHours();
  minutes = this.currentTime.getMinutes();
  seconds = this.currentTime.getSeconds();
  console.log(hours + ":" + minutes + ":" + seconds);
};

Clock.prototype.run = function () {
  // 1. Set the currentTime.
  this.currentTime = new Date();
  // 2. Call printTime.
  this.printTime();
  // 3. Schedule the tick interval.
  this._tick();
};

Clock.prototype._tick = function () {
  // 1. Increment the currentTime.
  var cur = this.currentTime.getTime();
  var clock = this;

  setInterval(function () {
    cur += Clock.TICK;
    clock.currentTime.setTime(cur);
    clock.printTime();
  }, Clock.TICK);

  // 2. Call printTime.
};

var clock = new Clock();
clock.run();
