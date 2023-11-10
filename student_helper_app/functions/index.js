/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions

//const functions = require("firebase-functions");
//const admin = require("firebase-admin");
//admin.initializeApp();
//
//exports.getLastMessage = functions
//    .https.onRequest(async (request, response) => {
//      const {senderUid, receiverUid} = request.query;
//
//      if (!senderUid || !receiverUid) {
//        response.status(400).send("Missing senderUid or receiverUid");
//        return;
//      }
//
//      try {
//        const messagesRef = admin.firestore().collection("messages");
//        const snapshot = await messagesRef
//            .where("senderUid", "in", [senderUid, receiverUid])
//            .where("receiverUid", "in", [senderUid, receiverUid])
//            .orderBy("timestamp", "desc")
//            .limit(1)
//            .get();
//
//        if (snapshot.empty) {
//          response.status(404).send("No messages found");
//          return;
//        }
//
//        const lastMessage = snapshot.docs[0].data();
//        response.status(200).send(lastMessage);
//      } catch (error) {
//        console.error("Error getting last message", error);
//        response.status(500).send(error);
//      }
//    });
