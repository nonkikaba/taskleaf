// ページの読み込みが完了したタイミングで処理を開始する
document.addEventListener('turbolinks:load', function () {
  // querySelectorAllは引数で指定したDOM要素を全て取得する
  document.querySelectorAll('td').forEach(function (td) {
    td.addEventListener('mouseover', function (e) {
      // currentTargetはイベントが発生した要素を指す
      e.currentTarget.style.backgroundColor = '#eff'
    });

    td.addEventListener('mouseout', function (e) {
      e.currentTarget.style.backgroundColor = '';
    })
  });
});
