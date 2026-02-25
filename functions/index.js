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

/**
 * createStripeCheckoutSession - Web-optimized flow that redirects to Stripe Checkout.
 * This avoids the need for a CardElement/CardField in the Flutter Web UI.
 */
exports.createStripeCheckoutSession = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be logged in.");
    }

    const { tierId, email, successUrl, cancelUrl } = data;
    let priceId;

    // Mapping tiers to PRICE IDs (User should ideally define these in Stripe Dashboard)
    // For now we map to names, but in production these would be 'price_H123...'
    // If the user hasn't created prices, this will look for prices with these nicknames
    // or we can use line_items with price_data.

    let amount;
    switch (tierId) {
        case "pro_monthly": amount = 499; break;
        case "pro_annual": amount = 3999; break;
        case "school": amount = 9900; break;
        default: amount = 499;
    }

    try {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ["card"],
            line_items: [
                {
                    price_data: {
                        currency: "usd",
                        product_data: {
                            name: `Phonics Kids Pro - ${tierId}`,
                        },
                        unit_amount: amount,
                    },
                    quantity: 1,
                },
            ],
            mode: "payment",
            success_url: successUrl || "http://localhost:8081/#/payment-success",
            cancel_url: cancelUrl || "http://localhost:8081/#/payment-cancel",
            customer_email: email,
            client_reference_id: context.auth.uid,
            metadata: {
                userId: context.auth.uid,
                tierId: tierId,
            },
        });

        return {
            url: session.url,
        };
    } catch (error) {
        console.error("Stripe Checkout Error:", error);
        throw new functions.https.HttpsError("internal", error.message);
    }
});

/**
 * stripeWebhook - Listens for successful Stripe Checkout events
 * to unlock premium status for the user in Firestore.
 */
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
    const sig = req.headers["stripe-signature"];
    // In production, this should be set via: 
    // firebase functions:config:set stripe.webhook_secret="whsec_..."
    const endpointSecret = functions.config().stripe.webhook_secret;

    let event;

    try {
        if (!endpointSecret) {
            console.warn("Webhook secret not set. Verifying event loosely.");
            // Warning: If you deploy this to production, explicitly use body parsing middleware
            // to extract rawBody. Firebase Functions provides req.rawBody by default.
            event = req.body;
        } else {
            event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
        }
    } catch (err) {
        console.error("Webhook Error:", err.message);
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    // Handle the event
    if (event.type === "checkout.session.completed") {
        const session = event.data.object;

        // Retrieve the userId passed in metadata during session creation
        const userId = session.metadata.userId;

        if (userId) {
            try {
                await admin.firestore().collection("users").doc(userId).set({
                    hasActiveSubscription: true,
                }, { merge: true });
                console.log(`Successfully unlocked subscription for user: ${userId}`);
            } catch (error) {
                console.error(`Error updating user ${userId} in Firestore:`, error);
                // Depending on requirements, you might want to return 500 here to force a Stripe retry
                return res.status(500).send("Firestore Update Error");
            }
        } else {
            console.warn("Checkout session completed, but no userId found in metadata!");
        }
    } else {
        console.log(`Unhandled Stripe event type: ${event.type}`);
    }

    // Return a 200 response to acknowledge receipt of the event
    res.status(200).send("OK");
});
