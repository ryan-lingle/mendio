function star() {
  if (document.querySelector('.star')) {
    document.querySelectorAll('.star').forEach((element) => {
        element.addEventListener('click', (event) => {
          event.target.classList.toggle('yellow');
      })
    });
  }
}

export { star };
