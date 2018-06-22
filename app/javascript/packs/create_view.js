const seen = {};

function createView() {
  if (document.querySelector('.donation-card')) {
    const options = {
      root: null,
      rootMargin: '0px',
      threshold: 1.0,
    }

    function callback(entries, observer) {
      entries.forEach(entry => {

        if (entry.intersectionRatio == 1) {
          seen[entry.target.getAttribute('data')] += 1;
          if (seen[entry.target.getAttribute('data')] == 1) {
            fetch(`view/create/${entry.target.getAttribute('data')}`, {
              headers: { 'X-CSRF-Token': Rails.csrfToken() },
              credentials: 'same-origin',
            });
          }
        }
      });
    };

    const observer = new IntersectionObserver(callback, options);

    document.querySelectorAll('.donation-card').forEach((c) => {
      seen[c.getAttribute('data')] = 0;
      observer.observe(c);
    })
  }
}

export { createView }
