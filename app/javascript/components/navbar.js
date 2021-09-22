const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar-rt');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.add('navbar-rt-white');
      } else {
        navbar.classList.remove('navbar-rt-white');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
