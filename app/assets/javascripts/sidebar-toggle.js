document.addEventListener('DOMContentLoaded', function() {
  const toggleButton = document.querySelector('.navbar-toggler');
  const sidebar = document.querySelector('.navigation');
  const icon = document.querySelector('.fa-bars');
  const maskArea = document.querySelector('.mask-area');

  function closeSidebar() {
    sidebar.classList.remove('open');
    icon.classList.remove('fa-times');
    maskArea.classList.remove('active');
  }

  // 初期表示の設定
  if (window.innerWidth >= 992) {
    sidebar.classList.add('open');
  } else {
    sidebar.classList.remove('open');
  }

  // 画面サイズが変更された時にサイドバーの表示を切り替える
  window.addEventListener('resize', function() {
    if (window.innerWidth >= 992) {
      sidebar.classList.add('open');
    } else {
      closeSidebar();
    }
  });

  // トグルボタンがクリックされた時にサイドバーの表示を切り替える
  toggleButton.addEventListener('click', function() {
    sidebar.classList.toggle('open');
    icon.classList.toggle('fa-times');
    maskArea.classList.toggle('active');
  });

  // サイドバー以外の領域がクリックされた時にサイドバーを非表示にする
  document.addEventListener('click', function(event) {
    const isToggleButton = event.target === toggleButton || toggleButton.contains(event.target);
    const isSidebar = event.target === sidebar || sidebar.contains(event.target);
    
    if (!isToggleButton && !isSidebar && window.innerWidth <= 991) {
      closeSidebar();
    }
  });

});
