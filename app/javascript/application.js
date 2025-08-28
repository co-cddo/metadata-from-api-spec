// Entry point for the build script in your package.json
import SwaggerUI from 'swagger-ui'

  const apiSpec = document.querySelector("#api-spec");

  SwaggerUI({
    dom_id: '#api-spec',
    url: apiSpec.dataset.url
  })
