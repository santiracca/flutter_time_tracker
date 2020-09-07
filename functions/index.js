const functions = require("firebase-functions");
const admin = require("firebase-admin");

var serviceAccount = require("../functions/time_tracker_permissions.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://timetrqa.firebaseio.com",
});

const express = require("express");
const cors = require("cors");
const app = express();
app.use(cors({ origin: true }));
const db = admin.firestore();

//ROUTES
app.get("/hello-world", (req, res) => {
  return res.status(200).send("Hello World!");
});
//CREATE
app.post("/api/create", (req, res) => {
  (async () => {
    try {
      await db
        .collection("products")
        .doc(req.body.id + "/")
        .create({
          name: req.body.name,
          description: req.body.description,
          price: req.body.price,
        });
      return res.status(200).send();
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// READ ONE PRODUCT
app.get("/api/read/:id", (req, res) => {
  (async () => {
    try {
      const document = db.collection("products").doc(req.params.id);
      let product = await document.get();
      let response = product.data();
      return res.status(200).send(response);
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// READ ALL PRODUCTS
app.get("/api/read/", (req, res) => {
  (async () => {
    try {
      const query = db.collection("products");
      let products = await query.get();
      let response = products.docs;
      let productsList = response.map((doc) => {
        return { id: doc.id, ...doc.data() };
      });
      return res.status(200).send(productsList);
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// UPDATE

app.put("/api/patch/:id", (req, res) => {
  (async () => {
    try {
      await db.collection("products").doc(req.params.id).update({
        name: req.body.name,
        description: req.body.description,
        price: req.body.price,
      });
      const document = db.collection("products").doc(req.params.id);
      let product = await document.get();

      let response = product.data();
      return res.status(200).send(response);
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

/// DELETE
app.delete("/api/delete/:id", (req, res) => {
  (async () => {
    try {
      await db.collection("products").doc(req.params.id).delete();

      return res.status(200).send("Document Deleted Succesfully");
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

//Export the api to firebase cloud functions
exports.app = functions.https.onRequest(app);
