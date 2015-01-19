(function () {

  if (typeof Particles === "undefined") {
    window.Particles = {};
  }


  var Particle = Particles.Particle = function (pos, speed, radius) {
    this.pos = pos;
    this.speed = speed;
    this.radius = radius;
    this.color = Particle.COLOR;
    this.imgCoor = Particle.randomImgCoor();
  };
  Particle.COLOR = "white";

  Particle.getImg = function () {
    var img = new Image();
    img.src = "./vendor/png-transparent-snowflakes.png";
    return img;
  }

  Particle.IMG = Particle.IMG || Particle.getImg();

  Particle.randomImgCoor = function () {
    var x, y;
    x = Math.floor(Math.random() * 0) * 153 + 250;
    y = Math.floor(Math.random() * 0) * 147 + 321;
    return [x, y];
  }

  Particle.prototype.move = function () {
    this.pos[1] += this.speed;
  };

  Particle.prototype.draw = function (ctx) {
    // ctx.beginPath();
    // ctx.arc(this.pos[0], this.pos[1], this.radius, 0, Math.PI * 2);
    // ctx.closePath();
    // ctx.fillStyle = this.color;
    // ctx.fill();
    ctx.drawImage(Particle.IMG,
                  this.imgCoor[0], this.imgCoor[1], 1093, 1090,
                  this.pos[0], this.pos[1], this.radius*2, this.radius*2
                );
  };

})();


// y: 321px
// x: 250px
//
// width: 1093px
// height: 1090px
//
// x-sep: 153px
// y-sep: 147px
//
// 5 across
// 4 down
