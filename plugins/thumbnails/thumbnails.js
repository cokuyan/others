(function() {

  if (typeof ThumbnailsApp === "undefined") {
    window.ThumbnailsApp = {};
  }

  var Thumbnails = $.Thumbnails = function (el) {
    this.$el = $(el);
    this.$gutterImages = $(".gutter-images");
    this.$activeImage = this.$gutterImages.children().eq(0);
    this.activate(this.$activeImage);
    this.gutterIdx = 0;
    this.$images = this.$gutterImages.children();
    this.fillGutterImages();
    this.$gutterImages.on("click", "img", this.clickCallback.bind(this));
    this.$gutterImages.on("mouseenter", "img", this.enterCallback.bind(this));
    this.$gutterImages.on("mouseleave", "img", this.leaveCallback.bind(this));
    $("#right").on("click", this.moveRight.bind(this));
    $("#left").on("click", this.moveLeft.bind(this));
  }

  Thumbnails.prototype.fillGutterImages = function () {
    this.$gutterImages.empty();
    for (var i = this.gutterIdx; i < this.gutterIdx + 5; i++) {
      this.$gutterImages.append(this.$images.eq(i));
    }
  };

  Thumbnails.prototype.clickCallback = function (event) {
    this.$activeImage = $(event.currentTarget);
    this.activate(this.$activeImage);
  };

  Thumbnails.prototype.enterCallback = function (event) {
    this.activate($(event.currentTarget));
  };

  Thumbnails.prototype.leaveCallback = function (event) {
    this.activate(this.$activeImage);
  };

  Thumbnails.prototype.move = function (dir) {
    this.gutterIdx += dir;
    this.gutterIdx %= 20;
    this.fillGutterImages();
  };

  Thumbnails.prototype.moveLeft = function (event) {
    event.preventDefault();
    this.move(-1);
  };

  Thumbnails.prototype.moveRight = function (event) {
    event.preventDefault();
    this.move(1);
  };

  Thumbnails.prototype.activate = function ($img) {
    var $copy = $img.clone();
    $(".active").empty();
    $(".active").append($copy);
  };

  $.fn.thumbnails = function () {
    return this.each(function () {
      new $.Thumbnails(this);
    });
  };

}());
