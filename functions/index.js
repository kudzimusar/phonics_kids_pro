const functions = require("firebase-functions");
const admin = require("firebase-admin");
const stripe = require("stripe")(functions.config().stripe.secret_key);

admin.initializeApp();

/**
 * createStripePaymentIntent - Called by Flutter app to get a client secret
 * for a specific subscrpition tier.
 */
exports.createStripePaymentIntent = functions.https.onCall(async (data, context) => {
    // Check auth
    if (!context.auth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "User must be logged in to start payment."
        );
    }

    const { tierId, email } = data;
    let amount;

    // Pricing logic (Mock values matching the UI)
    switch (tierId) {
        case "pro_monthly":
            amount = 499; // $4.99
            break;
        case "pro_annual":
            amount = 3999; // $39.99
            break;
        case "school":
            amount = 9900; // $99.00
            break;
        default:
            amount = 499;
    }

    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: amount,
            currency: "usd",
            receipt_email: email,
            metadata: {
                userId: context.auth.uid,
                tierId: tierId,
            },
            automatic_payment_methods: {
                enabled: true,
            },
        });

        return {
            clientSecret: paymentIntent.client_secret,
        };
    } catch (error) {
        console.error("Stripe Error:", error);
        throw new functions.https.HttpsError("internal", error.message);
    }
});
