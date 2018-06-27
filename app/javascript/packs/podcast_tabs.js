function podcastTabs() {
  if (document.querySelector('.podcast-tab')) {
    document.querySelectorAll('.podcast-section').forEach( (e) => {
      if (e === document.querySelector('.podcast-0')) {
        e.classList.add('hidden');
      }
    })
    document.querySelectorAll('.podcast-tab').forEach((e) => {
      e.addEventListener('click', (event) => {
        document.querySelectorAll('.podcast-section').forEach( (el) => {
          el.classList.add('hidden');
        })
        const data = event.target.getAttribute('data')
        document.querySelector(`.podcast-${data}`).classList.remove('hidden');
      })
    })
  }
}

export { podcastTabs }
