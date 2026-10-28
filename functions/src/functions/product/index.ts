import { onDocumentCreated, onDocumentDeleted } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

const db = admin.firestore();
const REGION = "asia-southeast2"; // Jakarta

export const onProductCreated = onDocumentCreated(
    { document: "products/{productId}", region: REGION },
    async (event) => {
        const product = event.data?.data();
        const ownerId = product?.owner_id;
        if (!ownerId) return;

        await db.doc(`users/${ownerId}`).update({
            totalProducts: admin.firestore.FieldValue.increment(1),
        });
    }
);

export const onProductDeleted = onDocumentDeleted(
    { document: "products/{productId}", region: REGION },
    async (event) => {
        const product = event.data?.data();
        const ownerId = product?.owner_id;
        if (!ownerId) return;

        await db.doc(`users/${ownerId}`).update({
            totalProducts: admin.firestore.FieldValue.increment(-1),
        });
    }
);