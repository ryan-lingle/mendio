function tabPicker() {
  if (document.querySelector('.tab')) {
    document.querySelectorAll('.tab').forEach((e) => {
      e.addEventListener('click', (event) => {
        if (event.target.innerText == 'Donations') {
          document.querySelector('.my-donations').classList.remove('hidden')
          document.querySelector('.following').classList.add('hidden')
          document.querySelector('.followers').classList.add('hidden')
        } else if (event.target.innerText == 'Following') {
          document.querySelector('.following').classList.remove('hidden')
          document.querySelector('.my-donations').classList.add('hidden')
          document.querySelector('.followers').classList.add('hidden')
        } else {
          document.querySelector('.followers').classList.remove('hidden')
          document.querySelector('.my-donations').classList.add('hidden')
          document.querySelector('.following').classList.add('hidden')
        }
      })
    })
  }
};

export { tabPicker };
