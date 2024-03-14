$(function () {
  $("#search_clear_btn").on("click", function () {
      clearForm(this.form);
  });

  function clearForm (form) {
    $(form)
      .find("input, select, textarea")
      .not(":button, :submit, :reset, :hidden")
      .val("")
      .prop("selected", false)
    ;
    $('select[name=sort_order]').children().first().attr('selected', true);
  }
});
