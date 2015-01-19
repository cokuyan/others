(function() {

  if (typeof Corgis === "undefined") {
    window.Corgis = {};
  }

  var Carousel = $.Carousel = function (el) {
    this.$el = $(el);
    this.activeIdx = 0;
    $(".slide-left").on("click", this.slideLeft.bind(this));
    $(".slide-right").on("click", this.slideRight.bind(this));
    this.transitioning = false;
  }

  Carousel.prototype.slide = function (dir) {
    if (this.transitioning) {
      return;
    }
    this.transitioning = true
    var $current = this.$el.children().eq(this.activeIdx);
    this.activeIdx += dir;
    this.activeIdx %= 4;
    var $next = this.$el.children().eq(this.activeIdx);
    $next.addClass("active");
    if (dir === -1) {
      $next.addClass("left");
      $current.addClass("right");
    } else {
      $next.addClass("right");
      $current.addClass("left");
    }
    setTimeout(function () {
      $next.removeClass("left right");
    }, 0)

    $current.one("transitionend", function (event) {
      $current.removeClass("left right active");
      this.transitioning = false;
    }.bind(this));


  }

  Carousel.prototype.slideLeft = function () {
    this.slide(1);
  };

  Carousel.prototype.slideRight = function () {
    this.slide(-1);
  };

  $.fn.carousel = function () {
    return this.each(function () {
      new $.Carousel(this);
    });
  };

}());
