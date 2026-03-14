const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendAppointmentNotification = onDocumentCreated(
  {
    document: "appointments/{appointmentId}",
    region: "asia-south1",
  },
  async (event) => {

    const appointment = event.data.data();

    const doctorId = appointment.doctorId;
    const time = appointment.time;

    const doctorDoc = await admin.firestore()
      .collection("users")
      .doc(doctorId)
      .get();

    if (!doctorDoc.exists) {
      console.log("Doctor not found");
      return;
    }

    const doctorData = doctorDoc.data();
    const token = doctorData.fcmToken;

    if (!token) {
      console.log("No FCM token for doctor");
      return;
    }

    const message = {
      notification: {
        title: "New Appointment",
        body: `You have a new appointment at ${time}`,
      },
      token: token,
    };

    await admin.messaging().send(message);

    console.log("Notification sent successfully");
  }
);
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");

exports.sendApprovalNotification = onDocumentUpdated(
{
  document: "appointments/{appointmentId}",
  region: "asia-south1"
},
async (event) => {

  const before = event.data.before.data();
  const after = event.data.after.data();

  if (before.status === after.status) return;

  if (after.status !== "approved") return;

  const patientId = after.patientId;

  const patientDoc = await admin.firestore()
      .collection("users")
      .doc(patientId)
      .get();

  const patientToken = patientDoc.data().fcmToken;

  if (!patientToken) return;

  const message = {
    notification: {
      title: "Appointment Approved",
      body: "Doctor approved your appointment"
    },
    token: patientToken
  };

  await admin.messaging().send(message);

  console.log("Patient notified");

});