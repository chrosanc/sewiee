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