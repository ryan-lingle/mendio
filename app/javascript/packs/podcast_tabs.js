function podcastTabs() {
  if (document.querySelector('.podcast-tab')) {
    document.querySelectorAll('.podcast-group').forEach( (e) => {
      if (e !== document.querySelector('.podcast-0')) {
        e.classList.add('hidden');
      }
    })
    document.querySelectorAll('.podcast-tab').forEach( (e) => {
      if (e === document.querySelector('.podcast-tab-0')) {
        e.classList.add('current');
      }
    })
    document.querySelectorAll('.podcast-tab').forEach((e) => {
      e.addEventListener('click', (event) => {
        document.querySelectorAll('.podcast-tab').forEach( (x) => {
          x.classList.remove('current');
        })
        document.querySelectorAll('.podcast-group').forEach( (el) => {
          el.classList.add('hidden');
        })
        const data = event.target.getAttribute('data')
        document.querySelector(`.podcast-${data}`).classList.remove('hidden');
        document.querySelector(`.podcast-tab-${data}`).classList.add('current')
      })
    })
  }
}

export { podcastTabs }
