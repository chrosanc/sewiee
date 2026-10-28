import * as admin from "firebase-admin";
import * as dotenv from "dotenv";

admin.initializeApp();
dotenv.config();

export {
    sendOtp,
    verifyOtp
} from "./functions/otp/otp_functions";
export {
    createMidtransTransaction,
} from "./functions/payment/create_midtrans_transaction";

export {
    midtransWebhook,
    penaltyWebhook
} from "./functions/payment/midtrans_webhook";

export {
    getPaymentMethods,
} from "./functions/payment/get_payment_method";

export {
    generateOrderNumber,
} from "./functions/order/generate_order_number";

export {
    onProductCreated,
    onProductDeleted
} from "./functions/product/index";

export {
    onOrderCreated,
    onOrderStatusUpdated
} from "./functions/order/index";