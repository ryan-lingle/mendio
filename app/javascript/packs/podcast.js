function executePodcastSearch() {
  const podcastInput = document.querySelector('.podcast-search');
  const podcastResults = document.querySelector('.podcast-results')
  if (podcastInput) {
    focuser(podcastInput);
    clicker(podcastResults);
  }


  console.log(document.querySelector('#podcast-section form'))


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
      const elem= document.querySelector('#podcast-form')
      Rails.fire(elem, 'submit');

    })
  }

  const podcastKey = function (event) {
      if (event.key == 'Enter') {
        document.removeEventListener('keyup', podcastKey)
      } else {
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
      };
  }
}

export { executePodcastSearch };
