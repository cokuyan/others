(function () {

  if (typeof Particles === "undefined") {
    window.Particles = {};
  }

  Particles.particles = [];
  Particles.tick = 0;


  Particles.createParticles = function () {
    //check on every 10th refresh tick
    if (this.tick % 10 === 0) {
      //add particle if fewer than 100
      if (this.particles.length < 200) {
        var pos = [Math.random() * window.innerWidth, 0];
        var speed = 2 + Math.random() * 3;
        var radius = 5 + Math.random() * 10;
        this.particles.push(new this.Particle(pos, speed, radius));
      }
    }
  }

  Particles.updateParticles = function () {
    for (var i = 0; i < this.particles.length; i++) {
      this.particles[i].move();
    }
  };

  Particles.killParticles = function () {
    for (var i = 0; i < this.particles.length; i++) {
      if (this.particles[i].pos[1] > window.innerHeight) {
        this.removeParticle(i);
      }
    }
  }

  Particles.removeParticle = function (idx) {
    this.particles.splice(idx, 1);
  }

  Particles.drawParticles = function () {
    var ctx = window.ctx;
    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, window.innerWidth, window.innerHeight);
    for (var i = 0; i < this.particles.length; i++) {
      this.particles[i].draw(ctx);
    }
  };

  Particles.run = function () {
    window.requestAnimFrame(Particles.run); //.bind(this)?
    Particles.createParticles();
    Particles.updateParticles();
    Particles.killParticles();
    Particles.drawParticles();
  };

})();
