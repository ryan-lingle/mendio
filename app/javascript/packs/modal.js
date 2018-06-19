function modal() {
  $('#myModal').on('shown.bs.modal', function () {
    $('#myInput').focus()
  })
}

export { modal };
