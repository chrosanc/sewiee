import { onDocumentCreated, onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

const db = admin.firestore();
const REGION = "asia-southeast2"; // Jakarta
const EXCLUDED_STATUS = "waiting_payment";

export const onOrderCreated = onDocumentCreated(
    { document: "orders/{orderId}", region: REGION },
    async (event) => {
        const order = event.data?.data();
        const ownerId = order?.owner_id;
        const status = order?.status;

        if (!ownerId || status === EXCLUDED_STATUS) return;

        await db.doc(`users/${ownerId}`).update({
            totalTransactions: admin.firestore.FieldValue.increment(1),
        });
    }
);

export const onOrderStatusUpdated = onDocumentUpdated(
    { document: "orders/{orderId}", region: REGION },
    async (event) => {
        const before = event.data?.before.data();
        const after = event.data?.after.data();

        const ownerId = after?.owner_id;
        const prevStatus = before?.status;
        const newStatus = after?.status;

        if (!ownerId || prevStatus === newStatus) return;

        if (prevStatus === EXCLUDED_STATUS && newStatus !== EXCLUDED_STATUS) {
            await db.doc(`users/${ownerId}`).update({
                totalTransactions: admin.firestore.FieldValue.increment(1),
            });
        } else if (prevStatus !== EXCLUDED_STATUS && newStatus === EXCLUDED_STATUS) {
            await db.doc(`users/${ownerId}`).update({
                totalTransactions: admin.firestore.FieldValue.increment(-1),
            });
        }
    }
);