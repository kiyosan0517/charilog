$(document).ready(function() {
  // 初期状態ではクリアボタンを非表示にする
  $('#remove_rakuten_item_button').hide();

  // ”使用アイテムを登録する”ボタンをクリックしたときの処理
  $(document).on('click', '#rakuten-link-button', function(e) {
    e.preventDefault();

    // モーダルの表示
    $('#rakuten-modal').modal('show');
  });
});

// モーダルウィンドウ内の"追加"ボタンがクリックされたときの処理
$(document).on('click', '.rakuten-add-button', function(e) {
  e.preventDefault();

  // JSON形式のデータに変換
  var jsonData = JSON.stringify({
    item_code: $(this).data('code'),
    name: $(this).data('item-name'),
    price: $(this).data('price'),
    image: $(this).data('image-url'),
    rakuten_url: $(this).data('url')
  });

  // アイテムを4つまでフィールドに登録、表示
  for (var i = 1; i <= 4; i++) {
    var itemField = $("#post_items" + i);
    if (itemField.val() === "") {
      itemField.val(jsonData);
      $('#rakuten_image' + i).attr('src', $(this).data('image-url')).toggleClass('d-none');
      $('#rakuten_name_text' + i).text($(this).data('item-name'));
      $('#rakuten_url_text' + i).text($(this).data('url')).toggleClass('text-center');
      if (i !== 1) {
        $('#rakuten_data_wrap' + i).addClass('border-top mt-3 pt-3');
      }
      break;
    }
  }
  // クリアボタンの表示
  $('#remove_rakuten_item_button').show();
  // モーダルの非表示化
  $('#rakuten-modal').modal('hide');
});

// 削除ボタンをクリックした時の処理
$(document).on('click', '#remove_rakuten_item_button', function(e) {
  e.preventDefault();

  // プレビューを削除
  for (var i = 1; i <= 4; i++) {
    var urlTextElement = $('#rakuten_url_text' + i);
    
    $("#post_items" + i).val("");
    $('#rakuten_image' + i).removeAttr('src').toggleClass('d-none');
    $('#rakuten_name_text' + i).text('');
    $('#rakuten_data_wrap' + i).removeClass('border-top mt-3 pt-3');
    
    if (i === 1) {
      urlTextElement.text('登録アイテムはありません');
    } else {
      urlTextElement.text('');
    }
    urlTextElement.toggleClass('text-center');
  }
  // クリアボタンの非表示化
  $(this).hide();
});
