document.addEventListener('DOMContentLoaded', function() {
  const toggleButton = document.querySelector('.navbar-toggler');
  const sidebar = document.querySelector('.navigation');
  const icon = document.querySelector('.fa-bars');
  

  // 初期表示の設定
  if (window.innerWidth >= 991) {
    sidebar.classList.add('open');
  } else {
    sidebar.classList.remove('open');
  }

  // 画面サイズが変更された時にサイドバーの表示を切り替える
  window.addEventListener('resize', function() {
    if (window.innerWidth >= 991) {
      sidebar.classList.add('open');
    } else {
      sidebar.classList.remove('open');
      icon.classList.remove('fa-times');
    }
  });

  // トグルボタンがクリックされた時にサイドバーの表示を切り替える
  toggleButton.addEventListener('click', function() {
    sidebar.classList.toggle('open');
    icon.classList.toggle('fa-times');
  });

});
