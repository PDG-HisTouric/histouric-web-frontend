let tokenClient;
let accessToken = null;
let pickerInited = false;
let gisInited = false;

/**
* Callback after api.js is loaded.
*/
function gapiLoaded() {
  gapi.load('client:picker', initializePicker);
}

/**
* Callback after the API client is loaded. Loads the
* discovery doc to initialize the API.
*/
async function initializePicker() {
  await gapi.client.load('https://www.googleapis.com/discovery/v1/apis/drive/v3/rest');
  pickerInited = true;
  maybeEnableButtons();
}

/**
* Callback after Google Identity Services are loaded.
*/
function gisLoaded(scopes, clientId) {
  tokenClient = google.accounts.oauth2.initTokenClient({
    client_id: clientId,
    scope: scopes,
    callback: '', // defined later
  });
  gisInited = true;
  maybeEnableButtons();
}

/**
* Enables user interaction after all libraries are loaded.
*/
function maybeEnableButtons() {
  //  if (pickerInited && gisInited) {
  //    document.getElementById('authorize_button').style.visibility = 'visible';
  //  }
}

/**
*  Sign in the user upon button click.
*/
function handleAuthClick(apiKey, appId) {
  tokenClient.callback = async (response) => {
    if (response.error !== undefined) {
      throw (response);
    }
    accessToken = response.access_token;
    await createPicker(apiKey, appId);
  };

  if (accessToken === null) {
    // Prompt the user to select a Google Account and ask for consent to share their data
    // when establishing a new session.
    tokenClient.requestAccessToken({ prompt: 'consent' });
  } else {
    // Skip display of account chooser and consent dialog for an existing session.
    tokenClient.requestAccessToken({ prompt: '' });
  }
}

/**
*  Sign out the user upon button click.
*/
function handleSignoutClick() {
  if (accessToken) {
    accessToken = null;
    google.accounts.oauth2.revoke(accessToken);
  }
}

/**
*  Create and render a Picker object for searching images.
*/
function createPicker(apiKey, appId) {
  const view = new google.picker.View(google.picker.ViewId.DOCS);
  view.setMimeTypes('image/png,image/jpeg,image/jpg');
  const picker = new google.picker.PickerBuilder()
    .enableFeature(google.picker.Feature.NAV_HIDDEN)
    .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
    .setDeveloperKey(apiKey)
    .setAppId(appId)
    .setOAuthToken(accessToken)
    .addView(view)
    .addView(new google.picker.DocsUploadView())
    .setCallback(pickerCallback)
    .build();
  picker.setVisible(true);
}

/**
* Displays the file details of the user's selection.
* @param {object} data - Containers the user selection from the picker
*/
async function pickerCallback(data) {
  if (data.action === google.picker.Action.PICKED) {
    let text = `Picker response: \n${JSON.stringify(data, null, 2)}\n`;
    const document = data[google.picker.Response.DOCUMENTS][0];
    const fileId = document[google.picker.Document.ID];
    console.log(fileId);
    const res = await gapi.client.drive.files.get({
      'fileId': fileId,
      'fields': '*',
    });
    text += `Drive API response for first document: \n${JSON.stringify(res.result, null, 2)}\n`;
  }
}
