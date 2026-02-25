const admin = require("firebase-admin");

admin.initializeApp({
    projectId: "phonics-kids-pro"
});

async function run() {
    try {
        const doc = await admin.firestore().collection("users").doc("btMM1yInrfeIYDEIR4qVOZt2Hi82").get();
        if (doc.exists) {
            console.log("Document DATA:", doc.data());
        } else {
            console.log("Document DOES NOT EXIST for that UID.");
        }
    } catch (err) {
        console.error("Error reading doc:", err);
    }
}
run();
