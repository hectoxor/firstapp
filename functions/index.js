const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendAnnouncementNotification = functions.firestore
  .document('announcements/{announcementId}')
  .onCreate((snapshot, context) => {
    const announcement = snapshot.data();
    const payload = {
      notification: {
        title: 'New Announcement',
        body: announcement.title, // Assuming 'title' field exists
      },
      topic: 'announcements',
    };

    return admin.messaging().send(payload);
  });
