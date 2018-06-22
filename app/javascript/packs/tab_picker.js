function tabPicker() {
  if (document.querySelector('.user-feed')) {
    document.querySelectorAll('.tab').forEach((e) => {
      e.addEventListener('click', (event) => {
        console.log(event.target.getAttribute('data'))
        if (event.target.getAttribute('data') == 'donations') {
          document.querySelector('.my-donations').classList.remove('hidden')
          document.querySelector('.following').classList.add('hidden')
          document.querySelector('.followers').classList.add('hidden')
        } else if (event.target.getAttribute('data') == 'following') {
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
