document.addEventListener('turbolinks:load', () => {
  const toggleButton = document.querySelector('.navbar-toggler');
  const sidebar = document.querySelector('.sidebar-wrapper');

  toggleButton.addEventListener('click', () => {
    sidebar.classList.toggle('active');
  });
});