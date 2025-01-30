function checkFolderChanges() {
  const FOLDER_ID = 'TU_ID_DE_CARPETA';
  
  const NOTIFICATION_EMAIL = 'tu@email.com';
  
  const scriptProperties = PropertiesService.getScriptProperties();
  let lastCheckTime = scriptProperties.getProperty('lastCheckTime');
  const currentTime = new Date().getTime();
  
  if (!lastCheckTime) {
    lastCheckTime = currentTime;
    scriptProperties.setProperty('lastCheckTime', lastCheckTime);
    return;
  }
  
  const lastCheckDate = new Date(parseInt(lastCheckTime));
  
  const folder = DriveApp.getFolderById(FOLDER_ID);
  const modifiedFiles = [];
  
  function searchInFolder(folder) {
    const files = folder.getFiles();
    while (files.hasNext()) {
      const file = files.next();
      if (file.getLastUpdated() > lastCheckDate) {
        const revision = Drive.Revisions.list(file.getId());
        const lastEditor = revision.items && revision.items.length > 0 ? 
          revision.items[revision.items.length - 1].lastModifyingUser.displayName : 
          'Usuario desconocido';
          
        modifiedFiles.push({
          name: file.getName(),
          url: file.getUrl(),
          lastModified: file.getLastUpdated(),
          modifiedBy: lastEditor
        });
      }
    }
    
    const subFolders = folder.getFolders();
    while (subFolders.hasNext()) {
      searchInFolder(subFolders.next());
    }
  }
  
  searchInFolder(folder);
  
  let emailSubject, emailBody;
  
  if (modifiedFiles.length > 0) {
    emailSubject = 'Cambios detectados en carpeta de Drive';
    emailBody = 'Se han detectado los siguientes cambios en la carpeta monitoreada:\n\n';
    
    modifiedFiles.forEach(file => {
      emailBody += `Archivo: ${file.name}\n`;
      emailBody += `URL: ${file.url}\n`;
      emailBody += `Última modificación: ${file.lastModified}\n`;
      emailBody += `Modificado por: ${file.modifiedBy}\n\n`;
    });
  } else {
    emailSubject = 'No hay cambios en la carpeta de Drive';
    emailBody = 'No se han detectado cambios en la carpeta monitoreada desde la última revisión.\n';
    emailBody += `Última revisión: ${lastCheckDate.toLocaleString()}`;
  }
  
  MailApp.sendEmail({
    to: NOTIFICATION_EMAIL,
    subject: emailSubject,
    body: emailBody
  });
  
  scriptProperties.setProperty('lastCheckTime', currentTime.toString());
}

function createTimeTrigger() {
  ScriptApp.newTrigger('checkFolderChanges')
    .timeBased()
    .everyHours(1)
    .create();
}