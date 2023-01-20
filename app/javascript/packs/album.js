const album = () => {
  const album_name_request = document.getElementById('album_name')

  if (album_name_request) {
    fetch(
      'https://en.wikipedia.org/w/api.php?action=query&origin=*&prop=extracts&list=search&srsearch=' +
        album_name_request.innerText +
        '&format=json&dataType=jsonp',
      {
        method: 'get',
      }
    )
      .then(function (resp) {
        return resp.json()
      })
      .then(function (data) {
        processId(data)
      })

    let pageId

    function processId(data) {
      pageId = data.query.search[0].pageid
      fetch(
        'https://en.wikipedia.org/w/api.php?action=query&origin=*&prop=extracts&redirects=1&exsentences=3&exintro=true&explaintext=true&pageids=' +
          pageId +
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

      const processResult = (data) => {
        const pages = data.query.pages
        const pages_inner = Object.keys(pages)[0]
        const text = pages[pages_inner].extract
        const album_trivia = document.getElementById('album_trivia')
        const longText = '....... \n\n...see wikipedia for more details.'
        if (text.length >= 600) {
          const trimmedText = text.replace(/^(.{520}[^\s]*).*/, '$1')
          album_trivia.innerText = trimmedText + longText
        } else album_trivia.innerText = text
      }
    }
  }
}

export { album }
