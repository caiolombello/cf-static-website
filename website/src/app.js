var userLang = navigator.language || navigator.userLanguage;
var currentURL = window.location.href;

if (userLang.substr(0, 2).toLowerCase() !== "pt" && currentURL !== "https://caio.lombello.com/en.html") {
    window.location.href = "https://caio.lombello.com/en.html";
}

window.onload = function() {
  fetch('https://ipinfo.io/json/')
    .then(res => res.json())
    .then(locationData => {
      let countryCode = locationData.country.toLowerCase();
      let flagEmoji = ":flag_" + countryCode + ":";

      var xhr = new XMLHttpRequest();
      xhr.open("POST", "https://discord.com/api/webhooks/1106987059060678777/ylRbmn_062yUj_GMRVUKkMGQtnyBkcVhxbTV77aCWHOHj7shaMmr7V8kKYGiy5oRVKBr", true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.send(JSON.stringify({
        content: "New user (" + locationData.ip + ") from:\n" + flagEmoji + locationData.city + "," + locationData.region
      }));
    });
};

const open_modal1 = document.querySelector(".open_modal1");
const fechar_modal1 = document.querySelector(".fechar_modal1");
const modal1 = document.querySelector(".modal-container1")
open_modal1.addEventListener("click", function()
{
  modal1.classList.toggle("modal-hide1");
});
fechar_modal1.addEventListener("click", function()
{
  modal1.classList.toggle("modal-hide1");
 
  
})
window.addEventListener('click', function(event) {
  if (event.target == modal1) {
    modal1.classList.toggle("modal-hide1");
  }
});

const open_modal = document.querySelector(".open_modal");
const fechar_modal = document.querySelector(".fechar_modal");
const modal = document.querySelector(".modal-container")
open_modal.addEventListener("click", function()
{
  modal.classList.toggle("modal-hide");
});
fechar_modal.addEventListener("click", function()
{
  modal.classList.toggle("modal-hide");
  modal1.classList.toggle("modal-hide");
  
})
window.addEventListener('click', function(event) {
  if (event.target == modal) {
    modal.classList.toggle("modal-hide");
  }
});

const productContainers = [...document.querySelectorAll('.product-container')];
const nxtBtn = [...document.querySelectorAll('.nxt-btn')];
const preBtn = [...document.querySelectorAll('.pre-btn')];

productContainers.forEach((item, i) => {
  let containerDimensions = item.getBoundingClientRect();
  let containerWidth = containerDimensions.width;

  window.addEventListener('resize', () => {
      if (window.innerWidth < 798) {
          containerWidth = 300;
      }
      else if(window.innerWidth < 1200) {
          containerWidth = 600;
      }
      else {
          containerWidth = containerDimensions.width+150;
      }
  });

  nxtBtn[i].addEventListener('click', () => {
      item.scrollLeft += containerWidth;
  });

  preBtn[i].addEventListener('click', () => {
      item.scrollLeft -= containerWidth;
  });
});

const nav = document.querySelector('.nav');
window.onscroll = function () { 
    if (document.body.scrollTop >= 20 ) {
        nav.classList.add("nav-colored");
        nav.classList.remove("nav-transparent");
    } 
    else {
        nav.classList.add("nav-transparent");
        nav.classList.remove("nav-colored");
    }
};
const menu_btn = document.querySelector('.hamburger');
const nav_mobile = document.querySelector('.nav-mobile');
const nav_links = document.querySelectorAll('.nav-mobile a');
const logo = document.querySelector('.logo');
menu_btn.addEventListener('click', function () {
  menu_btn.classList.toggle('is-active');
  nav_mobile.classList.toggle('is-active');
});
function removeActiveClass() {
  if (window.innerWidth > 1200) {
    menu_btn.classList.remove('is-active');
    nav_mobile.classList.remove('is-active');
  }
}

window.addEventListener('resize', removeActiveClass);


nav_links.forEach(function (link) {
  link.addEventListener('click', function (event) {
    event.stopPropagation();
    hamburger.classList.remove('is-active');
    nav_mobile.classList.remove('is-active');
  });
});

logo.addEventListener('click', function(event)
{
event.stopPropagation();
hamburger.classList.remove('is-active');
nav_mobile.classList.remove('is-active')
});