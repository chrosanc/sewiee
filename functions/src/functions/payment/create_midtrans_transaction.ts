import { onCall }
    from "firebase-functions/v2/https";

import * as admin
    from "firebase-admin";

import {
    createMidtransCharge,
} from "../../services/midtrans_service";

import {defineSecret} from  "firebase-functions/params";


const midtransServerKey =
    defineSecret("MIDTRANS_SERVER_KEY");

const db =
    admin.firestore();



export const
    createMidtransTransaction =
        onCall({
            secrets: [midtransServerKey],
            region: "asia-southeast2",
        },async (request) => {


            try {

                // type itemDetail = {
                //     id: string;
                //     price: number;
                //     quantity: number;
                //     name: string;
                //     merchantName: string;
                // };

                const {
                    orderId,
                    grossAmount,
                    paymentMethod,
                    customer,
                    // itemDetails,

                } = request.data;

                const serverKey = midtransServerKey.value();


                // =========================
                // PAYMENT BODY
                // =========================

                const midtransOrderId =
                    `${orderId}-${Date.now()}`


                let paymentBody: any = {

                    transaction_details: {

                        order_id:
                        midtransOrderId,

                        gross_amount:
                        grossAmount,
                    },

                    customer_details: {
                        first_name:
                        customer.name,
                        email:
                        customer.email,
                        phone:
                        customer.phone,
                        shipping_address: {
                            first_name: customer.shippingAddress.firstName,
                            address: customer.shippingAddress.address
                         }
                    },

                    // item_details: itemDetails.map((item: itemDetail) => ({
                    //     id: item.id,
                    //     price: item.price,
                    //     quantity: item.quantity,
                    //     name: item.name,
                    //     merchant_name: item.merchantName,
                    // })),
                };

                // =========================
                // BANK TRANSFER
                // =========================

                if (
                    paymentMethod.type ==
                    "bank_transfer"
                ) {

                    paymentBody.payment_type =
                        "bank_transfer";

                    paymentBody.bank_transfer = {

                        bank:
                        paymentMethod.provider,
                    };
                }

                    // =========================
                    // GOPAY
                // =========================

                else if (
                    paymentMethod.provider ==
                    "gopay"
                ) {

                    paymentBody.payment_type =
                        "gopay";
                }

                    // =========================
                    // QRIS
                // =========================

                else if (
                    paymentMethod.provider ==
                    "qris"
                ) {

                    paymentBody.payment_type =
                        "qris";
                }

                // =========================
                // CREATE CHARGE
                // =========================

                const result =
                    await createMidtransCharge(
                        paymentBody,
                        serverKey
                    );

                // =========================
                // SAVE ORDER
                // =========================


                await db.collection("order").doc(orderId).update({
                    "payment.payment_status": "pending",
                    "payment.transaction_id": result.transaction_id,
                    "payment.expired_at": result.expiry_time,
                    "payment.midtrans_order_id": midtransOrderId,
                });

                return {

                    success: true,

                    data: result,
                };

            } catch (e: any) {

                console.error(e);

                return {

                    success: false,

                    message:
                    e.message,
                };
            }
        });