import { executePodcastSearch } from '../packs/podcast'
function modal() {
  document.querySelectorAll('.modal-trigger').forEach((e) => {
    e.addEventListener('click', (event) => {
      executePodcastSearch();
      document.querySelector('.modal').insertAdjacentHTML('afterend', `<div class='hidden check'><div>`)
      document.querySelector('.podcast-search').value = event.target.getAttribute('data-podcast')
      document.querySelector('.episode-search').value = ''
      if (document.querySelector('.podcast-search').value !== '') {
        let elem= document.querySelector('#podcast-form')
        Rails.fire(elem, 'submit');
        document.querySelector('.episode-search').value = event.target.getAttribute('data-episode')
        document.querySelector('#episode').value = event.target.getAttribute('data-episode')
        let element = document.querySelector('.hidden-form form')
        Rails.fire(element, 'submit');
      }
    })
  })
}

export { modal };
