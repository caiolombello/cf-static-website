var userLang = navigator.language || navigator.userLanguage;
var currentURL = window.location.href;

if (userLang.substr(0, 2).toLowerCase() !== "pt" && currentURL !== "https://caio.lombello.com/en.html") {
    window.location.href = "https://caio.lombello.com/en.html";
}

window.onload = function() {
  fetch('http://ip-api.com/json/')
    .then(res => res.json())
    .then(locationData => {
      let countryCode = locationData.countryCode.toLowerCase();
      let flagEmoji = ":flag_" + countryCode + ":";

      var xhr = new XMLHttpRequest();
      xhr.open("POST", "https://discord.com/api/webhooks/1106987059060678777/ylRbmn_062yUj_GMRVUKkMGQtnyBkcVhxbTV77aCWHOHj7shaMmr7V8kKYGiy5oRVKBr", true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.send(JSON.stringify({
        content: "New user (" + locationData.query + ") from:\n" + flagEmoji + locationData.city + "," + locationData.region
      }));
    });
};

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
  link.addEventListener('click', function () {
    menu_btn.classList.remove('is-active');
    nav_mobile.classList.remove('is-active');
  });
});
logo.addEventListener('click', function()
{
menu_btn.classList.remove('is-active');
nav_mobile.classList.remove('is-active')
})

window.addEventListener("resize", reportWindowSize);

const contactForm = document.getElementById('contact-form');
contactForm.addEventListener('submit', async (event) => {
  event.preventDefault();

  const formData = new FormData(event.target);
  const formJSON = Object.fromEntries(formData.entries());

  try {
    const response = await fetch('https://formspree.io/f/meqwnard', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify(formJSON),
    });

    if (response.ok) {
      alert('Mensagem enviada com sucesso!');
      contactForm.reset();
    } else {
      alert('Ocorreu um erro ao enviar a mensagem. Tente novamente.');
    }
  } catch (error) {
    console.error('Erro ao enviar o formulário:', error);
    alert('Ocorreu um erro ao enviar a mensagem. Tente novamente.');
  }
});


