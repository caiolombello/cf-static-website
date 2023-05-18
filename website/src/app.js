function isInViewport(element) {
  const rect = element.getBoundingClientRect();
  return (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
  );
}

function toggleClassOnScroll(element, className) {
  window.addEventListener('scroll', function() {
      if (isInViewport(element)) {
          element.classList.add(className);
      }
  });
}

function toggleModal(openButton, closeButton, modalContainer, hideClassName) {
  openButton.addEventListener('click', function() {
      modalContainer.classList.toggle(hideClassName);
  });

  closeButton.addEventListener('click', function() {
      modalContainer.classList.toggle(hideClassName);
  });

  window.addEventListener('click', function(event) {
      if (event.target == modalContainer) {
          modalContainer.classList.toggle(hideClassName);
      }
  });
}

function scrollBehaviour(navElement, scrollHeight, classOne, classTwo) {
  window.onscroll = function () {
      if (document.body.scrollTop >= scrollHeight || document.documentElement.scrollTop >= scrollHeight) {
          navElement.classList.add(classOne);
          navElement.classList.remove(classTwo);
      } else {
          navElement.classList.add(classTwo);
          navElement.classList.remove(classOne);
      }
  };
}

function toggleButton(button, navMobile, hamburger) {
  button.addEventListener('click', function () {
      button.classList.toggle('is-active');
      navMobile.classList.toggle('is-active');
  });

  hamburger.addEventListener('click', function(event) {
      event.stopPropagation();
      button.classList.remove('is-active');
      navMobile.classList.remove('is-active');
  });
}

function removeActiveClassOnResize(button, navMobile) {
  window.addEventListener('resize', function() {
      if (window.innerWidth > 1200) {
          button.classList.remove('is-active');
          navMobile.classList.remove('is-active');
      }
  });
}

var userLang = navigator.language || navigator.userLanguage;
var currentURL = window.location.href;

if (userLang.substr(0, 2).toLowerCase() !== "pt" && currentURL !== "https://caio.lombello.com/en.html") {
  window.location.href = "https://caio.lombello.com/en.html";
}

window.onload = function() {
  // Fetch location data and send to server
  // ...

  toggleModal(
      document.querySelector(".open_modal1"),
      document.querySelector(".fechar_modal1"),
      document.querySelector(".modal-container1"),
      "modal-hide1"
  );

  toggleModal(
      document.querySelector(".open_modal"),
      document.querySelector(".fechar_modal"),
      document.querySelector(".modal-container"),
      "modal-hide"
  );

  toggleClassOnScroll(document.querySelector('#experiencias'), 'experiencias-animate');

  scrollBehaviour(document.querySelector('.nav'), 20, "nav-colored", "nav-transparent");

  toggleButton(document.querySelector('.hamburger'), document.querySelector('.nav-mobile'), document.querySelector('.logo'));

  removeActiveClassOnResize(document.querySelector('.hamburger'), document.querySelector('.nav-mobile'));

  const nav_links = document.querySelectorAll('.nav-mobile a');
  nav_links.forEach(function (link) {
      link.addEventListener('click', function (event) {
          event.stopPropagation();
          document.querySelector('.hamburger').classList.remove('is-active');
          document.querySelector('.nav-mobile').classList.remove('is-active');
      });
  });
};