HTMLWidgets.widget({
  name: "jellyfisher",

  type: "output",

  factory: function (el, width, height) {
    return {
      renderValue: function (x) {
        // Ensure that absolute positioning works in R markdown
        el.style.position = "relative";

        jellyfish.setupGui(
          el,
          {
            samples: HTMLWidgets.dataframeToD3(x.samples),
            phylogeny: HTMLWidgets.dataframeToD3(x.phylogeny),
            compositions: HTMLWidgets.dataframeToD3(x.compositions),
            ranks: [], // TODO
          },
          x.options,
          null,
          x.controls
        );
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      },
    };
  },
});
