$(function () {
  var offers = $('#offers-result');
  var no_offers = $('#no_offers');
  var templateItem = $('#templates .result_item');

  function show_offers_list() {
    $('#offers_table_header').show();
    offers.show();
    no_offers.hide();
  }

  function hide_offers_list() {
    $('#offers_table_header').show();
    offers.hide();
    no_offers.show();
  }

  $('#search_form .btn').click(function () {
    offers.html('');
    $.ajax({
      url: 'get_offers',
      data: $('#search_form').serialize(),
      type: 'POST',
      success: function (result) {
        if (result.length == 0) {
          hide_offers_list(false);
          return;
        }
        $.each(result, function (index) {
          var item = result[index];
          var lineItem = templateItem.clone();
          lineItem.find('.item-title').html(item[0]);
          lineItem.find('.item-payout').html(item[1]);
          lineItem.find('.item-thumbnail').attr('src', item[2]);
          offers.append(lineItem);
        });
        show_offers_list();
      }
    });
  });
});