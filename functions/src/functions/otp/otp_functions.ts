import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

const db = admin.firestore();

interface OtpData {
    phone: string;
    otp: string;
    expiredAt: number;
    createdAt: number;
}

// ===============================
// SEND OTP
// ===============================
export const sendOtp = functions.https.onRequest({
    region: "asia-southeast2"
}, async (req, res) => {
    try {
        const phone: string = req.body.phone;

        if (!phone) {
            res.status(400).json({
                success: false,
                message: "Phone number is required",
            });
            return;
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        const expiredAt = Date.now() + 5 * 60 * 1000;

        await db.collection("otp_codes").doc(phone).set({
            phone,
            otp,
            expiredAt,
            createdAt: Date.now(),
        });

        await axios.post(
            "https://api.fonnte.com/send",
            {
                target: phone,
                message: `🔐 *Verifikasi Akun Sewiee*

Halo 👋

⏳ Kode ini berlaku selama *5 menit*.

Gunakan kode OTP berikut untuk melanjutkan proses verifikasi akun Anda:

\`\`\`
${otp}
\`\`\`

⚠️ Demi keamanan, jangan bagikan kode ini kepada siapa pun.

Terima kasih telah menggunakan *Sewiee* 💙`,
            },
            {
                headers: {
                    Authorization: "47LGNXentzTZ3vJjvJNh",
                },
            }
        );

        res.status(200).json({
            success: true,
            message: "OTP sent successfully",
        });

        return;
    } catch (e: any) {
        console.error(e);

        res.status(500).json({
            success: false,
            message: e.message || String(e),
        });

        return;
    }
});

// ===============================
// VERIFY OTP
// ===============================
export const verifyOtp = functions.https.onRequest({
    region: "asia-southeast2"
}, async (req, res) => {
    try {
        const phone: string = req.body.phone;
        const otp: string = req.body.otp;

        if (!phone || !otp) {
            res.status(400).json({
                success: false,
                message: "Phone and OTP are required",
            });
            return;
        }

        const docRef = db.collection("otp_codes").doc(phone);
        const snapshot = await docRef.get();

        if (!snapshot.exists) {
            res.status(404).json({
                success: false,
                message: "OTP not found",
            });
            return;
        }

        const data = snapshot.data() as OtpData;

        // Check expired
        if (Date.now() > data.expiredAt) {
            res.status(400).json({
                success: false,
                message: "OTP expired",
            });
            return;
        }

        // Check OTP
        if (data.otp !== otp) {
            res.status(400).json({
                success: false,
                message: "Invalid OTP",
            });
            return;
        }

        // Delete OTP after success
        await docRef.delete();

        res.status(200).json({
            success: true,
            message: "OTP verified successfully",
        });
        return;
    } catch (e: any) {
        console.error(e);

        res.status(500).json({
            success: false,
            message: e.message || String(e),
        });
        return;
    }
});