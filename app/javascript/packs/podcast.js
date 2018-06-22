function executePodcastSearch() {
  document.querySelector('.episode-section').classList.add('hidden')
  if (document.querySelector('.amount-input')) {
    document.querySelector('.amount-input').remove();
  }
  const podcastInput = document.querySelector('.podcast-search');
  const podcastResults = document.querySelector('.podcast-results')
  if (podcastInput) {
    podcastInput.value = '';
    focuser(podcastInput);
    clicker(podcastResults);
    killEnter();
  }

  function focuser(input) {
    input.addEventListener('focus', () => {
      document.addEventListener('keyup', podcastKey)
    })
  }


  function clicker(results) {
    podcastResults.addEventListener('click', (event) => {
      podcastInput.value = event.target.innerText;
      document.querySelector(".podcast-results").innerHTML = "";
      document.removeEventListener('keyup', podcastKey)
      let elem= document.querySelector('#podcast-form')
      Rails.fire(elem, 'submit');

    })
  }

  const podcastKey = function (event) {
    const query = podcastInput.value;
    fetch(`https://itunes.apple.com/search?term=${query}&media=podcast&entity=podcast&limit=10`)
      .then(response => response.json())
      .then((data) => {
        document.querySelector(".podcast-results").innerHTML = "";
        if (data.results) {
          data.results.reverse().forEach((podcast) => {
            document.querySelector('.podcast-results').insertAdjacentHTML("afterbegin", `<div class="podcast"><img src="${podcast.artworkUrl60}" alt="d"><li>${podcast.collectionName}</li></div>`);
          });
        };
      });
  }

  function killEnter() {
    document.querySelector('.podcast-section form').addEventListener('keypress', function(event) {
      if (event.keyCode == 13) {
          event.preventDefault();
      }
    });
  }
}


export { executePodcastSearch };
