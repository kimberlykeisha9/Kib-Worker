const functions = require("firebase-functions");
const admin = require("firebase-admin");
const Mpesa = require("mpesa-api").Mpesa;

admin.initializeApp();

const db = admin.firestore();

const credentials = {
  clientKey: "Ihm9AlVEIkzWYV4FDAPRU6QiIC5P5H0J",
  clientSecret: "j8P6LAphZgWFArAx",
  initiatorPassword: "bCUmG7ixAeBB8bYBHFd48m9UvSinUqkQvL4o6iOClRN0R" +
      "r4ujI1LA662d50sfk8+wTrV46WRQIEJDyfBieYDAaOZ5U99ENUXDwAb4LgME" +
      "PB6IayaJ4lp8kNUlaYdpuB1ylueJuWRUQ7CZhxj94e4uDDt1RgH8Uwdx8k3g" +
      "XfF20GlJFu0WC44IxvehFAzMEkb8H1NuDTNv8PsEPiM5Noth+08BYuwaDtXy" +
      "jcYS0pq1zh7mHLWRVDCYAxaZ0+gHngq29neXiXoL2TxsY8Gw+iq2NrK/DVD7" +
      "+Cyu4o6YLcVuiJ3Giwam5c2fKysHKoVGpXJccC135691FGucM0t+9lefw==",
};
const environment = "sandbox";

exports.makePayment = functions.https.onCall((data, context) => {
  const mpesa = new Mpesa(credentials, environment);
  const amount = data.amount;
  const paymentNumber = data.paymentNumber;

  return mpesa.c2bSimulate({
    ShortCode: 174379,
    Amount: amount,
    Msisdn: paymentNumber,
  }).then((response) => {
    console.log(response);
    return response;
  }).catch((error) => {
    console.error(error);
    return error;
  });
});

exports.setUserInfo = functions.https.onCall((data, context) => {
  const user = context.auth.uid;

  return db
      .doc("/user-info/" + user)
      .update({
        "basicInformation.profilePicture": data.profile,
        "paymentNumber": data.mpesanumber,
        "selectedJobs": data.selectedjobs,
        "isEngaged": false,
        "accountStatus": "approved",
      });
});

exports.addData = functions.https.onCall((data, context) => {
  const userInfo = {
    basicInformation: {
      firstName: data.fname,
      lastName: data.lname,
      phone: data.phone,
      email: data.email,
      profilePicture: null,
      dob: data.dob,
    },
    accountStatus: "pending",
    dateCreated: admin.firestore.Timestamp.now(),
    id: data.id,
    token: data.token,
  };
  const uid = context.auth.uid;

  return db.doc("/user-info/" + uid).set(userInfo);
});

exports.verifyAccount = functions.firestore
    .document("user-info/{userId}")
    .onUpdate((snapshot, context) => {
    // const accNotVerified = snapshot.before.get("accountStatusVerified");
      const accVerified = snapshot.after.get("accountStatus");
      const approvedPayload = {
        notification: {
          title: "You're account has been verified",
          body: "You can continue setting up you're account",
        },
      };
      const rejectedPayload = {
        notification: {
          title: "You're account has an error",
          body: "Please check your email for more details",
        },
      };
      const token = snapshot.after.get("token");

      if (accVerified == "approved but incomplete") {
        return admin.messaging().sendToDevice(token, approvedPayload);
      }
      if (accVerified == "rejected") {
        return admin.messaging().sendToDevice(token, rejectedPayload);
      }
    });

exports.searchForWorkers = functions.https.onCall((data, context) => {
  const fname = data.fname;
  const lastname = data.lastname;
  const uid = data.uid;
  const selected = data.selected;
  const rating = data.rating;
  const profilePic = data.profile;
  const amount = data.amount;
  const phone = data.phone;
  const token = data.token;

  return admin.messaging().send({
    token: token,
    notification: {
      title: fname + " has a job for you",
    },
    android: {
      priority: "high",
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      type: "Job",
      first: fname,
      last: lastname,
      id: uid,
      jobs: selected,
      rate: rating,
      pp: profilePic,
      phone: phone,
      amount: amount,
    },
  });
});
