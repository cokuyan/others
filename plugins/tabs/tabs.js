(function() {

  if (typeof TabsApp === "undefined") {
    window.TabsApp = {};
  }

  $.Tabs = function (el) {
    this.$el = $(el);
    this.$contentTabs = $(this.$el.data("content-tabs"));
    this.$activeTab = this.$contentTabs.find(".active");
    this.$el.on("click", "a", this.clickTab.bind(this));
  }

  $.Tabs.prototype.clickTab = function (event) {
    event.preventDefault();

    var $target = $(event.currentTarget);
    $(".active").removeClass("active");
    this.$activeTab.addClass("transitioning");
    $target.addClass("active");

    this.$activeTab.one("transitionend", endTransition.bind(this));

    function endTransition(transEvent) {
      var $transTab = $(transEvent.currentTarget);
      $transTab.removeClass("transitioning");

      var $targetTab = $($target.attr("href"));

      $targetTab.addClass("transitioning");

      setTimeout(function () {
        $targetTab.removeClass("transitioning").addClass("active");
      }, 0)
      this.$activeTab = $targetTab;

    }

  };

  $.fn.tabs = function () {
    return this.each(function () {
      new $.Tabs(this);
    });
  };


}());
