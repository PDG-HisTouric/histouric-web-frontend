let tokenClient;
let accessToken = null;
let pickerInited = false;
let gisInited = false;
let selectedFilesInfo = [];
let isPickerOpen = false;
let isThereAnError = false;

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
}

/**
*  Sign in the user upon button click.
*/
function handleAuthClick(apiKey, appId) {
  tokenClient.callback = async (response) => {
    if (response.error !== undefined) {
      isThereAnError = true;
      throw (response);
    }
    accessToken = response.access_token;
    await createPicker(apiKey, appId);
    isPickerOpen = true;
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
function handleSignOutClick() {
  if (accessToken) {
    accessToken = null;
    google.accounts.oauth2.revoke(accessToken);
  }
}

/**
*  Create and render a Picker object for searching images.
*/
function createPicker(apiKey, appId) {
  const docsView = new google.picker.DocsView(google.picker.ViewId.DOCS);
  docsView.setMimeTypes('image/png,image/jpeg,image/jpg');
  docsView.setOwnedByMe(true);
  const picker = new google.picker.PickerBuilder()
    .enableFeature(google.picker.Feature.NAV_HIDDEN)
    .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
    .setDeveloperKey(apiKey)
    .setAppId(appId)
    .setOAuthToken(accessToken)
    .addView(docsView)
    .setCallback(pickerCallback)
    .build();
  picker.setVisible(true);
  isPickerOpen = true;
}

/**
* Displays the file details of the user's selection.
* @param {object} data - Containers the user selection from the picker
*/
async function pickerCallback(data) {
  if (data.action === google.picker.Action.PICKED) {
    let text = `Picker response: \n${JSON.stringify(data, null, 2)}\n`;
    const documents = data[google.picker.Response.DOCUMENTS];
    await shareDocumentsToReadonlyForEveryone(documents);
    await getInfoOfImages(documents);
    isPickerOpen = false;
  }
}

async function getInfoOfImages(documents) {
  selectedFilesInfo = [];
  for (let i = 0; i < documents.length; i++) {
    let imageInfo = [];
    const fileId = documents[i][google.picker.Document.ID];
    imageInfo.push(fileId);
    const res = await gapi.client.drive.files.get({
      'fileId': fileId,
      'fields': '*',
    });
    const width = res.result.imageMediaMetadata.width;
    const height = res.result.imageMediaMetadata.height;
    imageInfo.push(width);
    imageInfo.push(height);
    selectedFilesInfo.push(imageInfo);
  }
}

async function shareDocumentsToReadonlyForEveryone(documents) {
  for (let i = 0; i < documents.length; i++) {
    const fileId = documents[i][google.picker.Document.ID];
    await createPermissionToEverybodyCanRead(fileId);
  }
}

async function createPermissionToEverybodyCanRead(fileId) {
  await gapi.client.drive.permissions.create({
    'fileId': fileId,
    'resource': {
      'type': 'anyone',
      'role': 'reader',
    },
  });

}

function getSelectedFilesInfo() {
  return selectedFilesInfo;
}

function getIsPickerOpen() {
  return isPickerOpen;
}

function getIsThereAnError() {
  return isThereAnError;
}