function toggleFollow() {
  if (document.querySelector('.relationship')) {
    document.querySelectorAll('.relationship').forEach( (e) => {
      e.addEventListener('click', (event) => {
        if (event.target.innerText == 'FOLLOW') {
          event.target.innerText = 'UNFOLLOW';
        } else {
          event.target.innerText = 'FOLLOW';
        }
      })
    })
  }
}

export { toggleFollow }
