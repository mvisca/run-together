// Element.getBoundingClientRect() method returns the size of an element and its position relative to the viewport.
// pageYOffset is a read - only window property that returns the number of pixels the document has been scrolled vertically.
// slice extracts a section of a string without modifying original string
//offsetTop - A Number, representing the top position of the element, in pixels

// ********** close links ************
window.addEventListener('DOMContentLoaded', selectWhenLoaded);
// window.onload = selectWhenLoaded;
let navContainer = window;
let navHeight = window;
let linksHeight = window;
let fixedNav = window;

function selectWhenLoaded() {
  console.log('SE CARGÓ LA FUNC');
  const navToggle = document.querySelector('.nav-toggle');
  navToggle.addEventListener('click', showNavLinks);
  // get heights of div navbar wraper && UL
  navContainer = document.getElementById('nav');
  navHeight = navContainer.getBoundingClientRect().height;
  linksHeight = document.querySelector('.links-container').getBoundingClientRect().height;
  // Boolean
  fixedNav = navContainer.classList.contains('fixed-nav');
}

function showNavLinks() {
  const linksContainer = document.querySelector('.links-container');
  const linksList = document.querySelector('.links');

  const containerHeight = linksContainer.getBoundingClientRect().height;
  const linksHeight = linksList.getBoundingClientRect().height;

  if (containerHeight === 0) {
    linksContainer.style.height = `${linksHeight}px`;
  } else {
    linksContainer.style.height = `0px`;
  }
};

// ********** fixed navbar ************

window.addEventListener('scroll', fixedNavbar);
function fixedNavbar(e) {

  const navContainer = document.getElementById('nav');
  const navHeight = navContainer.getBoundingClientRect().height;

  const topLink = document.querySelector('.top-link');

  const scrolledDown = window.pageYOffset;
  const displayHeight = window.innerHeight;

  if (scrolledDown > navHeight) {
    navContainer.classList.add('fixed-nav');
  } else {
    navContainer.classList.remove('fixed-nav');
  }

  if (scrolledDown > displayHeight * 0.9) {
    topLink.classList.add('show-link');
  } else {
    topLink.classList.remove('show-link');
  }
};
// ********** smooth scroll ************
// select links container UL element
const linksContainer = document.querySelector('.links-container');

// selects node of LI
const scrollLinks = document.querySelectorAll('.scroll-link');

// selects div navbar wraper
// MOVED TO DOMContentLoaded (LINE 9) FUNCTION selectWhenLoaded

scrollLinks.forEach((link) => { link.addEventListener('click', smoothScroll) });

function smoothScroll(e) {
  e.preventDefault();
  const id = e.currentTarget.getAttribute("href").slice(1);
  const scrollTarget = document.getElementById(id);
  let position = scrollTarget.offsetTop;

  if (!fixedNav) {
    position -= navHeight;
  }

  if (navHeight > 82) {
    position += linksHeight;
  }

  window.scrollTo({
    left: 0,
    top: position
  });
  linksContainer.style.height = 0;
};
