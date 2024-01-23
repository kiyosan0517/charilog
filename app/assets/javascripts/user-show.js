document.addEventListener('DOMContentLoaded', function() {
  const MobileSizes = document.querySelectorAll('.mobile-size');
  const PCSizes = document.querySelectorAll('.pc-size');

  // 初期表示の設定
  updateDisplay();

  // 画面サイズが変更された時にサイドバーの表示を切り替える
  window.addEventListener('resize', updateDisplay);

  function updateDisplay() {
    const isMobile = window.innerWidth <= 767;

    MobileSizes.forEach(function(MobileSize) {
      MobileSize.classList.toggle('d-none', !isMobile);
    });

    PCSizes.forEach(function(PCSize) {
      PCSize.classList.toggle('d-none', isMobile);
    });
  }
});
