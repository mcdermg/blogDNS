async function fetchAndReplace(request) {

  let modifiedHeaders = new Headers()

  modifiedHeaders.set('Content-Type', 'text/html')
  modifiedHeaders.append('Pragma', 'no-cache')


  //Allow users from trusted into site
  if (white_list.indexOf(request.headers.get("cf-connecting-ip")) > -1)
  {
    //Fire all other requests directly to our WebServers
    return fetch(request)
  }
  else //Return maint page if you're not calling from a trusted IP
  {
    // Return modified response.
    return new Response(maintenancePage, {
      status: 503,
      headers: modifiedHeaders
    })
  }
}

let maintenancePage = `
<!doctype html>
<title>Site Maintenance</title>
<div class="content">
    <h1>We&rsquo;ll be back soon!</h1>
    <p>We&rsquo;re very sorry for the inconvenience but we&rsquo;re performing maintenance. Please check back soon...</p>
    <p>&mdash; Awesome Team</p>
</div>
`
