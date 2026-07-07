import { onDocumentCreated, onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import { sendPushNotification } from "../../services/notification_service";

const db = admin.firestore();
const REGION = "asia-southeast2"; // Jakarta
const EXCLUDED_STATUS = "waiting_payment";

export const onOrderCreated = onDocumentCreated(
    { document: "orders/{orderId}", region: REGION },
    async (event) => {
        const order = event.data?.data();
        const ownerId = order?.owner_id;
        const renterId = order?.renter_id;
        const status = order?.status;
        const orderNumber = order?.order_number;
        const productName = order?.product_snapshot?.name || "Produk";

        if (!ownerId || !renterId) return;

        // Get tokens
        const [ownerDoc, renterDoc] = await Promise.all([
            db.doc(`users/${ownerId}`).get(),
            db.doc(`users/${renterId}`).get()
        ]);

        const ownerToken = ownerDoc.data()?.fcm_token;
        const renterToken = renterDoc.data()?.fcm_token;

        // Send notifications
        await Promise.all([
            sendPushNotification(
                ownerToken,
                "Pesanan Baru!",
                `Anda punya pesanan baru untuk ${productName}`,
                { orderId: event.params.orderId }
            ),
            sendPushNotification(
                renterToken,
                "Pesanan Dibuat!",
                `Pesanan ${orderNumber} berhasil dibuat`,
                { orderId: event.params.orderId }
            )
        ]);

        if (status === EXCLUDED_STATUS) return;

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
        const renterId = after?.renter_id;
        const prevStatus = before?.status;
        const newStatus = after?.status;
        const orderNumber = after?.order_number;

        if (!ownerId || !renterId || prevStatus === newStatus) return;

        // Get tokens
        const [ownerDoc, renterDoc] = await Promise.all([
            db.doc(`users/${ownerId}`).get(),
            db.doc(`users/${renterId}`).get()
        ]);

        const ownerToken = ownerDoc.data()?.fcm_token;
        const renterToken = renterDoc.data()?.fcm_token;

        let ownerTitle = "";
        let ownerBody = "";
        let renterTitle = "";
        let renterBody = "";

        switch (newStatus) {
            case "paid":
                ownerTitle = "Pembayaran Diterima!";
                ownerBody = `Pesanan ${orderNumber} telah dibayar`;
                renterTitle = "Pembayaran Berhasil!";
                renterBody = `Pesanan ${orderNumber} menunggu konfirmasi`;
                break;
            case "waiting_confirmation":
                ownerTitle = "Pesanan Perlu Konfirmasi!";
                ownerBody = `Silakan konfirmasikan pesanan ${orderNumber}`;
                break;
            case "processing":
                renterTitle = "Pesanan Diproses!";
                renterBody = `Pesanan ${orderNumber} sedang diproses`;
                break;
            case "waiting_pickup":
                renterTitle = "Siap Diambil!";
                renterBody = `Pesanan ${orderNumber} siap diambil`;
                break;
            case "on_delivery":
                renterTitle = "Pesanan Dikirim!";
                renterBody = `Pesanan ${orderNumber} sedang dalam perjalanan`;
                break;
            case "delivered":
                renterTitle = "Pesanan Diterima!";
                renterBody = `Pesanan ${orderNumber} telah diterima`;
                break;
            case "on_rent":
                ownerTitle = "Sewa Dimulai";
                ownerBody = `Masa sewa pesanan ${orderNumber} telah dimulai`;
                renterTitle = "Sewa Dimulai!";
                renterBody = `Masa sewa pesanan ${orderNumber} telah dimulai`;
                break;
            case "return_pending":
                ownerTitle = "Permintaan Pengembalian!";
                ownerBody = `Penyewa meminta pengembalian produk untuk ${orderNumber}`;
                break;
            case "returned":
                ownerTitle = "Produk Dikembalikan!";
                ownerBody = `Produk untuk pesanan ${orderNumber} telah dikembalikan`;
                break;
            case "completed":
                ownerTitle = "Pesanan Selesai!";
                ownerBody = `Pesanan ${orderNumber} selesai`;
                renterTitle = "Pesanan Selesai!";
                renterBody = `Pesanan ${orderNumber} selesai`;
                break;
            case "cancelled":
                ownerTitle = "Pesanan Dibatalkan!";
                ownerBody = `Pesanan ${orderNumber} dibatalkan`;
                renterTitle = "Pesanan Dibatalkan!";
                renterBody = `Pesanan ${orderNumber} dibatalkan`;
                break;
            case "payment_expired":
                renterTitle = "Pembayaran Kadaluarsa!";
                renterBody = `Pembayaran untuk pesanan ${orderNumber} telah kadaluarsa`;
                break;
            case "payment_failed":
                renterTitle = "Pembayaran Gagal!";
                renterBody = `Pembayaran untuk pesanan ${orderNumber} gagal`;
                break;
        }

        const promises = [];
        if (ownerTitle) {
            promises.push(sendPushNotification(ownerToken, ownerTitle, ownerBody, { orderId: event.params.orderId }));
        }
        if (renterTitle) {
            promises.push(sendPushNotification(renterToken, renterTitle, renterBody, { orderId: event.params.orderId }));
        }
        await Promise.all(promises);

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