import axios from "axios";

import {
    MIDTRANS_URL,
} from "../config/midtrans";

export async function createMidtransCharge(
    paymentBody: any,
    serverKey: string,
){
    const response = await axios.post(
        MIDTRANS_URL,
        paymentBody,
        {
            headers: {
                "Content-Type" : "application/json",
                "Authorization": "Basic " + Buffer.from(serverKey + ":").toString("base64")
            },
        }
    );
    return response.data;
}