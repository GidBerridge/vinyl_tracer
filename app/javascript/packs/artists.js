const artist = () => {
  const artist_name = document.getElementById('artist_name')

  if (artist_name) {
    fetch(
      'https://en.wikipedia.org/w/api.php?action=query&origin=*&prop=extracts&redirects=1&exsentences=6&exintro=true&explaintext=true&titles=' +
        artist_name.innerText +
        '&format=json&dataType=jsonp',
      {
        method: 'get',
      }
    )
      .then(function (resp) {
        return resp.json()
      })
      .then(function (data) {
        processResult(data)
      })

    function processResult(data) {
      const pages = data.query.pages
      const pages_inner = Object.keys(pages)[0]
      const text = pages[pages_inner].extract
      const artist_trivia = document.getElementById('artist_trivia')
      artist_trivia.innerText = text
    }
  }
}

export { artist }
