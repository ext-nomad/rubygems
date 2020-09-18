require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

import "bootstrap";
require("trix");
require("@rails/actiontext");

require("chartkick");
require("chart.js");

// import "../trix-editor-overrides"

require("jquery");
require("jquery-ui");

import "youtube";

require("selectize");

import "cocoon-js";
import { data } from "jquery";

$(document).on("turbolinks:load", function () {
  $(".lesson-sortable").sortable({
    cursor: "grabbing",
    cursorAt: { left: 10 },
    placeholder: "ui-state-highlight",
    update: function (_e, ui) {
      let item = ui.item;
      let item_data = item.data();
      let params = { _method: "put" };
      params[item_data.modelName] = { row_order_position: item.index() };
      $.ajax({
        type: "POST",
        url: item_data.updateUrl,
        dataType: "json",
        data: params,
      });
    },
    stop: function (_e, _ui) {
      console.log("stop called when finishing sort of cards");
    },
  });

  $("video").bind("contextmenu", function () {
    return false;
  });

  $(".selectize-tags").selectize({
    create: function (input, callback) {
      $.post("/tags.json", { tag: { name: input } }).done(function (response) {
        console.log(response);
        callback({ value: response.id, text: response.name });
      });
    },
  });
});
