import {onRequest}
    from "firebase-functions/v2/https";

import * as admin
    from "firebase-admin";
import {defineSecret} from "firebase-functions/params";


const midtransServerKey =
    defineSecret("MIDTRANS_SERVER_KEY");

const db =
    admin.firestore();

export const
    midtransWebhook =
        onRequest(
            {
                secrets: [midtransServerKey],
                region: "asia-southeast2",
            },
            async (req, res) => {
                try {
                    const body =
                        req.body;
                    const midtransOrderId = body.order_id;
                    const orderId = midtransOrderId.split("-").slice(0, 5).join("-");
                    const transactionStatus =
                        body.transaction_status;
                    let orderStatus =
                        "pending";

                    // =========================
                    // STATUS MAPPING
                    // =========================
                    if (
                        transactionStatus ==
                        "settlement"
                    ) {
                        orderStatus =
                            "waiting_confirmation";
                    } else if (
                        transactionStatus ==
                        "expire"
                    ) {

                        orderStatus =
                            "expired";
                    } else if (
                        transactionStatus ==
                        "cancel"
                    ) {

                        orderStatus =
                            "cancelled";
                    } else if (
                        transactionStatus ==
                        "deny"
                    ) {

                        orderStatus =
                            "failed";
                    }

                    // =========================
                    // UPDATE FIRESTORE
                    // =========================

                    await db
                        .collection("order")
                        .doc(orderId)
                        .update({

                            'status':
                            orderStatus,

                            'payment.paid_at':
                            transactionStatus == 'settlement' ? admin.firestore.FieldValue.serverTimestamp()
                                : null,

                            'payment.payment_status':
                            transactionStatus,

                            "payment.last_webhook": {
                                fraud_status: body.fraud_status ?? null,
                                payment_type: body.payment_type ?? null,
                                settlement_time: body.settlement_time ?? null,
                                received_at:
                                    admin.firestore.FieldValue.serverTimestamp(),
                            },

                            'updated_at':
                                admin.firestore
                                    .FieldValue
                                    .serverTimestamp(),
                        });
                    // =========================
                    // RESPONSE
                    // =========================
                    res.status(200).send({
                        success: true,
                    });
                    return;
                } catch (e: any) {
                    console.error(e);
                    res.status(500).send({
                        success: false,
                        message:
                        e.message,
                    });
                    return;
                }
            },
        );

export const penaltyWebhook = onRequest(
    {
        region: "asia-southeast2",
    },

    async (req, res) => {

        try {

            // =========================
            // BODY
            // =========================

            const body = req.body;

            console.log(
                "MIDTRANS WEBHOOK:",
                JSON.stringify(body)
            );

            const transactionStatus =
                body.transaction_status;

            const fraudStatus =
                body.fraud_status;

            const orderNumber =
                body.order_id || "";

            // =========================
            // VALIDATION
            // =========================

            if (!orderNumber) {

                res.status(400).json({
                    success: false,
                    message: "order_id kosong",
                });

                return;
            }

            // =========================
            // SEARCH ORDER
            // =========================

            const snapshot = await db
                .collection("order")
                .where(
                    "order_number",
                    "==",
                    orderNumber,
                )
                .limit(1)
                .get();

            if (snapshot.empty) {

                res.status(404).json({
                    success: false,
                    message: "Order tidak ditemukan",
                });

                return;
            }

            const orderDoc =
                snapshot.docs[0];

            const orderData =
                orderDoc.data();

            // =========================
            // PREVENT DUPLICATE UPDATE
            // =========================

            if (
                orderData.rental?.penalty_paid ==
                true
            ) {

                res.status(200).json({
                    success: true,
                    message:
                        "Penalty already paid",
                });

                return;
            }

            // =========================
            // PAYMENT SUCCESS
            // =========================

            const isSuccess =
                transactionStatus === "settlement" ||
                transactionStatus === "capture";

            const isFraudAccepted =
                fraudStatus === "accept" ||
                fraudStatus == null;

            if (
                isSuccess &&
                isFraudAccepted
            ) {

                await orderDoc.ref.update({

                    // =========================
                    // ORDER STATUS
                    // =========================

                    status: "completed",

                    // =========================
                    // DAMAGE PAYMENT
                    // =========================

                    "rental.penalty_paid":
                        true,

                    "rental.penalty_paid_at":
                        admin.firestore.FieldValue.serverTimestamp(),

                    // =========================
                    // MIDTRANS PAYMENT
                    // =========================

                    "payment.penalty_transaction": {

                        transaction_id:
                        body.transaction_id,

                        order_id:
                        body.order_id,

                        payment_type:
                        body.payment_type,

                        transaction_status:
                        body.transaction_status,

                        fraud_status:
                            body.fraud_status ?? null,

                        gross_amount:
                        body.gross_amount,

                        paid_at:
                            admin.firestore.FieldValue.serverTimestamp(),
                    },

                    // =========================
                    // TIMESTAMP
                    // =========================

                    updated_at:
                        admin.firestore.FieldValue.serverTimestamp(),
                });

                console.log(
                    `Penalty success: ${orderNumber}`
                );
            }

                // =========================
                // PAYMENT FAILED
            // =========================

            else if (
                transactionStatus === "expire" ||
                transactionStatus === "cancel" ||
                transactionStatus === "deny"
            ) {

                await orderDoc.ref.update({

                    "payment.penalty_transaction": {

                        transaction_id:
                        body.transaction_id,

                        order_id:
                        body.order_id,

                        payment_type:
                        body.payment_type,

                        transaction_status:
                        body.transaction_status,

                        failed_at:
                            admin.firestore.FieldValue.serverTimestamp(),
                    },

                    updated_at:
                        admin.firestore.FieldValue.serverTimestamp(),
                });

                console.log(
                    `Penalty failed: ${orderNumber}`
                );
            }

            res.status(200).json({
                success: true,
            });

        } catch (e: any) {

            console.error(
                "PENALTY WEBHOOK ERROR:",
                e
            );

            res.status(500).json({
                success: false,
                message: e.message,
            });
        }

    },
);