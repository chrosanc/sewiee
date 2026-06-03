import { onRequest } from "firebase-functions/v2/https";

export const getPaymentMethods = onRequest(async (req, res) => {
    try {
        res.status(200).json({
            success: true,
            data: [
                // =========================
                // BANK TRANSFER
                // =========================
                {
                    id: "bca_va",
                    name: "BCA Virtual Account",
                    type: "bank_transfer",
                    provider: "bca",
                    image:
                        "https://www.bca.co.id/-/media/Feature/Card/List-Card/Tentang-BCA/Brand-Assets/Logo-BCA/Logo-BCA_Biru.png",
                    active: true,
                },
                {
                    id: "bni_va",
                    name: "BNI Virtual Account",
                    type: "bank_transfer",
                    provider: "bni",
                    image:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Bank_Negara_Indonesia_logo_%282004%29.svg/250px-Bank_Negara_Indonesia_logo_%282004%29.svg.png",
                    active: true,
                },
                {
                    id: "bri_va",
                    name: "BRI Virtual Account",
                    type: "bank_transfer",
                    provider: "bri",
                    image:
                        "https://images.seeklogo.com/logo-png/42/1/bri-bank-logo-png_seeklogo-429137.png",
                    active: true,
                },
                {
                    id: "mandiri_va",
                    name: "Mandiri Bill Payment",
                    type: "bank_transfer",
                    provider: "mandiri",
                    image:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Bank_Mandiri_logo_2016.svg/250px-Bank_Mandiri_logo_2016.svg.png",
                    active: true,
                },

                // =========================
                // E-WALLET
                // =========================
                {
                    id: "gopay",
                    name: "GoPay",
                    type: "ewallet",
                    provider: "gopay",
                    image:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Gopay_logo.svg/120px-Gopay_logo.svg.png",
                    active: true,
                },
                // {
                //     id: "shopeepay",
                //     name: "ShopeePay",
                //     type: "ewallet",
                //     provider: "shopeepay",
                //     image:
                //         "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Shopee.svg/960px-Shopee.svg.png",
                //     active: true,
                // },

                // =========================
                // QRIS
                // =========================
                {
                    id: "qris",
                    name: "QRIS",
                    type: "qris",
                    provider: "qris",
                    image:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Logo_QRIS.svg/250px-Logo_QRIS.svg.png",
                    active: true,
                },
            ],
        });
    } catch (e: any) {
        console.error(e);

        res.status(500).json({
            success: false,
            message: e.message,
        });
    }
});