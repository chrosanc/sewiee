import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const generateOrderNumber =
    functions.https.onCall({
        region: 'asia-southeast2'
        },
        async (data, context) => {

            const db = admin.firestore();

            const counterRef =
                db.collection("counters")
                    .doc("orders");

            const result =
                await db.runTransaction(
                    async (
                        transaction: FirebaseFirestore.Transaction
                    ) => {

                        const counterDoc =
                            await transaction.get(counterRef);

                        let lastNumber = 0;

                        if (counterDoc.exists) {
                            lastNumber =
                                counterDoc.data()?.last_number || 0;
                        }

                        const nextNumber =
                            lastNumber + 1;

                        transaction.set(
                            counterRef,
                            {
                                last_number: nextNumber,
                            },
                            { merge: true }
                        );

                        const now = new Date();

                        const year =
                            now.getFullYear();

                        const month = String(
                            now.getMonth() + 1
                        ).padStart(2, "0");

                        const day = String(
                            now.getDate()
                        ).padStart(2, "0");

                        const formattedNumber =
                            String(nextNumber)
                                .padStart(4, "0");

                        const orderNumber =
                            `INV-SW-${year}${month}${day}-${formattedNumber}`;

                        return orderNumber;
                    }
                );

            return {
                order_number: result,
            };
        }
    );