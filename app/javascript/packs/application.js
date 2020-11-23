require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

require("stylesheets/application.scss");

require("jquery");
require("jquery-ui");

require("trix");
require("@rails/actiontext");

require("chartkick");
require("chart.js");

import "bootstrap/dist/js/bootstrap";
import "bootstrap/dist/css/bootstrap";

import "@fortawesome/fontawesome-free/css/all";

import "selectize/dist/js/standalone/selectize";

import "youtube";

import "cocoon-js";
import { data } from "jquery";

$(document).on("turbolinks:load", function () {
  $(".chapter-sortable").sortable({
    axis: "y",
    cursor: "grabbing",
    placeholder: "ui-state-highlight",

    update: function (_, ui) {
      let item = ui.item;
      let itemData = item.data();
      let params = { _method: "put" };

      params[itemData.modelName] = { row_order_position: item.index() };

      $.ajax({
        type: "POST",
        url: itemData.updateUrl,
        dataType: "json",
        data: params,
      });
    },
  });

  $(".lesson-sortable").sortable({
    axis: "y",
    cursor: "grabbing",
    placeholder: "ui-state-highlight",
    connectWith: ".lesson-sortable",

    update: function (_, ui) {
      if (ui.sender) return;

      let item = ui.item;
      let itemData = item.data();
      let chapterID = item.parents(".ui-sortable-handle").eq(0).data().id;
      let params = { _method: "put" };

      params[itemData.modelName] = {
        row_order_position: item.index(),
        chapter_id: chapterID,
      };

      $.ajax({
        type: "POST",
        url: itemData.updateUrl,
        dataType: "json",
        data: params,
      });
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
