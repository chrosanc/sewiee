import * as admin from "firebase-admin";

export const sendPushNotification = async (
    token: string | undefined,
    title: string,
    body: string,
    data?: { [key: string]: string }
) => {
    if (!token) {
        console.log("No FCM token provided, skipping notification.");
        return;
    }

    try {
        const message: admin.messaging.Message = {
            token: token,
            notification: {
                title: title,
                body: body,
            },
            data: data,
        };

        const response = await admin.messaging().send(message);
        console.log("Successfully sent message:", response);
    } catch (error) {
        console.error("Error sending message:", error);
    }
};
