function cancelForm() {
  document.querySelector('.search-bar form').addEventListener('submit', (event) => {
    if (document.querySelector('#query').value == ''){
      event.preventDefault();
    }
  })
}

export { cancelForm }
